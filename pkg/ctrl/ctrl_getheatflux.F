C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_GetHeatFlux(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_GetHeatFlux
c     ==================================================================
c
c     o Get the heat flux contribution of the control vector and add it
c       to the surface heat flux.
c
c     started: Christian Eckert eckert@mit.edu 24-Feb-2000
c
c              - Introduced in order to create a package for the
c                MITgcmUV.
c
c     changed: Ralf.Giering@FastOpt.de 31-Mai-2000
c
c              - set ladinit to .false.
c
c     ==================================================================
c     SUBROUTINE ctrl_GetHeatFlux
c     ==================================================================

      implicit none

#ifdef ALLOW_HFLUX_CONTROL

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
      integer ilhfl

      _RL     hflfac
      logical hflfirst
      logical hflchanged
      integer hflcount0
      integer hflcount1

      logical doglobalread
      logical ladinit

      character*(80) fnamehfl

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
        ilhfl=ilnblnk( xx_hflux_file )
        write(fnamehfl(1:80),'(2a,i10.10)') xx_hflux_file(1:ilhfl),'.',
     &                                      optimcycle
      else
        print*
        print*,' ctrl_GetHeatFlux: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_GetHeatFlux.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_hflux',
     O                   hflfac, hflfirst, hflchanged,
     O                   hflcount0,hflcount1,
     I                   mytime, myiter, mythid )

        call active_read_xy( fnamehfl, tmpfld2d, hflcount0,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_hflux_dummy )

ce      myiter, mytime )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_hflux0(i,j,bi,bj)  = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xy( fnamehfl, tmpfld2d, hflcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_hflux_dummy )

ce      myiter, mytime )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_hflux1 (i,j,bi,bj) = tmpfld2d (i,j,bi,bj)
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
              hflux(i,j,bi,bj) = hflux (i,j,bi,bj)
     &                         + hflfac            *xx_hflux0(i,j,bi,bj)
     &                         + (1. _d 0 - hflfac)*xx_hflux1(i,j,bi,bj)
              hflux(i,j,bi,bj) = hflux(i,j,bi,bj)*maskc(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_HFLUX_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_HFLUX_CONTROL undefined.

#endif /* ALLOW_HFLUX_CONTROL */

      end

