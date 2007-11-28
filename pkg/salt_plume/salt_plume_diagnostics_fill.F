C $Header$
C $Name$

#include "SALT_PLUME_OPTIONS.h"

CBOP 0
C     !ROUTINE: SALT_PLUME_DIAGNOSTICS_FILL
C     !INTERFACE:
      SUBROUTINE SALT_PLUME_DIAGNOSTICS_FILL(
     I             bi, bj, myThid )

C     !DESCRIPTION:
C     Provide the information for the diagnostics

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "SALT_PLUME.h"

C     !INPUT PARAMETERS:
      INTEGER bi,bj
      INTEGER myThid
CEOP

#ifdef ALLOW_SALT_PLUME

C     !LOCAL VARIABLES:
      _RL tmpFac

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN

C-    Salt plume depth (>0), [m]
       tmpFac = 1. _d 0
       CALL DIAGNOSTICS_SCALE_FILL( SaltPlumeDepth,tmpFac,1,
     &                             'oceSPDep',0, 1,0,1,1,myThid )

C-    net Salt plume flux into the ocean during freezing (+=down), [psu.kg/m2/s ~ g/m2/s]
       tmpFac = 1. _d 0
       CALL DIAGNOSTICS_SCALE_FILL( saltPlumeFlux,tmpFac,1,
     &                             'oceSPflx',0, 1,0,1,1,myThid )

      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

#endif /* ALLOW_SALT_PLUME */

      RETURN
      END
