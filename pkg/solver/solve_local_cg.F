C $Header$

#include "CPP_OPTIONS.h"

#define DEBUG_CG2DLOC_NO

      subroutine solve_local_cg(
     I                           bi, bj
     I                         , cg2d_b
     U                         , cg2d_x
     I                         , mythid
     &                         )
C     /==========================================================\
C     | SUBROUTINE SOLVE_LOCAL                                   |
C     |==========================================================|
C     \==========================================================/
      implicit none

C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "CG2D.h"

C     cg2dloc_q - Intermediate matrix-vector product term
C     cg2dloc_r -   "
C     cg2dloc_s -   "
      _RL  cg2dloc_q(1:sNx,1:sNy)
      _RL  cg2dloc_r(1:sNx+1,1:sNy+1)
      _RL  cg2dloc_s(1:sNx+1,1:sNy+1)

C     === Routine arguments ===
C     myThid - Thread on which I am working.
      integer bi, bj
      _RL     cg2d_b(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL     cg2d_x(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      integer mythid

#if defined(ALLOW_USE_MPI)

C     === Local variables ====
C     actualIts      - Number of iterations taken
C     actualResidual - residual
C     etaN        - Used in computing search directions
C     etaNM1        suffix N and NM1 denote current and
C     cgBeta        locvious iterations respectively.
C     alpha  
C     sumRHS      - Sum of right-hand-side. Sometimes this is a
C                   useful debuggin/trouble shooting diagnostic.
C                   For neumann problems sumRHS needs to be ~0.
C                   or they converge at a non-zero residual.
C     err         - Measure of residual of Ax - b, usually the norm.
C     i, j        - Loop counters

      INTEGER actualIts
      _RL     actualResidual
      INTEGER i, j, it2d
      _RL     err
      _RL     etaN
      _RL     etaNM1
      _RL     cgBeta
      _RL     alpha
      _RL     sumRHS
      _RL     targetres
      _RL     rr

C--   Initialise inverter
      etaNM1 = 1.

C--   Initial residual calculation
      DO j=1,sNy+1
         DO i=1,sNx+1
            cg2dloc_s(i,j) = 0.
         ENDDO
      ENDDO

      DO j=2,sNy
         DO i=2,sNx
            cg2dloc_r(i,j)     = cg2d_b(i,j,bi,bj) -
     &           (aW2d(i  ,j  ,bi,bj)*cg2d_x(i-1,j  ,bi,bj)
     &           +aW2d(i+1,j  ,bi,bj)*cg2d_x(i+1,j  ,bi,bj)
     &           +aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j-1,bi,bj)
     &           +aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j+1,bi,bj)
     &           -aW2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aW2d(i+1,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -freeSurfFac*_rA(i,j,bi,bj)*
     &           cg2d_x(i  ,j  ,bi,bj)/deltaTmom/deltaTmom*cg2dNorm
     &           )
         ENDDO
      ENDDO

      err    = 0.
      sumRHS = 0.
      DO j=2,sNy
         DO i=2,sNx
            err    = err    + cg2dloc_r(i,j)*cg2dloc_r(i,j)
            sumRHS = sumRHS + cg2d_b(i,j,bi,bj)
         ENDDO
      ENDDO

      _BEGIN_MASTER( myThid )
      write(0,'(A,1PE30.14)') 'CG2DLOC: Sum(rhs) = ',sumRHS
      _END_MASTER( )

      actualIts      = 0
      actualResidual = SQRT(err)

C     _BARRIER
      _BEGIN_MASTER( myThid )
      WRITE(0,'(A,I6,1PE30.14)') ' CG2DLOC iters, err = ', 
     &     actualIts, actualResidual
      _END_MASTER( )

      targetres = cg2dTargetResidual * (nSx*nSy*nPx*nPy)

C     >>>>>>>>>>>>>>> BEGIN SOLVER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      DO 10 it2d=1, cg2dMaxIters

#ifdef DEBUG_CG2DLOC
         call flush(0)
         call flush(1)
         WRITE(0,*) ' CG2DLOC: Iteration ',it2d-1,' residual = ',
     &        actualResidual
#endif /* DEBUG_CG2DLOC */

         IF ( err .lt. targetres ) GOTO 11

C--    Solve preconditioning equation and update
C--    conjugate direction vector "s".
         etaN = 0.
         DO j=2,sNy
            DO i=2,sNx
#ifdef PRECONDITION
               cg2dloc_q(i,j) = 
     &               pC(i  ,j  ,bi,bj)*cg2dloc_r(i  ,j  )
     &              +pW(i  ,j  ,bi,bj)*cg2dloc_r(i-1,j  )
     &              +pW(i+1,j  ,bi,bj)*cg2dloc_r(i+1,j  )
     &              +pS(i  ,j  ,bi,bj)*cg2dloc_r(i  ,j-1)
     &              +pS(i  ,j+1,bi,bj)*cg2dloc_r(i  ,j+1)
#else
               cg2dloc_q(i,j) =  cg2dloc_r(i  ,j  )
#endif
               etaN = etaN + cg2dloc_q(i,j)*cg2dloc_r(i,j)
            ENDDO
         ENDDO

#ifdef DEBUG_CG2DLOC
         WRITE(0,*) ' CG2DLOC: Iteration ',it2d-1,' etaN = ',etaN
         WRITE(0,*) ' CG2DLOC: Iteration ',it2d-1,' beta = ',etaN/etaNM1
#endif /* DEBUG_CG2DLOC */

         cgBeta = etaN/etaNM1
         etaNM1 = etaN

         DO j=2,sNy
            DO i=2,sNx
               cg2dloc_s(i,j) = cg2dloc_q(i,j) + cgBeta*cg2dloc_s(i,j)
            ENDDO
         ENDDO

C--    Evaluate laplace operator on conjugate gradient vector
C--    q = A.s
       alpha = 0.
       DO j=2,sNy
          DO i=2,sNx
             cg2dloc_q(i,j) = 
     &             aW2d(i  ,j  ,bi,bj)*cg2dloc_s(i-1,j  )
     &            +aW2d(i+1,j  ,bi,bj)*cg2dloc_s(i+1,j  )
     &            +aS2d(i  ,j  ,bi,bj)*cg2dloc_s(i  ,j-1)
     &            +aS2d(i  ,j+1,bi,bj)*cg2dloc_s(i  ,j+1)
     &            -aW2d(i  ,j  ,bi,bj)*cg2dloc_s(i  ,j  )
     &            -aW2d(i+1,j  ,bi,bj)*cg2dloc_s(i  ,j  )
     &            -aS2d(i  ,j  ,bi,bj)*cg2dloc_s(i  ,j  )
     &            -aS2d(i  ,j+1,bi,bj)*cg2dloc_s(i  ,j  )
     &            -freeSurfFac*_rA(i,j,bi,bj)*
     &            cg2dloc_s(i  ,j  )/deltaTmom/deltaTmom*cg2dNorm
             alpha = alpha + cg2dloc_s(i,j)*cg2dloc_q(i,j)
          ENDDO
       ENDDO

#ifdef DEBUG_CG2DLOC
       WRITE(0,*) ' CG2DLOC: Iteration ',it2d-1,' SUM(s*q)= ',alpha
       WRITE(0,*) ' CG2DLOC: Iteration ',it2d-1,' alpha= ', etaN/alpha
#endif /* DEBUG_CG2DLOC */

       alpha = etaN/alpha

C--    Update solution and residual vectors

C--    update solution
       DO j=2,sNy
          DO i=2,sNx
             cg2dloc_r(i,j) =
     &       cg2dloc_r(i,j) - alpha*cg2dloc_q(i,j)
          ENDDO
       ENDDO
       DO j=2,sNy
          DO i=2,sNx
             cg2d_x(i,j,bi,bj) =
     &       cg2d_x(i,j,bi,bj) + alpha*cg2dloc_s(i,j)
          ENDDO
       ENDDO

C--    compute residual only for specific iterations
         err = 0.
         DO j=2,sNy
            DO i=2,sNx
               err = err + cg2dloc_r(i,j)*cg2dloc_r(i,j)
            ENDDO
         ENDDO
         err = SQRT(err)

         actualIts      = it2d
         actualResidual = err

         IF ( err .LT. targetres ) GOTO 11

 10   CONTINUE
 11   CONTINUE


      IF (actualIts .GE. cg2dMaxIters) THEN
         write(0,*) 'CG2DLOC: to many iterations'
         CALL EEDIE
      ENDIF

      _BEGIN_MASTER( myThid )
      WRITE(0,'(A,I6,1PE30.14)') ' CG2DLOC iters, err = ', 
     &     actualIts, actualResidual
      _END_MASTER( )

      err    = 0.
      DO j=2,sNy
         DO i=2,sNx
            rr     = cg2d_b(i,j,bi,bj) - (
     &            aW2d(i  ,j  ,bi,bj)*cg2d_x(i-1,j  ,bi,bj)
     &           +aW2d(i+1,j  ,bi,bj)*cg2d_x(i+1,j  ,bi,bj)
     &           +aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j-1,bi,bj)
     &           +aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j+1,bi,bj)
     &           -aW2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aW2d(i+1,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -freeSurfFac*_rA(i,j,bi,bj)*
     &           cg2d_x(i  ,j  ,bi,bj)/deltaTmom/deltaTmom*cg2dNorm
     &           )
            err    = err    + rr*rr
         ENDDO
      ENDDO

      _BEGIN_MASTER( myThid )
      WRITE(0,'(A,x,1PE30.14)') ' SOLVE LOCAL err = ', sqrt(err)
      _END_MASTER( )

#endif

      END
