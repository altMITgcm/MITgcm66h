C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_GetSaltFlux(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_GetSaltFlux
c     ==================================================================
c
c     o Get the salt flux contribution of the control vector and add it
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
c     SUBROUTINE ctrl_GetSaltFlux
c     ==================================================================

      implicit none

#ifdef ALLOW_SFLUX_CONTROL

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
      integer ilsfl

      _RL     sflfac
      logical sflfirst
      logical sflchanged
      integer sflcount0
      integer sflcount1

      logical doglobalread
      logical ladinit

      character*(80) fnamesfl

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
        ilsfl=ilnblnk( xx_sflux_file )
        write(fnamesfl(1:80),'(2a,i10.10)') xx_sflux_file(1:ilsfl),'.',
     &                                      optimcycle
      else
        print*
        print*,' ctrl_GetSaltFlux: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_GetSaltFlux.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_sflux',
     O                  sflfac, sflfirst, sflchanged,
     O                  sflcount0,sflcount1,
     I                  mytime, myiter, mythid )

      if ( sflfirst ) then
       call active_read_xy( fnamesfl, xx_sflux1, sflcount0,
     &                      doglobalread, ladinit, optimcycle,
     &                      mythid, xx_sflux_dummy )
      endif


       if (( sflfirst ) .or. ( sflchanged )) then
        call exf_SwapFFields( xx_sflux0, xx_sflux1, mythid )

        call active_read_xy( fnamesfl,xx_sflux1 , sflcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_sflux_dummy )
      endif

c--   Add control to model variable.
        do bj = jtlo,jthi
          do bi = itlo,ithi
c--       Calculate mask for tracer cells (0 => land, 1 => water).
          k = 1
          do j = 1,sny
            do i = 1,snx
              sflux(i,j,bi,bj) = sflux (i,j,bi,bj)
     &                         + sflfac            *xx_sflux0(i,j,bi,bj)
     &                         + (1. _d 0 - sflfac)*xx_sflux1(i,j,bi,bj)
              sflux(i,j,bi,bj) = sflux(i,j,bi,bj)*maskc(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_SFLUX_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_SFLUX_CONTROL undefined.

#endif /* ALLOW_SFLUX_CONTROL */

      end


