
#include "CTRL_CPPOPTIONS.h"
#ifdef ALLOW_OBCS
# include "OBCS_OPTIONS.h"
#endif


      subroutine ctrl_getobcss(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_getobcss
c     ==================================================================
c
c     o Get norhtern obc of the control vector and add it
c       to dyn. fields
c
c     started: heimbach@mit.edu, 29-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getobcss
c     ==================================================================

      implicit none

#ifdef ALLOW_OBCSS_CONTROL

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"
#include "OBCS.h"

#include "ctrl.h"
#include "ctrl_dummy.h"
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
      integer ilobcss
      integer iobcs

      _RL     dummy
      _RL     obcssfac
      logical obcssfirst
      logical obcsschanged
      integer obcsscount0
      integer obcsscount1

      _RL maskxz   (1-olx:snx+olx,nr,nsx,nsy)

      logical doglobalread
      logical ladinit

      character*(80) fnameobcss

      

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
        ilobcss=ilnblnk( xx_obcss_file )
        write(fnameobcss(1:80),'(2a,i10.10)') 
     &       xx_obcss_file(1:ilobcss), '.', optimcycle
      else
        print*
        print*,' ctrl_getobcss: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getobcss.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_obcss',
     O                   obcssfac, obcssfirst, obcsschanged,
     O                   obcsscount0,obcsscount1,
     I                   mytime, myiter, mythid )

      do iobcs = 1,nobcs

        call active_read_xz( 'maskobcss', maskxz, 
     &                       iobcs,
     &                       doglobalread, ladinit, 0,
     &                       mythid, dummy )

        call active_read_xz( fnameobcss, tmpfldxz, 
     &                       (obcsscount0-1)*nobcs+iobcs,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_obcss_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do i = imin,imax
                xz_obcs0(i,k,bi,bj)  = tmpfldxz (i,k,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xz( fnameobcss, tmpfldxz, 
     &                       (obcsscount1-1)*nobcs+iobcs,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_obcss_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do i = imin,imax
                xz_obcs1 (i,k,bi,bj) = tmpfldxz (i,k,bi,bj)
              enddo
            enddo
          enddo
        enddo

c--     Add control to model variable.
        do bj = jtlo,jthi
           do bi = itlo,ithi
c--        Calculate mask for tracer cells (0 => land, 1 => water).
              do k = 1,nr
                 do i = 1,snx
                    if (iobcs .EQ. 1) then
                       OBSt(i,k,bi,bj) = OBSt (i,k,bi,bj)
     &                      + obcssfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcssfac)*xz_obcs1(i,k,bi,bj)
                       OBSt(i,k,bi,bj) = OBSt(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 2) then
                       OBSs(i,k,bi,bj) = OBSs (i,k,bi,bj)
     &                      + obcssfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcssfac)*xz_obcs1(i,k,bi,bj)
                       OBSs(i,k,bi,bj) = OBSs(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 3) then
                       OBSu(i,k,bi,bj) = OBSu (i,k,bi,bj)
     &                      + obcssfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcssfac)*xz_obcs1(i,k,bi,bj)
                       OBSu(i,k,bi,bj) = OBSu(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 4) then
                       OBSv(i,k,bi,bj) = OBSv (i,k,bi,bj)
     &                      + obcssfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcssfac)*xz_obcs1(i,k,bi,bj)
                       OBSv(i,k,bi,bj) = OBSv(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    endif
                 enddo
              enddo
           enddo
        enddo

C--   End over iobcs loop
      enddo

#else /* ALLOW_OBCSS_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_OBCSS_CONTROL undefined.

#endif /* ALLOW_OBCSS_CONTROL */

      end

