C $Header$

#include "CPP_OPTIONS.h"

      subroutine solve_interface(
     I                            cg2d_r
     I                          , myThid
     &                          )
C     /==========================================================\
C     | SUBROUTINE solve_interface
C     | o Two-dimensional grid direct interface solver
C     | assuming ring topology to pass information
C     | written by Ralf Giering
C     |==========================================================|
      implicit none

C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "PARAMS.h"
#include "GRID.h"

#include "solve_direct.h"

C     === Routine arguments ===
C     cg2d_r - work array, only interface part is used
C     myThid - Thread on which I am working.
      _RL     cg2d_r(1-Olx:sNx+Olx,1-Oly:sNy+Oly,nSx,nSy)
      integer myThid

#if defined(ALLOW_USE_MPI)

C     === Local variables ====
C     bi, bj      - Block index in X and Y.
C     i, j        - Loop counters
      integer    npp
      parameter( npp = nPx*nPy )

C      _RL     x(1-1:sNx+1,1-1:sNy+1,nSx,nSy)
      integer bi, bj              
      integer i, j
      integer l, m, iproc

      _RL sum
      _RL res(ninterf,nSx,nSy)

      integer ip

#ifdef ALLOW_USE_MPI
      double precision sendbuf(ninterf*nSx*nSy)
      integer    theType
      parameter( theType = MPI_DOUBLE_PRECISION )

      integer    sendsize
      parameter( sendsize = ninterf*nSx*nSy )

      INTEGER toproc, frproc
      INTEGER theTag
      INTEGER exchReq
      INTEGER mpiRc
      INTEGER status
#endif

#ifdef ALLOW_USE_MPI
C--   gather all local interface values into send buffer
C--   and initialise result array
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=1,sNx
         l = i         + (bi-1)*ninterf + (bj-1)*nSx*ninterf
         sendbuf(l) = cg2d_r(i,1,bi,bj)
        end do
        do j=2,sNy
         l = sNx + j-1 + (bi-1)*ninterf + (bj-1)*nSx*ninterf
         sendbuf(l) = cg2d_r(1,j,bi,bj)
        end do
        do m = 1, ninterf
         res(m,bi,bj) = 0.0
        end do
       end do
      end do

C--   send to next processor and receive from previous
      toproc = mod( myProcId+1              , numberOfProcs )
      frproc = mod( myProcId-1+numberOfProcs, numberOfProcs )

C--   first vector part is the local owned one
      iproc = myProcId

C--   broadcast local part of RHS to all processes
      do ip = 1, numberOfProcs-1

C--      send vector part
         theTag = ip
         CALL MPI_Isend( sendbuf, sendsize, theType
     &                 , toproc, theTag, MPI_COMM_MODEL
     &                 , exchReq, mpiRc )

         if (mpiRc .ne. 0) then
            write(0,*) 'solve_interface: MPI_Isend = ', mpiRc
         end if

cbnc 	call wait is missing 
  	 CALL MPI_WAIT(exchReq,status,mpiRc)

c--      perform local submatrix subvector product
         do bj=myByLo(myThid),myByHi(myThid)
          do bi=myBxLo(myThid),myBxHi(myThid)
           do m = 1, ninterf
            sum = 0.0
            do l = 1, ninterf*nSx*nSy
             sum = sum - ss(l,iproc+1,m) * sendbuf(l)
            end do
            res(m,bi,bj) = res(m,bi,bj) + sum
           end do
          end do
         end do

C--      receive vector part
         theTag = ip
         CALL MPI_recv( sendbuf, sendsize, theType
     &                , frproc, theTag, MPI_COMM_MODEL
     &                , status, mpiRc )

         if (mpiRc .ne. 0) then
            write(0,*) 'solve_interface: MPI_recv = ', mpiRc
         end if

         iproc = mod( myProcId-ip+numberOfProcs, numberOfProcs )
      end do


c--   do final local submatrix subvector product
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do m = 1, ninterf
         sum = 0.0
         do l = 1, ninterf*nSx*nSy
            sum = sum - ss(l,iproc+1,m) * sendbuf(l)
         end do
         res(m,bi,bj) = res(m,bi,bj) + sum
        end do
       end do
      end do
#endif

C--   scatter local interface values
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=1,sNx
         cg2d_r(i,1,bi,bj) = res(i,bi,bj)
        end do
        do j=2,sNy
         cg2d_r(1,j,bi,bj) = res(sNx+j-1,bi,bj)
        end do
       end do
      end do

#endif

      end
