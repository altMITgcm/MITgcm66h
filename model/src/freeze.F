C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: FREEZE
C     !INTERFACE:
      SUBROUTINE FREEZE( bi, bj, iMin, iMax, jMin, jMax,
     I                     K,
     I                     myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R FREEZE                                                
C     | o Check water temperature and limit range of temperature  
C     | appropriately.                                            
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine Arguments ==
      INTEGER bi,bj,iMin,iMax,jMin,jMax
      INTEGER K
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     Tfreezing :: Freezing threshold temperature.
      INTEGER i,j
      _RL Tfreezing

#ifdef COUPLED_UCLA
C     Sea-ice and land mask (0 = land; 1 = sea ice; 2 = ocean)
      COMMON /ICEMASK/ icemask
      _RL     icemask(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
#endif
CEOP

      Tfreezing=-1.9

C     Check for water that should have frozen
       DO j=jMin,jMax
        DO i=iMin,iMax
         IF (gT(i,j,k,bi,bj).LT.Tfreezing) gT(i,j,k,bi,bj)=Tfreezing
        ENDDO
       ENDDO

#ifdef COUPLED_UCLA
       IF (K.EQ.1) THEN
        DO j=jMin,jMax
         DO i=iMin,iMax
          IF (icemask(i,j,bi,bj) .EQ. 1.0) THEN
           gT(i,j,1,bi,bj)=Tfreezing
          ENDIF
         ENDDO
        ENDDO
      ENDIF
#endif

      RETURN
      END
