C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE CPL_SEND_OCN_VVELGROUND
C     /==========================================================\
C     | SUBROUTINE CPL_SEND_OCN_VVELGROUND                       |
C     | o Routine for sending merid wind speed to ocean component|
C     |   component.                                             |
C     |==========================================================|
C     | This version talks to the MITgcm general circulation     |
C     | model.                                                   |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "ATMSIZE.h"
#include "ATMVARS.h"
#include "ATMIDS.h"
#include "OCNSIZE.h"
#include "OCNVARS.h"
#include "OCNIDS.h"

C     == Routine arguments ==

C     == Local variables ==

CEndOfInterface

C     Map atmos. meridional momentum flux onto ocean grid
      CALL ATM_TO_OCN_MAPXYR8(
     I     Nx_atm, Ny_atm, 
     I     vVelGround_atm,
     I     Nx_ocn, Ny_ocn,
     O     vVelGround_ocn)

C     Send atmos. config to ocean component
      CALL COUPSEND_R8TILES( ocnCompName, ocnvVelGroundName, 
     I                       Nx_ocn, Ny_ocn, 
     I                       vVelGround_ocn )

      RETURN
      END
