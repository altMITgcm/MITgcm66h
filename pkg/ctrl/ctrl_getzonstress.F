C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_GetZonStress(
     I                              mytime,
     I                              myiter,
     I                              mythid
     &                            )

c     ==================================================================
c     SUBROUTINE ctrl_GetuStress
c     ==================================================================
c
c     o Get the zonal wind stress contribution of the control vector and
c       add it to the surface heat flux.
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
c     SUBROUTINE ctrl_GetuStress
c     ==================================================================

      implicit none

#ifdef ALLOW_USTRESS_CONTROL

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
      integer ilust

      _RL     ustfac
      logical ustfirst
      logical ustchanged
      integer ustcount0
      integer ustcount1

      logical doglobalread
      logical ladinit

      character*(80) fnameust

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
        ilust=ilnblnk( xx_tauu_file )
        write(fnameust(1:80),'(2a,i10.10)') xx_tauu_file(1:ilust),'.',
     &                                      optimcycle
      else
        print*
        print*,' ctrl_GetZonStress: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_GetZonStress.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_tauu',
     O                  ustfac, ustfirst, ustchanged,
     O                  ustcount0,ustcount1,
     I                  mytime, myiter, mythid )

      if ( ustfirst ) then
       call active_read_xy( fnameust, xx_tauu1, ustcount0,
     &                      doglobalread, ladinit, optimcycle,
     &                      mythid, xx_tauu_dummy )
      endif

       if (( ustfirst ) .or. ( ustchanged )) then
        call exf_SwapFFields( xx_tauu0, xx_tauu1, mythid )

        call active_read_xy( fnameust,xx_tauu1 , ustcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_tauu_dummy )
      endif

c--   Add control to model variable.
        do bj = jtlo,jthi
          do bi = itlo,ithi
          k = 1
          do j = 1,sny
            do i = 1,snx
              ustress(i,j,bi,bj) = ustress(i,j,bi,bj) +
     &                        ustfac            *xx_tauu0(i,j,bi,bj)+
     &                        (1. _d 0 - ustfac)*xx_tauu1(i,j,bi,bj)
              ustress(i,j,bi,bj) = ustress(i,j,bi,bj)*maskw(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_USTRESS_CONTROL undefined */


c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_USTRESS_CONTROL undefined.

#endif /* ALLOW_USTRESS_CONTROL */

      end


