C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE OCN_IMPORT_QSENSIBLE( myThid )
C     /==========================================================\
C     | SUBROUTINE OCN_IMPORT_QSENSIBLE                          |
C     | o Routine for importing sensible hflux    into ocean     |
C     |   component from coupling layer.                         |
C     |==========================================================|
C     | This version talks to the MIT Coupler. It uses the       |
C     | MIT Coupler "checkpoint 1" library calls.                |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "OCNIDS.h"
#include "OCNCPL.h"

C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine
      INTEGER myThid
CEndOfInterface

C     Receive atmos. sensible heat flux
C     Already interpolated ointo ocean model grid by coupling layer.
      CALL COMPRECV_R8TILES( ocnqSensibleName,
     I     sNx, OLx, sNy, OLy, 1, nSx, nSy,
     O     qSensible )

      RETURN
      END
