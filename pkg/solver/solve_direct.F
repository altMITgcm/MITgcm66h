C $Header$

#include "CPP_OPTIONS.h"

      subroutine solve_direct(
     I                         cg2d_b
     U                       , cg2d_x
     I                       , myThid
     &                       )
C     /==========================================================\
C     | SUBROUTINE SOLVE_DIRECT                                  |
C     | o Two-dimensional grid problem dirext solver             |
C     | written by Ralf Giering
C     |==========================================================|
C     | It requires the A be symmetric positiv definit           |
C     | This implementation assumes A is a five-diagonal         |
C     | matrix of the form that arises in the discrete           |
C     | representation of the del^2 operator in a                |
C     | two-dimensional space.                                   |
C     |
C     | This code is not Thread safe yet!
C     | It is assumed nsx=nsy=1.
C     | The exchanges need only be done in S and W not in N and E.
C     | Some overlapping of communications and computations.
C     |
C     |
C     |
C     \==========================================================/
      implicit none

C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "CG2D.h"

C     === Routine arguments ===
C     myThid - Thread on which I am working.
      _RL  cg2d_x(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  cg2d_b(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      integer myThid

#ifdef ALLOW_DIRECT_SOLVER
#ifdef ALLOW_USE_MPI

C     === Local variables ====
C     bi, bj      - Block index in X and Y.
C     i, j        - Loop counters
      integer bi, bj              
      integer i, j
      _RL    rhsMax
      _RL    rhsNorm

#define SOLVE_LOCAL_CG_NO

#define CG2D_CHECKIT_NO


#ifdef  CG2D_CHECKIT
C--   use cg-solver to get right interface values
      call cg2d( cg2d_b, cg2d_x, myThid )

C--   update edges
      _EXCH_XY_R8(cg2d_x, myThid )

#ifdef WRITEOUT
      call MDSWRITEFIELD( 'cg2d_x', precFloat64, .false., 'RL'
     &                      , 1, cg2d_x, 1, 1, myThid
     &                      )
      call MDSWRITEFIELD( 'cg2d_b', precFloat64, .false., 'RL'
     &                      , 1, cg2d_b, 1, 1, myThid
     &                      )


      call eedie
#endif

crg      call solve_check( cg2d_b, cg2d_x, myThid )

C--   remove all information keep only the interface values
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do j=2,sNy
         do i=2,sNx
          cg2d_x(i,j,bi,bj) = 0.0
         end do
        end do
       end do
      end do

#else

      CALL TIMER_START('ZZZZ PREPRO1', myThid)

C--   loop over all local tiles
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)

C--   apply normalization
      rhsMax = 0. _d 0
        DO j=1,sNy
         DO i=1,sNx
          cg2d_b(i,j,bi,bj) = cg2d_b(i,j,bi,bj)*cg2dNorm
          rhsMax = MAX(ABS(cg2d_b(I,J,bi,bj)),rhsMax)
         ENDDO
        ENDDO

       end do
      end do

      IF (cg2dNormaliseRHS) THEN
C-  Normalise RHS :
#ifdef LETS_MAKE_JAM
C     _GLOBAL_MAX_R8( rhsMax, myThid )
      rhsMax=1.
#else
      _GLOBAL_MAX_R8( rhsMax, myThid )
Catm  rhsMax=1.
#endif
      rhsNorm = 1. _d 0
      IF ( rhsMax .NE. 0. ) rhsNorm = 1. _d 0 / rhsMax
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
          cg2d_b(I,J,bi,bj) = cg2d_b(I,J,bi,bj)*rhsNorm
          cg2d_x(I,J,bi,bj) = cg2d_x(I,J,bi,bj)*rhsNorm
         ENDDO
        ENDDO
       ENDDO
      ENDDO
C- end Normalise RHS
      ENDIF

C--   Update overlaps
      _EXCH_XY_R8( cg2d_b, myThid )
      _EXCH_XY_R8( cg2d_x, myThid )

      CALL TIMER_STOP('ZZZZ PREPRO1', myThid)

C--   loop over all local tiles
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)

C--     set interface values to zero
        do i=1,sNx+1
         cg2d_x(i,    1,bi,bj) = 0.d0
         cg2d_x(i,sNy+1,bi,bj) = 0.d0
        end do
        do j=1,sNy+1
         cg2d_x(    1,j,bi,bj) = 0.d0
         cg2d_x(sNx+1,j,bi,bj) = 0.d0
        end do

C--     solve for interior points
       CALL TIMER_START('ZZZZ LOCAL', myThid)
#ifdef SOLVE_LOCAL_CG
        call solve_local_cg( bi, bj, cg2d_b, cg2d_x, myThid )
#else
        call solve_local( bi, bj, cg2d_b, cg2d_x, myThid )
#endif
       CALL TIMER_STOP('ZZZZ LOCAL', myThid)

       end do
      end do

