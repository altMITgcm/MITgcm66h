C $Header$
C $Name$

#include "CPP_OPTIONS.h"

      SUBROUTINE MOM_U_ADV_WU(
     I        bi,bj,k,
     I        uFld,wFld,
     O        advectiveFluxWU,
     I        myThid)
      IMPLICIT NONE
C
C     Calculate advective flux in R direction for U eqn
C

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"

C     == Routine arguments ==
      INTEGER bi,bj,k
      _RL uFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL wFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL advectiveFluxWU(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C     == Local variables ==
      INTEGER I,J

      IF (K.GT.Nr) THEN
C     Advective flux = 0  at K=Nr+1

      DO j=1-Oly,sNy+Oly
       DO i=1-Olx,sNx+Olx
        advectiveFluxWU(i,j) = 0.
       ENDDO
      ENDDO

      ELSEIF (K.EQ.1) THEN
C     Free-surface correction at K=1

      DO j=1-Oly,sNy+Oly
       DO i=1-Olx+1,sNx+Olx
        advectiveFluxWU(i,j) =
     &     0.5*(
     &        wFld( i ,j,k,bi,bj)*rA( i ,j,bi,bj)
     &       +wFld(i-1,j,k,bi,bj)*rA(i-1,j,bi,bj)
     &         )*uFld(i,j,k,bi,bj)*freeSurfFac
       ENDDO
      ENDDO

      ELSE

C     - Laplacian  and bi-harmonic terms
      DO j=1-Oly,sNy+Oly
       DO i=1-Olx+1,sNx+Olx
        advectiveFluxWU(i,j) =
     &    0.25*(
     &        wFld( i ,j,k,bi,bj)*rA( i ,j,bi,bj)
     &       +wFld(i-1,j,k,bi,bj)*rA(i-1,j,bi,bj)
     &         )*( uFld(i,j,k,bi,bj)+uFld(i,j,k-1,bi,bj) )
#ifdef OLD_ADV_BCS
     &  *_maskW(i,j,k,bi,bj) 
     &  *_maskW(i,j,k-1,bi,bj)
#endif /* OLD_ADV_BCS */
       ENDDO
      ENDDO

      ENDIF

      RETURN
      END
