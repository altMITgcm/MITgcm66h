C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE CPL_RECV_ATM_TAUY   
C     /==========================================================\
C     | SUBROUTINE CPL_RECV_ATM_TAUY                             |
C     | o Routine for receiving meridional momentum flux at      |
C     |   atmos. lower boundary.                                 |
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

C     Receive atmos. lower boundary meridional momentum flux.
      CALL COUPRECV_R8TILES( atmCompName, atmTauYName, Nx_atm, Ny_atm, 
     &                       TauY_atm )

      RETURN
      END
