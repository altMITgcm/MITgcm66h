C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_Hyd(
     I                     myiter,
     I                     mytime,
     I                     mythid
     &                   )

c     ==================================================================
c     SUBROUTINE cost_Hyd
c     ==================================================================
c
c     o Evaluate cost function contributions of temperature, salt, and
c       sea surface temperature contributions.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 25-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     SUBROUTINE cost_Hyd
c     ==================================================================

      implicit none

c     == global variables ==

c     == routine arguments ==

      integer myiter
      _RL     mytime
      integer mythid

c     == local variables ==


c     == end of interface ==


#ifdef ALLOW_XBT_COST_CONTRIBUTION
      call cost_xbt   ( myiter, mytime, mythid )
#endif 

#ifdef ALLOW_ARGO_THETA_COST_CONTRIBUTION
      call cost_argo_theta ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_CTDT_COST_CONTRIBUTION
      call cost_ctdt  ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_SSS_COST_CONTRIBUTION
      call cost_sss   ( myiter, mytime, mythid )
#endif


#ifdef ALLOW_CTDS_COST_CONTRIBUTION
      call cost_ctds  ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_ARGO_SALT_COST_CONTRIBUTION
      call cost_argo_salt ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_THETA0_COST_CONTRIBUTION
      call cost_theta0 ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_SALT0_COST_CONTRIBUTION
      call cost_salt0  ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_THETA_COST_CONTRIBUTION
      call cost_theta ( myiter, mytime, mythid )
#endif

#ifdef ALLOW_SALT_COST_CONTRIBUTION
      call cost_salt  ( myiter, mytime, mythid )
#endif

      end
