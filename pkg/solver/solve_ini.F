C $Header$

#include "CPP_OPTIONS.h"

      subroutine solve_ini(
     I                      myThid
     &                    )
C     /==========================================================\
C     | SUBROUTINE solve_ini                                     |
C     | o Two-dimensional grid direct solver initialization      |
C     |==========================================================|
C     | It requires the to be symmetric.                         |
C     | This implementation assumes A is a five-diagonal         |
C     | matrix of the form that arises in the discrete           |
C     | representation of the del^2 operator in a                |
C     | two-dimensional space.                                   |
C     \==========================================================/
      implicit none

C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "PARAMS.h"
#include "GRID.h"
#include "SURFACE.h"

#include "CG2D.h"
#include "solve_direct.h"

C     === Routine arguments ===
C     myThid - Thread on which I am working.
      integer myThid

#ifdef ALLOW_DIRECT_SOLVER
#ifdef ALLOW_USE_MPI

C     === Local variables ====
C     bi, bj      - Block index in X and Y.
C     i, j        - Loop counters
      integer bi, bj              
      integer i, j
      integer l, lm, m, k, ks, ip, ly
      integer l1, l2

      double precision brhs(2:sNy,2:sNx,nrhs)
      double precision brhsa(2:sNy,2:sNx,nrhs)
      double precision zz(nrhs,nrhs)
      double precision sum
      double precision qq(ninterf,ninterf)

      integer lm1, lm2, lm3
      integer it, itt, itn, its, ite, itw
      integer ipx, ipy
      integer info

      integer    nn
      parameter( nn = ninterf*ntiles )
      integer    bw
      parameter( bw = ninterf*nPx )
      integer    laf
      parameter( laf = (ninterf+2*bw)*bw )
      integer    lwork
      parameter( lwork = bw*bw )
      integer    dlen
      parameter( dlen = 9 )

C--   nb : blocking factor to distribute A
      integer    nb
cc      parameter( nb = )

      integer ictxt
      double precision af(laf)
      double precision work(lwork)
      integer iam

      integer desca(dlen)
cc    double precision aband(bw+1,ninterf)
      double precision aa(nn,ninterf)

      integer descb(dlen)
      double precision bb(ninterf*nPy,ninterf*nPx)

      integer nss
      character*(*) fname
      parameter(    fname = 'ss_matrix' )
      character*(*) fnamec
      parameter(    fnamec = 'ss_matrix.001.001.data' )
      logical file_exist

      double precision weig(nsolve)

      _RL cent(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1-Oly,sNy+Oly
         DO I=1-Olx,sNx+Olx
          cg2d_r(I,J,bi,bj) = 0.0
         ENDDO
        ENDDO
       ENDDO
      ENDDO

#define WRITE_SOLVER
#ifdef  WRITE_SOLVER
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
          cent(I,J,bi,bj) = freeSurfFac*_rA(i,j,bi,bj)
     &         /deltaTmom/deltaTmom*cg2dNorm
     &         *recip_Bo(i,j,bi,bj)
         ENDDO
        ENDDO
       ENDDO
      ENDDO
cc      CALL WRITE_FLD_XY_RS( 'aw2d' , 'p', aW2d, 0, myThid)
cc      CALL WRITE_FLD_XY_RS( 'as2d' , 'p', aS2d, 0, myThid)
cc      CALL WRITE_FLD_XY_RS( 'cent' , 'p', help, 0, myThid)
      call MDSWRITEFIELD( 'aw2d', precFloat32, .false., 'RS'
     &                  , 1, aW2d, 1, 0, myThid
     &                  )
      call MDSWRITEFIELD( 'as2d', precFloat32, .false., 'RS'
     &                  , 1, aS2d, 1, 0, myThid
     &                  )
      call MDSWRITEFIELD( 'cent', precFloat64, .false., 'RL'
     &                  , 1, cent, 1, 0, myThid
     &                  )
CRG
#endif


C--   do it for all local tiles
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)

C--     A_i is block tridiagonal, diagonal blocks are tridiagonal
C--                               other blocks are diagonal
C--     A_i is banded
C--     we are only using the band structure!
        do i = 2,sNx
         do j = 2,sNy
          do l = 1, kdsolve+1
           solve_band(l,j,i,bi,bj) = 0.0
          end do
         end do
        end do

