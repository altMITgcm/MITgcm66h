C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE CPL_RECV_ATM_QSHORTWAVE
C     /==========================================================\
C     | SUBROUTINE CPL_RECV_ATM_QSHORTWAVE                       |
C     | o Routine for receiving lower boundary shortwave heat    |
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
      CALL COUPRECV_R8TILES( atmCompName, atmQshortwaveName, 
     &                       Nx_atm, Ny_atm, 
     &                       qShortwave_atm   )

      RETURN
      END
