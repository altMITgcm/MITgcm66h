C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_getuwind(
     I                              mytime,
     I                              myiter,
     I                              mythid
     &                            )

c     ==================================================================
c     SUBROUTINE ctrl_getuwind
c     ==================================================================
c
c     o Get zonal wind speed contribution of the control vector
c       and add it to zonal wind speed.
c
c     started: heimbach@mit.edu, 16-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getuwind
c     ==================================================================

      implicit none

#ifdef ALLOW_UWIND_CONTROL

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
      integer iluwind

      _RL     uwindfac
      logical uwindfirst
      logical uwindchanged
      integer uwindcount0
      integer uwindcount1

      logical doglobalread
      logical ladinit

      character*(80) fnameuwind

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
        iluwind=ilnblnk( xx_uwind_file )
        write(fnameuwind(1:80),'(2a,i10.10)') 
     &       xx_uwind_file(1:iluwind), '.', optimcycle
      else
        print*
        print*,' ctrl_getuwind: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getuwind.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_uwind',
     O                  uwindfac, uwindfirst, uwindchanged,
     O                  uwindcount0,uwindcount1,
     I                  mytime, myiter, mythid )

        call active_read_xy( fnameuwind, tmpfld2d, uwindcount0,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_uwind_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_uwind0(i,j,bi,bj)  = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xy( fnameuwind, tmpfld2d, uwindcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_uwind_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_uwind1 (i,j,bi,bj) = tmpfld2d (i,j,bi,bj)
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
              uwind(i,j,bi,bj) = uwind(i,j,bi,bj) +
     &              uwindfac            *xx_uwind0(i,j,bi,bj)+
     &              (1. _d 0 - uwindfac)*xx_uwind1(i,j,bi,bj)
              uwind(i,j,bi,bj) = uwind(i,j,bi,bj)*maskw(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_UWIND_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_UWIND_CONTROL undefined.

#endif /* ALLOW_UWIND_CONTROL */

      end


