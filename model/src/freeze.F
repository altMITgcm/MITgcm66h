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
C     Tboiling  :: Upper temperature bound.
      INTEGER i,j
      _RL Tfreezing, Tboiling
CEOP

      Tfreezing=-1.9
      Tboiling =35.0

C     Check for water that should have frozen
       DO j=jMin,jMax
        DO i=iMin,iMax
         IF (gT(i,j,k,bi,bj) .LT. Tfreezing) THEN
          gT(i,j,k,bi,bj)=Tfreezing
         ENDIF
#ifdef COUPLED_UCLA
cdm this is a temporary hack and needs to go ASAP!
         IF (gT(i,j,k,bi,bj) .GT. Tboiling ) THEN
          gT(i,j,k,bi,bj)=Tboiling
         ENDIF
#endif
        ENDDO
       ENDDO

      RETURN
      END
