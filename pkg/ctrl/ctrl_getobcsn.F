
#include "CTRL_CPPOPTIONS.h"
#ifdef ALLOW_OBCS
# include "OBCS_OPTIONS.h"
#endif


      subroutine ctrl_getobcsn(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_getobcsn
c     ==================================================================
c
c     o Get norhtern obc of the control vector and add it
c       to dyn. fields
c
c     started: heimbach@mit.edu, 29-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getobcsn
c     ==================================================================

      implicit none

#ifdef ALLOW_OBCSN_CONTROL

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
      integer ilobcsn
      integer iobcs

      _RL     dummy
      _RL     obcsnfac
      logical obcsnfirst
      logical obcsnchanged
      integer obcsncount0
      integer obcsncount1

      _RL maskxz   (1-olx:snx+olx,nr,nsx,nsy)

      logical doglobalread
      logical ladinit

      character*(80) fnameobcsn

      

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
        ilobcsn=ilnblnk( xx_obcsn_file )
        write(fnameobcsn(1:80),'(2a,i10.10)') 
     &       xx_obcsn_file(1:ilobcsn), '.', optimcycle
      else
        print*
        print*,' ctrl_getobcsn: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getobcsn.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_obcsn',
     O                   obcsnfac, obcsnfirst, obcsnchanged,
     O                   obcsncount0,obcsncount1,
     I                   mytime, myiter, mythid )

      do iobcs = 1,nobcs

        call active_read_xz( 'maskobcsn', maskxz, 
     &                       iobcs,
     &                       doglobalread, ladinit, 0,
     &                       mythid, dummy )

        call active_read_xz( fnameobcsn, tmpfldxz, 
     &                       (obcsncount0-1)*nobcs+iobcs,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_obcsn_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do i = imin,imax
                xz_obcs0(i,k,bi,bj)  = tmpfldxz (i,k,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xz( fnameobcsn, tmpfldxz, 
     &                       (obcsncount1-1)*nobcs+iobcs,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_obcsn_dummy )

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
                       OBNt(i,k,bi,bj) = OBNt (i,k,bi,bj)
     &                      + obcsnfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcsnfac)*xz_obcs1(i,k,bi,bj)
                       OBNt(i,k,bi,bj) = OBNt(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 2) then
                       OBNs(i,k,bi,bj) = OBNs (i,k,bi,bj)
     &                      + obcsnfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcsnfac)*xz_obcs1(i,k,bi,bj)
                       OBNs(i,k,bi,bj) = OBNs(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 3) then
                       OBNu(i,k,bi,bj) = OBNu (i,k,bi,bj)
     &                      + obcsnfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcsnfac)*xz_obcs1(i,k,bi,bj)
                       OBNu(i,k,bi,bj) = OBNu(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 4) then
                       OBNv(i,k,bi,bj) = OBNv (i,k,bi,bj)
     &                      + obcsnfac            *xz_obcs0(i,k,bi,bj)
     &                      + (1. _d 0 - obcsnfac)*xz_obcs1(i,k,bi,bj)
                       OBNv(i,k,bi,bj) = OBNv(i,k,bi,bj)
     &                      *maskxz(i,k,bi,bj)
                    endif
                 enddo
              enddo
           enddo
        enddo

C--   End over iobcs loop
      enddo

#else /* ALLOW_OBCSN_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_OBCSN_CONTROL undefined.

#endif /* ALLOW_OBCSN_CONTROL */

      end

