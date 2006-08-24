C $Header$
C $Name$

#include "SEAICE_OPTIONS.h"

CBOP
C     !ROUTINE: SEAICE_EXCH

C     !INTERFACE:
      SUBROUTINE SEAICE_EXCH ( fld, myThid )

C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE SEAICE_EXCH
C     | o RL exchange routine with k=3
C     *==========================================================*
C     *==========================================================*

C     !USES:
      IMPLICIT NONE

C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine.
      _RL fld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)
      INTEGER myThid

C     !LOCAL VARIABLES:
CEOP

C--   Update overlap regions
      CALL EXCH_3D_RL( fld, 3, myThid )

      RETURN
      END
