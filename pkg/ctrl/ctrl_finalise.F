C $Header$

#include "CTRL_CPPOPTIONS.h"

      subroutine ctrl_Finalise(
     I                          myiter,
     I                          mytime,
     I                          mythid
     &                        )

c     ==================================================================
c     SUBROUTINE ctrl_Finalise
c     ==================================================================
c
c     o Finalize the control vector related parts of ECCO.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 28-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     SUBROUTINE ctrl_Finalise
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "cal.h"

c     == routine arguments ==

      integer myiter
      _RL     mytime
      integer mythid

c     == local variables ==

c     == end of interface ==

c--   Pack the control vector.

c--     Only the master thread will do I/O.
      
      _BARRIER
        _BEGIN_MASTER( mythid )
      if (myProcId .eq. 0) then
      call ctrl_Pack( modeliterend, modelend, mythid )
      endif
        _END_MASTER( mythid )
        _BARRIER
      return
      end