C 1         : diagonal
C 1+1       : first lower subdiagonal (j-1)
C 1+kdsolve : sNy-1 lower subdiagonal (i-1)
C           : all other lower subdiagonals are zero

        do i = 2,sNx
         do j = 2,sNy
          solve_band(1,j,i,bi,bj) =
     &             aW2d(i  ,j  ,bi,bj)*1.d0
     &           + aW2d(i+1,j  ,bi,bj)*1.d0
     &           + aS2d(i  ,j  ,bi,bj)*1.d0
     &           + aS2d(i  ,j+1,bi,bj)*1.d0
     &           + freeSurfFac*_rA(i,j,bi,bj)*1.d0*recip_Bo(i,j,bi,bj)
     &             / deltaTmom/deltaTmom*cg2dNorm

          if (j .gt. 2) then
             solve_band(        2,j-1,i  ,bi,bj) = - aS2d(i,j,bi,bj)
          endif
          if (i .gt. 2) then
             solve_band(kdsolve+1,j  ,i-1,bi,bj) = - aW2d(i,j,bi,bj)
          endif

         end do
        end do

#ifdef CHECK_EIGENVALUES
        call DSBEV ( 'N', 'L', nsolve, kdsolve
     &             , solve_band(1,2,2,bi,bj), kdsolve+1
     &             , weig, 0.0, 1, WORK, info
     &             )
        _BEGIN_MASTER( myThid )
        write(0,*)  'SOLVE_INI: eigen = ', info
        do i = 1, nsolve
           write(6,*) i, weig(i)
        end do
        _END_MASTER( )
        call eedie
#endif

C--     compute Cholesky factors A_i = L_i^t L_i
        call DPBTRF( 'L', nsolve, kdsolve, solve_band(1,2,2,bi,bj)
     &             , kdsolve+1, info
     &             )
        _BEGIN_MASTER( myThid )
        write(0,*) 'SOLVE_INI: DPBTRF info = ', info
        _END_MASTER( )

       end do
      end do


C--   check wether file with matrix exists
      nss = ninterf*ntiles*ninterf
      inquire( FILE=fnamec, EXIST=file_exist ) 
      if (file_exist) then
C--     read file
         _BEGIN_MASTER( myThid )
         write(0,*) ' file containing inverse matrix exists'
         _END_MASTER( )

         use_cg2d = .false.

         call MDSREADVECTOR( fname, precFloat64, 'RL'
     &                     , nss, ss, 1, 1, 1, myThid
     &                     )

C--   file does not exist - build it
      else
         _BEGIN_MASTER( myThid )
         write(0,*) ' file does not exist'
         write(0,*) ' please construct it with matlab'
         _END_MASTER( )

C         use_cg2d = .true.
         call eedie

#ifdef THIS_PART_IS_NOT_READY_FOR_PRIME_TIME_YET
C--     ini ss
         do m = 1, ninterf
            do it = 1, ntiles
               do l = 1, ninterf
                  ss(l,it,m) = 0.0
               end do
            end do
         end do


      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
c-- add contribution from south and east
C-- to update local owned interface values

C every communication contains four lines of interface values (S,N,E,W)
C send zz(1:nrhs,1+lm1:sNx+lm1) to north
C recv zz(1:nrhs,1    :sNx    ) from south and add (south,south) part
C send zz(1:nrhs,1+lm3:sNy+lm3) to west
C recv zz(1:nrhs,1+lm2:sNy+lm2) from east and add (east,east) part

C send brhs(2:sNx,sNy,i-1+lm1) to north
C recv brhs(2:sNx,  2,i-1    ) from south and add
C send brhs(sNx,2:sNy,j-1+lm3) to west
C recv brhs(  2,2:sNy,j-1+lm2) from east and add

#ifdef SHEMATIC
        do i = 2,sNx
         brhs(i,  2,i-1   ) = brhs(i,  2,i-1   ) + SOUTH_T( brhs(i,sNy,i-1+lm1) )
        end do
        do j = 2,sNy
         brhs(  2,j,j-1+lm2) = brhs(  2,j,j-1+lm2) + EAST_T( brhs(sNx,j,j-1+lm3) )
        end do
#endif

CCCC missing

C--     build ownly owned part of Q
C--     the local Q (interface,interface) contribution to S
C--     ordering south (1:sNx,1) east (2:sNy,1)

C--     ss(a,b,c)
C--     a : local array index
C--     b,c contribution from other tiles
C--     b : array index
C--     c : tile index

        itt = tileNo (bi,bj)
        its = tileNoS(bi,bj)
        itn = tileNoN(bi,bj)
        ite = tileNoE(bi,bj)
        itw = tileNoW(bi,bj)

