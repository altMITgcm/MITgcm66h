C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_getaqh(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_getaqh
c     ==================================================================
c
c     o Get atmos. humid, contribution of the control vector and add it
c       to atmos. humid.
c
c     started: heimbach@mit.edu, 16-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getaqh
c     ==================================================================

      implicit none

#ifdef ALLOW_AQH_CONTROL

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"

#include "ctrl.h"
#include "ctrl_dummy.h"
#include "exf_fields.h"
#include "optim.h"

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer ilaqh

      _RL     aqhfac
      logical aqhfirst
      logical aqhchanged
      integer aqhcount0
      integer aqhcount1

      logical doglobalread
      logical ladinit

      character*(80) fnameaqh

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1-oly
      jmax = sny+oly
      imin = 1-olx
      imax = snx+olx

c--   Now, read the control vector.
      doglobalread = .false.
      ladinit      = .false.

      if (optimcycle .ge. 0) then
        ilaqh=ilnblnk( xx_aqh_file )
        write(fnameaqh(1:80),'(2a,i10.10)') xx_aqh_file(1:ilaqh),'.',
     &                                      optimcycle
      else
        print*
        print*,' ctrl_getaqh: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getaqh.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_aqh',
     O                  aqhfac, aqhfirst, aqhchanged,
     O                  aqhcount0,aqhcount1,
     I                  mytime, myiter, mythid )

        call active_read_xy( fnameaqh, tmpfld2d, aqhcount0,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_aqh_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_aqh0(i,j,bi,bj)  = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xy( fnameaqh, tmpfld2d, aqhcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_aqh_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_aqh1 (i,j,bi,bj) = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

c--   Add control to model variable.
        do bj = jtlo,jthi
          do bi = itlo,ithi
c--       Calculate mask for tracer cells (0 => land, 1 => water).
          k = 1
          do j = 1,sny
            do i = 1,snx
              aqh(i,j,bi,bj) = aqh (i,j,bi,bj)
     &              + aqhfac            *xx_aqh0(i,j,bi,bj)
     &              + (1. _d 0 - aqhfac)*xx_aqh1(i,j,bi,bj)
              aqh(i,j,bi,bj) = aqh(i,j,bi,bj)*maskc(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_AQH_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_AQH_CONTROL undefined.

#endif /* ALLOW_AQH_CONTROL */

      end


