C $Header$

#include "CPP_OPTIONS.h"


      subroutine ecco_Init(
     I                      mythid
     &                    )

c     ==================================================================
c     SUBROUTINE ecco_Init
c     ==================================================================
c
c     o Initialize the ECCO release of the MITgcmUV.
c
c     started: Christian Eckert eckert@mit.edu 29-Feb-1999
c
c              - Introduced to create a package for the MITgcmUV.
c
c     changed: Christian Eckert eckert@mit.edu
c
c     ==================================================================
c     SUBROUTINE ecco_Init
c     ==================================================================

      implicit none

c     == global variables ==

#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

c     == external ==

c     == end of interface ==

#ifdef INCLUDE_EXTERNAL_FORCING_PACKAGE
      call exf_init( mythid )
#endif /* INCLUDE_EXTERNAL_FORCING_PACKAGE */

#ifdef INCLUDE_ECCO_PACKAGE

#ifdef ALLOW_COST
c--   Initialise the cost function.
      call cost_InitVaria( mythid )

c--   Initialise the time averages.
      call cost_AveragesInit( mythid )

c--   Map the control variables onto the model state. 
      call ctrl_init_variables ( mythid )
      call ctrl_map( mythid )
      _BARRIER
#endif

#ifndef INCLUDE_EXTERNAL_FORCING_PACKAGE
      call ini_forcing( mythid )
#endif

#endif

c--   Everyone else must wait for the parameters to be loaded and
c--   the setup to be completed.
      _BARRIER

      return
      end

