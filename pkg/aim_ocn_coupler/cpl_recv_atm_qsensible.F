C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE CPL_RECV_ATM_QSENSIBLE
C     /==========================================================\
C     | SUBROUTINE CPL_RECV_ATM_QSENSIBLE                        |
C     | o Routine for receiving lower boundary sensible heat     |
C     |   flux from atmos component.                             |
C     |==========================================================|
C     | This version talks to the MITgcm general circulation     |
C     | model.                                                   |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "ATMSIZE.h"
#include "ATMVARS.h"
#include "ATMIDS.h"

C     == Routine arguments ==

C     == Local variables ==

CEndOfInterface

C     Receive lower boundary momentum flux from atmos. component
      CALL COUPRECV_R8TILES( atmCompName, atmqSensibleName, 
     &                       Nx_atm, Ny_atm, 
     &                       qSensible_atm   )

      RETURN
      END
