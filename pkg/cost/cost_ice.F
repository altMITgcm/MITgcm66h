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
c     o Compute sea-ice volume.
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

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

c--   Assign the first value to the array holding the average.
      do bj=myByLo(myThid),myByHi(myThid)
         do bi=myBxLo(myThid),myBxHi(myThid)
            do j = 1,sny
               do i =  1,snx
                  objf_ice(bi,bj) = objf_ice(bi,bj) +
     &                 HEFF(i,j,1,bi,bj) * rA(i,j,bi,bj)
               enddo
            enddo
         enddo
      enddo

#endif /* ALLOW_COST_ICE */

      end
