C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: PACKAGES_INIT_FIXED
C     !INTERFACE:
      SUBROUTINE PACKAGES_INIT_FIXED( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE PACKAGES_INIT_FIXED                            
C     | o Does initialisation of package-related fixed fields     
C     *==========================================================*
C     \ev

C     !CALLING SEQUENCE:
C     PACKAGES_INIT_FIXED
C       |
C       |-- OBCS_INIT_FIXED
C       |
C       |-- FLT_INIT

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     myThid -  Number of this instances
      INTEGER myThid
CEOP

      RETURN
      END
