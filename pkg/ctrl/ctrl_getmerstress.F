C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_GetMerStress(
     I                              mytime,
     I                              myiter,
     I                              mythid
     &                            )

c     ==================================================================
c     SUBROUTINE ctrl_GetMerStress
c     ==================================================================
c
c     o Get the meridional wind stress contribution of the control vector
c       and add it to the surface heat flux.
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
c     SUBROUTINE ctrl_GetMerStress
c     ==================================================================

      implicit none

#ifdef ALLOW_VSTRESS_CONTROL

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
      integer ilvst

      _RL     vstfac
      logical vstfirst
      logical vstchanged
      integer vstcount0
      integer vstcount1

      logical doglobalread
      logical ladinit

      character*(80) fnamevst

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
        ilvst=ilnblnk( xx_tauv_file )
        write(fnamevst(1:80),'(2a,i10.10)') xx_tauv_file(1:ilvst),'.',
     &                                      optimcycle
      else
        print*
        print*,' ctrl_GetMerStress: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_GetMerStress.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_tauv',
     O                  vstfac, vstfirst, vstchanged,
     O                  vstcount0,vstcount1,
     I                  mytime, myiter, mythid )

      if ( vstfirst ) then
       call active_read_xy( fnamevst, xx_tauv1, vstcount0,
     &                      doglobalread, ladinit, optimcycle,
     &                      mythid, xx_tauv_dummy )
      endif

       if (( vstfirst ) .or. ( vstchanged )) then
        call exf_SwapFFields( xx_tauv0, xx_tauv1, mythid )

        call active_read_xy( fnamevst,xx_tauv1 , vstcount1,
     &                       doglobalread, ladinit, optimcycle,
     &                       mythid, xx_tauv_dummy )
      endif

c--   Add control to model variable.
        do bj = jtlo,jthi
          do bi = itlo,ithi
          k = 1
          do j = 1,sny
            do i = 1,snx
              vstress(i,j,bi,bj) = vstress(i,j,bi,bj) +
     &                        vstfac            *xx_tauv0(i,j,bi,bj)+
     &                        (1. _d 0 - vstfac)*xx_tauv1(i,j,bi,bj)
              vstress(i,j,bi,bj) = vstress(i,j,bi,bj)*masks(i,j,k,bi,bj)
            enddo
          enddo
        enddo
      enddo

#else /* ALLOW_VSTRESS_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_VSTRESS_CONTROL undefined.

#endif /* ALLOW_VSTRESS_CONTROL */

      end


