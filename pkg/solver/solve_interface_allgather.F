C $Header$

#include "CPP_OPTIONS.h"

      subroutine solve_interface_allgather(
     I                                      cg2d_r
     I                                    , myThid
     &                                    )
C     /==========================================================\
C     | SUBROUTINE solve_interface_allgather
C     | o Two-dimensional grid direct interface solver
C     | using ALLGATHER to pass information
C     | is slower than solve_interface
C     | written by Ralf Giering
C     \==========================================================/
      implicit none

C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "PARAMS.h"
#include "GRID.h"

#include "solve_direct.h"

C     === Routine arguments ===
C     myThid - Thread on which I am working.
      _RL     cg2d_r(1-Olx:sNx+Olx,1-Oly:sNy+Oly,nSx,nSy)
      integer myThid

#if defined(ALLOW_USE_MPI)

C     === Local variables ====
C     bi, bj      - Block index in X and Y.
C     i, j        - Loop counters
      integer    npp
      parameter( npp = nPx*nPy )

      integer bi, bj              
      integer i, j
      integer l, m, iproc
      integer ierror

#ifdef ALLOW_USE_MPI
      double precision sendbuf(ninterf,nSx,nSy)
      double precision recvbuf(ninterf*nSx*nSy,npp)
      integer    theType
      parameter( theType = MPI_DOUBLE_PRECISION )

      integer    sendsize
      parameter( sendsize = ninterf*nSx*nSy )
      integer    recvsize
      parameter( recvsize = ninterf*nSx*nSy )

#endif
      _RL     sum
      _RL     res(ninterf,nSx,nSy)

#ifdef ALLOW_USE_MPI
C--   gather all local interface values into send buffer
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=1,sNx
         j = 1
         sendbuf(i,bi,bj) = cg2d_r(i,j,bi,bj)
        end do
        do j=2,sNy
         i = 1
         sendbuf(sNx+j-1,bi,bj) = cg2d_r(i,j,bi,bj)
        end do
       end do
      end do

C--   broadcast local part of RHS to all processes
      CALL TIMER_START('ZZZZ GATHER', myThid)

      call MPI_Allgather(  sendbuf, sendsize, theType
     &                   , recvbuf, recvsize, theType
     &                   , MPI_COMM_MODEL, ierror
     &                   )

      CALL TIMER_STOP('ZZZZ GATHER', myThid)

      if (ierror .ne. 0) then
         write(0,*) 'solve_interface: MPI_Allgather ierror = ', ierror
      end if

      CALL TIMER_START('ZZZZ MAT*VEC', myThid)
C--   compute x = inv(S) * y
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do m = 1, ninterf
         sum = 0.0
         do iproc = 1, npp
            do l = 1, ninterf*nSx*nSy
               sum = sum - ss(l,iproc,m) * recvbuf(l,iproc)
            end do
         end do
         res(m,bi,bj) = sum
        end do
       end do
      end do

C--   scatter local interface values
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=1,sNx
         j = 1
         cg2d_r(i,j,bi,bj) = res(i,bi,bj)
        end do
        do j=2,sNy
         i = 1
         cg2d_r(i,j,bi,bj) = res(sNx+j-1,bi,bj)
        end do
       end do
      end do
      CALL TIMER_STOP('ZZZZ MAT*VEC', myThid)
#endif

#endif

      end
