C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE CPL_RECV_OCN_SST       
C     /==========================================================\
C     | SUBROUTINE CPL_RECV_OCN_SST                              |
C     | o Routine for receiving surface temperature from ocean   |
C     |   component.                                             |
C     |==========================================================|
C     | This version talks to the MITgcm general circulation     |
C     | model.                                                   |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "OCNSIZE.h"
#include "OCNVARS.h"
#include "OCNIDS.h"

C     == Routine arguments ==

C     == Local variables ==

CEndOfInterface

C     Receive sea surface temperature   
      CALL COUPRECV_R8TILES( ocnCompName, ocnSSTName, Nx_ocn, Ny_ocn, 
     &                       SST_ocn )

      RETURN
      END
