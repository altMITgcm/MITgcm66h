C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_getatemp(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_getatemp
c     ==================================================================
c
c     o Get atmos. temp. contribution of the control vector and add it
c       to atmos. temp. field
c
c     started: heimbach@mit.edu, 16-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getatemp
c     ==================================================================

      implicit none

#ifdef ALLOW_ATEMP_CONTROL

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
      integer ilatemp

      _RL     atempfac
      logical atempfirst
      logical atempchanged
      integer atempcount0
      integer atempcount1

      logical doglobalread
      logical ladinit

      character*(80) fnameatemp

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
        ilatemp=ilnblnk( xx_atemp_file )
        write(fnameatemp(1:80),'(2a,i10.10)') 
     &       xx_atemp_file(1:ilatemp), '.', optimcycle
      else
        print*
        print*,' ctrl_getatemp: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getatemp.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_atemp',
     O                   atempfac, atempfirst, atempchanged,
     O                   atempcount0,atempcount1,
     I                   mytime, myiter, mythid )

        call active_read_xy( fnameatemp, tmpfld2d, atempcount0,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_atemp_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_atemp0(i,j,bi,bj)  = tmpfld2d (i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo

        call active_read_xy( fnameatemp, tmpfld2d, atempcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_atemp_dummy )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                xx_atemp1 (i,j,bi,bj) = tmpfld2d (i,j,bi,bj)
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
              atemp(i,j,bi,bj) = atemp (i,j,bi,bj)
     &              + atempfac            *xx_atemp0(i,j,bi,bj)
     &              + (1. _d 0 - atempfac)*xx_atemp1(i,j,bi,bj)
              atemp(i,j,bi,bj) = atemp(i,j,bi,bj)*maskc(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_ATEMP_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_ATEMP_CONTROL undefined.

#endif /* ALLOW_ATEMP_CONTROL */

      end

