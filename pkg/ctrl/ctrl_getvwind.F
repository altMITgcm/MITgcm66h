C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_getvwind(
     I                              mytime,
     I                              myiter,
     I                              mythid
     &                            )

c     ==================================================================
c     SUBROUTINE ctrl_getvwind
c     ==================================================================
c
c     o Get meridional wind speed contribution of the control vector
c       and add it to meridional wind speed.
c
c     started: heimbach@mit.edu, 16-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getvwind
c     ==================================================================

      implicit none

#ifdef ALLOW_VWIND_CONTROL

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
      integer ilvwind

      _RL     vwindfac
      logical vwindfirst
      logical vwindchanged
      integer vwindcount0
      integer vwindcount1

      logical doglobalread
      logical ladinit

      character*(80) fnamevwind

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
        ilvwind=ilnblnk( xx_vwind_file )
        write(fnamevwind(1:80),'(2a,i10.10)') 
     &       xx_vwind_file(1:ilvwind), '.', optimcycle
      else
        print*
        print*,' ctrl_getvwind: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getvwind.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_vwind',
     O                  vwindfac, vwindfirst, vwindchanged,
     O                  vwindcount0,vwindcount1,
     I                  mytime, myiter, mythid )

        call active_read_xy( fnamevwind, tmpfld2d, vwindcount0,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_vwind_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_vwind0(i,j,bi,bj)  = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xy( fnamevwind, tmpfld2d, vwindcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_vwind_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_vwind1 (i,j,bi,bj) = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

c--   Add control to model variable.
        do bj = jtlo,jthi
          do bi = itlo,ithi
          k = 1
          do j = 1,sny
            do i = 1,snx
              vwind(i,j,bi,bj) = vwind(i,j,bi,bj) +
     &              vwindfac            *xx_vwind0(i,j,bi,bj)+
     &              (1. _d 0 - vwindfac)*xx_vwind1(i,j,bi,bj)
              vwind(i,j,bi,bj) = vwind(i,j,bi,bj)*masks(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_VWIND_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_VWIND_CONTROL undefined.

#endif /* ALLOW_VWIND_CONTROL */

      end


