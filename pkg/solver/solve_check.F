C $Header$

#include "CPP_OPTIONS.h"

      subroutine solve_check(
     I                        cg2d_b
     I                      , cg2d_x
     I                      , myThid
     &                      )
C     /==========================================================\
C     | SUBROUTINE cg2d_check                                    |
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
      _RL  cg2d_b(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  cg2d_x(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      integer myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
      CHARACTER*(MAX_LEN_MBUF) msgBuf

#ifdef ALLOW_DIRECT_SOLVER
#ifdef ALLOW_USE_MPI

C     === Local variables ====
C     bi, bj      - Block index in X and Y.
C     i, j        - Loop counters
C     err         - Measure of residual of Ax - b, usually the norm.
      INTEGER bi, bj              
      INTEGER i, j
      _RL    err

      err = 0.
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO j=1,sNy
         DO i=1,sNx
          cg2d_r(i,j,bi,bj) = cg2d_b(i,j,bi,bj) -
     &    (aW2d(i  ,j  ,bi,bj)*cg2d_x(i-1,j  ,bi,bj)
     &    +aW2d(i+1,j  ,bi,bj)*cg2d_x(i+1,j  ,bi,bj)
     &    +aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j-1,bi,bj)
     &    +aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j+1,bi,bj)
     &    -aW2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &    -aW2d(i+1,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &    -aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &    -aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &    -freeSurfFac*_rA(i,j,bi,bj)*
     &     cg2d_x(i  ,j  ,bi,bj)/deltaTmom/deltaTmom*cg2dNorm
     &    )
          err            = err            + 
     &     cg2d_r(i,j,bi,bj)*cg2d_r(i,j,bi,bj)
         ENDDO
        ENDDO
       ENDDO
      ENDDO

      _GLOBAL_SUM_R8( err, myThid )
C      write(0,*) 'cg2d: Ax - b = ', sqrt(err)
      WRITE(msgBuf,'(A34,1PE24.14)') 'cg2d: Ax - b =',sqrt(err)
      CALL PRINT_MESSAGE(msgBuf,standardMessageUnit,SQUEEZE_RIGHT,1)

#endif /* ALLOW_USE_MPI */
#endif /* ALLOW_DIRECT_SOLVER */

      end