C--     contribution from east
        j = 1
        do i = 2,sNx
           l = i
           m = i-1
           ss(l,m,itt) = ss(l,m,itt) + aW2d(i,j,bi,bj)
        end do
        ss(1,sNx,ite) = ss(1,sNx,ite) + aW2d(1,j,bi,bj)

C--     contribution from west
        do i = 1,sNx-1
           l = i
           ip = i+1
           ss(l,ip,itt) = ss(l,ip,itt) + aW2d(i+1,j,bi,bj)
        end do
        ss(sNx,1,itw) = ss(sNx,1,itw) + aW2d(sNx,j,bi,bj)

C--     contribution from south
C--     attention grid point (1,1) is first in ninterf
        i = 1
        lm1 = sNx
        do j = 2,sNy
           l = j   + lm1
           m = j-1 + lm1
           ss(l,m,itt) = ss(l,m,itt) + aS2d(i,j,bi,bj)
        end do
        ss(1,sNy+lm1,its) = ss(1,sNy+lm1,its) + aS2d(i,1,bi,bj)

C--     contribution from north
        do j = 1,sNy-1
           l = j   + sNx
           ip = j+1 + sNx
           ss(l,ip,itt) = ss(l,ip,itt) + aS2d(i  ,j+1,bi,bj)
        end do
        ly = sNy+lm1
        ss(ly,1+lm1,itn) = ss(ly,1+lm1,itn) + aS2d(i,sNy+1,bi,bj)

        ss(1 ,sNx  ,its) = ss(1 ,sNx  ,its) + aW2d(1, j   ,bi,bj)

       end do
      end do

C--     test ini ss
#define DIAGONAL_SS
#ifdef  DIAGONAL_SS
        do l = 1, ninterf
           do m = 1, ninterf
              do it = 1, ntiles
                 ss(l,m,it) = 0.0
              end do
           end do
        end do
        do l = 1, ninterf
           ss(l,l,itt) = 1.0
        end do
#endif



#ifdef ALLOW_USE_MPI

C--   Define process grid
      call blacs_pinfo( iam, Nprocs )
      print *, 'blacs_pinfo     NPROCS = ', Nprocs, iam

      call blacs_get( 0, 0, ictxt )
      call blacs_gridinit( ictxt, 'R', nPx, nPy )

#ifdef SOLVE_BAND
C--   DISTRIBUTE THE MATRIX ON THE PROCESS GRID
C--   Initialize the array descriptors for the matrices A and B
      nb = ninterf

      call descinit( desca, (bw+1), nn
     &             , (bw+1), nb, 0, 0, ictxt, bw+1
     &             , info
     &             )

      do l = 1, ninterf
         do m = 1, ninterf
            do it = itt, ntiles
               j = m + (it-itt)*ninterf
               aa(j,l) = ss(l,m,it)
            end do
         end do
      end do

      call pdpbtrf( 'u', ninterf*ntiles, bw, aband, 1
     &            , desca, af, laf, work, lwork, info
     &            )
#else

      do l = 1, ninterf
         do m = 1, ninterf
            do it = itt, ntiles
               j = m + (it-itt)*ninterf
               aa(j,l) = ss(l,m,it)
            end do
         end do
      end do
      print *, 'matrix set'

C--   define distribution of array aa
      call descinit( desca, nn, nn
     &             , nn, ninterf, 0, 0, ictxt, nn
     &             , info
     &             )

C--   define distribution of array bb
      call descinit( descb, nn, nn
     &             , ninterf*nPy, ninterf*nPx, 0, 0, ictxt, ninterf*nPy
     &             , info
     &             )

      print *, 'matrix distributions set'
#ifdef doit
      call pdgemr2d( nn, ninterf
     &             , aa, 0, 0, desca
     &             , bb, 0, 0, descb
     &             , ictxt
     &             )
      print *, 'matrix redistributed'

      call pdpotrf( 'u', nn, bb, 1, 1, descb, info )
#endif
#endif

      print *, 'SOLVE_INI: info5 = ', info

C--   Check info for error conditions
      if( info .ne. 0) then
         if( info .lt. 0) then
            CALL PXERBLA( ictxt, 'PDPBSV', -info )
         endif
      endif
#endif

         call MDSWRITEVECTOR( fname, precFloat64, .false., 'RL'
     &                      , nss, ss, 1, 1, 1, 0, myThid
     &                      )
#endif
      endif

#endif /* ALLOW_USE_MPI */
#endif /* ALLOW_DIRECT_SOLVER */

      end