C--   set intermediate interface values compute E_k^t y_k
      CALL TIMER_START('ZZZZ PREPRO4', myThid)

      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)

        DO j=1-Oly,sNy+Oly
         DO i=1-Olx,sNx+Olx
          cg2d_r(i,j,bi,bj) = 0.0
         ENDDO
        ENDDO

        do j=2,sNy
         i = 1
         cg2d_r(i,j,bj,bj) = - aW2d(i+1,j,bi,bj)*cg2d_x(i+1,j,bi,bj)
         i = sNx+1
         cg2d_r(i,j,bj,bj) = - aW2d(i  ,j,bi,bj)*cg2d_x(i-1,j,bi,bj)
        end do
       end do
      end do

      call EXCH_RL_SEND_PUT_X( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , REVERSE_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )

      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=2,sNx
         j = 1
         cg2d_r(i,j,bj,bj) = - aS2d(i,j+1,bi,bj)*cg2d_x(i,j+1,bi,bj)
         j = sNy+1
         cg2d_r(i,j,bj,bj) = - aS2d(i,j  ,bi,bj)*cg2d_x(i,j-1,bi,bj)
        end do
       end do
      end do

      call EXCH_RL_SEND_PUT_Y( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , REVERSE_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )

C--   sum intermediate interface values from neighboring tiles
      call EXCH_RL_RECV_GET_X( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , REVERSE_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )
      call EXCH_RL_RECV_GET_Y( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , REVERSE_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )

      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=1,sNx
         cg2d_r(i,1,bi,bj) = - cg2d_b(i,1,bi,bj) - cg2d_r(i,1,bi,bj)
        end do
       end do
      end do

      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do j=2,sNy
         cg2d_r(1,j,bi,bj) = - cg2d_b(1,j,bi,bj) - cg2d_r(1,j,bi,bj)
        end do
       end do
      end do

      CALL TIMER_STOP('ZZZZ PREPRO4', myThid)

C--   solve for interface values
C--   interface value vector is distributed among processors
C--   factorization of matrix S is also distributed
      CALL TIMER_START('ZZZZ INTERFACE', myThid)
C#define SOLVE_INTERFACE_ALLGATHER
#ifdef  SOLVE_INTERFACE_ALLGATHER
      call solve_interface_allgather( cg2d_r, myThid )
#else
      call solve_interface( cg2d_r, myThid )
#endif
      CALL TIMER_STOP('ZZZZ INTERFACE', myThid)

C--   get interface values from neighboring tiles
      CALL TIMER_START('ZZZZ POSTPRO', myThid)

C--   corners not necessary!!!
      call EXCH_RL_SEND_PUT_X( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , FORWARD_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )
      call EXCH_RL_SEND_PUT_Y( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , FORWARD_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )
      call EXCH_RL_RECV_GET_X( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , FORWARD_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )

C--   set interface values of result array
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do j=2,sNy
         i = 1
         cg2d_x(i,j,bi,bj) = cg2d_r(i,j,bi,bj)
         i = sNx+1
         cg2d_x(i,j,bi,bj) = cg2d_r(i,j,bi,bj)
        end do
       end do
      end do

      call EXCH_RL_RECV_GET_Y( cg2d_r, Olx, Olx, Oly, Oly, 1, 1, 1
     I     , FORWARD_SIMULATION, EXCH_IGNORE_CORNERS, myThid
     &     )

C--   set interface values of result array
      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
        do i=1,sNx
         j = 1
         cg2d_x(i,j,bi,bj) = cg2d_r(i,j,bi,bj)
         j = sNy+1
         cg2d_x(i,j,bi,bj) = cg2d_r(i,j,bi,bj)
        end do
       end do
      end do

      CALL TIMER_STOP('ZZZZ POSTPRO', myThid)

#endif

C--   now the interface values are known
C--   solve for interior points
      CALL TIMER_START('ZZZZ LOCAL', myThid)

      do bj=myByLo(myThid),myByHi(myThid)
       do bi=myBxLo(myThid),myBxHi(myThid)
#ifdef SOLVE_LOCAL_CG
        call solve_local_cg( bi, bj, cg2d_b, cg2d_x, myThid )
#else
        call solve_local( bi, bj, cg2d_b, cg2d_x, myThid )
#endif
       end do
      end do

      CALL TIMER_STOP('ZZZZ LOCAL', myThid)

      IF (cg2dNormaliseRHS) THEN
C--   Un-normalise the answer
        DO bj=myByLo(myThid),myByHi(myThid)
         DO bi=myBxLo(myThid),myBxHi(myThid)
          DO J=1,sNy
           DO I=1,sNx
            cg2d_x(I  ,J  ,bi,bj) = cg2d_x(I  ,J  ,bi,bj)/rhsNorm
           ENDDO
          ENDDO
         ENDDO
        ENDDO
      ENDIF

#endif /* ALLOW_USE_MPI */
#endif /* ALLOW_DIRECT_SOLVER */

      end
