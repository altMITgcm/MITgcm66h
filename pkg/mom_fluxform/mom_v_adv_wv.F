C $Header$
C $Name$

#include "CPP_OPTIONS.h"

      SUBROUTINE MOM_V_ADV_WV(
     I        bi,bj,k,
     I        vFld,wFld,
     O        advectiveFluxWV,
     I        myThid)
      IMPLICIT NONE
C
C     Calculate advective flux in R direction for V eqn
C

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"

C     == Routine arguments ==
      INTEGER bi,bj,k
      _RL vFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL wFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL advectiveFluxWV(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C     == Local variables ==
      INTEGER I,J

      IF (K.GT.Nr) THEN
C     Advective flux = 0  at K=Nr+1

      DO j=1-Oly,sNy+Oly
       DO i=1-Olx,sNx+Olx
        advectiveFluxWV(i,j) = 0.
       ENDDO
      ENDDO

      ELSEIF (K.EQ.1) THEN
C     Free-surface correction at K=1

      DO j=1-Oly+1,sNy+Oly
       DO i=1-Olx,sNx+Olx
        advectiveFluxWV(i,j) =
     &     0.5*(
     &        wFld(i, j ,k,bi,bj)*rA(i, j ,bi,bj)
     &       +wFld(i,j-1,k,bi,bj)*rA(i,j-1,bi,bj)
     &         )*vFld(i,j,k,bi,bj)*freeSurfFac
       ENDDO
      ENDDO

      ELSE

C     - Laplacian  and bi-harmonic terms
      DO j=1-Oly+1,sNy+Oly
       DO i=1-Olx,sNx+Olx
        advectiveFluxWV(i,j) =
     &    0.25*(
     &        wFld(i, j ,k,bi,bj)*rA(i, j ,bi,bj)
     &       +wFld(i,j-1,k,bi,bj)*rA(i,j-1,bi,bj)
     &         )*( vFld(i,j,k,bi,bj)+vFld(i,j,k-1,bi,bj) )
#ifdef OLD_ADV_BCS
     &  *_maskS(i,j,k,bi,bj) 
     &  *_maskS(i,j,k-1,bi,bj)
#endif /* OLD_ADV_BCS */
       ENDDO
      ENDDO

      ENDIF

      RETURN
      END
