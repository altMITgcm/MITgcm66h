C $Header$

#include "COST_CPPOPTIONS.h"

      subroutine cost_ice           (
     I                                mytime,
     I                                myiter,
     I                                mythid
     &                              )

c     ==================================================================
c     SUBROUTINE cost_ice
c     ==================================================================
c
c     o Compute mean sea-ice volume between costIceStart and costIceEnd
c
c     started: menemenlis@jpl.nasa.gov 26-Feb-2003
c
c     ==================================================================
c     SUBROUTINE cost_ice
c     ==================================================================

      implicit none

c     == global variables ==
#ifdef ALLOW_COST_ICE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "PARAMS.h"
#include "cost.h"
#include "SEAICE.h"
#endif /* ALLOW_COST_ICE */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

#ifdef ALLOW_COST_ICE

c     == local variables ==

      integer bi,bj,i,j
      _RL tempVar

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      if ( mytime .ge. costIceStart .and. mytime .le. costIceEnd ) then
         tempVar = 1. / ( 1. + int( ( min ( endtime, costIceEnd ) -
     &        max ( starttime, costIceStart ) ) / deltaTClock ) )
         do bj=myByLo(myThid),myByHi(myThid)
            do bi=myBxLo(myThid),myBxHi(myThid)
               do j = 1,sny
                  do i =  1,snx
                     objf_ice(bi,bj) = objf_ice(bi,bj) +
     &                    HEFF(i,j,1,bi,bj) * rA(i,j,bi,bj) * tempVar
                  enddo
               enddo
            enddo
         enddo
      endif

#endif /* ALLOW_COST_ICE */

      end
