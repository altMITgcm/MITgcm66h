
#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_init_variables( mythid )

c     ==================================================================
c     SUBROUTINE ctrl_init_variables
c     ==================================================================
c
c     o Set parts of the vector of control variables and initialize the
c       rest to zero.
c
c     started: heimbach@mit.edu 25-Mar-2002
c
c     ==================================================================
c     SUBROUTINE ctrl_init_variables
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"
#include "cal.h"
#include "ctrl.h"
#ifdef ALLOW_OBCS_CONTROL
# include "OBCS.h"
#endif

#ifdef ALLOW_ECCO_OPTIMIZATION
#include "optim.h"
#endif

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer ntmp
      integer ivarindex

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1-oly
      jmax = sny+oly
      imin = 1-olx
      imax = snx+olx

#ifdef ALLOW_HFLUX_CONTROL
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              xx_hflux0(i,j,bi,bj) = 0. _d 0
              xx_hflux1(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
#endif

#ifdef ALLOW_SFLUX_CONTROL
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              xx_sflux0(i,j,bi,bj) = 0. _d 0
              xx_sflux1(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
#endif

#ifdef ALLOW_USTRESS_CONTROL
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              xx_tauu0(i,j,bi,bj) = 0. _d 0
              xx_tauu1(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
#endif

#ifdef ALLOW_VSTRESS_CONTROL
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              xx_tauv0(i,j,bi,bj) = 0. _d 0
              xx_tauv1(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
#endif

      return
      end

