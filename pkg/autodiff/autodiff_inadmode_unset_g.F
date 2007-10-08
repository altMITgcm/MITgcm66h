C $Header$
C $Name$

#include "AUTODIFF_OPTIONS.h"

      subroutine g_autodiff_inadmode_unset( myThid )
      IMPLICIT NONE
C     /==========================================================\
C     | SUBROUTINE autodiff_inadmode_unset                       |
C     |==========================================================|
C     == Global variables ===

#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine.
      integer myThid

cph      inAdMode = inAdFALSE
      inAdMode = .false.

      end









