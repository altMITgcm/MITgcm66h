C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_drifter(
     I                       myiter,
     I                       mytime,
     I                       mythid
     &                     )

c     ==================================================================
c     SUBROUTINE cost_drifter
c     ==================================================================
c
c     o Evaluate cost function contribution of temperature.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 25-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     changed: Patrick Heimbach heimbach@mit.edu 27-May-2000
c
c              - set ladinit to .true. to initialise adubar file
c
c     ==================================================================
c     SUBROUTINE cost_drifter
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"

#include "cal.h"
#include "cost.h"
#include "ctrl.h"
#include "ctrl_dummy.h"
#include "optim.h"

c     == routine arguments ==

      integer myiter
      _RL     mytime
      integer mythid

c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer i6min,i6max
      integer iglomin
      integer irec
      integer ilu

      _RL fctile_drift
      _RL fcthread_drift
      _RL www     (1-olx:snx+olx,1-oly:sny+oly)
      _RL wud   (1-olx:snx+olx,1-oly:sny+oly)
      _RL wvd   (1-olx:snx+olx,1-oly:sny+oly)
      _RL uddat (1-olx:snx+olx,1-oly:sny+oly)
      _RL u6bar (1-olx:snx+olx,1-oly:sny+oly)
      _RL vddat (1-olx:snx+olx,1-oly:sny+oly)
      _RL v6bar (1-olx:snx+olx,1-oly:sny+oly)
      _RL mask13c   (1-olx:snx+olx,1-oly:sny+oly)
      _RL mask6c   (1-olx:snx+olx,1-oly:sny+oly)

      character*(80) fnameud
      character*(80) fnamevd

      logical doglobalread
      logical ladinit

      character*(MAX_LEN_MBUF) msgbuf

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1
      jmax = sny
      imin = 1
      imax = snx

c--   Read tiled data.
      doglobalread = .false.
      ladinit      = .false.

#ifdef ALLOW_DRIFTER_COST_CONTRIBUTION

#ifdef ECCO_VERBOSE
      _BEGIN_MASTER( mythid )
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,i8.8)')
     &    ' cost_drift: number of records to process = ',1
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
      _END_MASTER( mythid )
#endif

      if (optimcycle .ge. 0) then
        ilu = ilnblnk( ubarfile )
        write(fnameud(1:80),'(2a,i10.10)')
     &    ubarfile(1:ilu),'.',optimcycle
        ilu = ilnblnk( vbarfile )
        write(fnamevd(1:80),'(2a,i10.10)')
     &    vbarfile(1:ilu),'.',optimcycle
      else
        print*
        print*,' cost_drift: optimcycle has a wrong value.'
        print*,'             optimcycle = ',optimcycle
        print*
        stop   '  ... stopped in cost_drift.'
      endif

      fcthread_drift = 0. _d 0

       irec = 1

c--     Read time averages and the monthly mean data.
        call active_read_xyz( fnameud, ubar, irec,
     &                        doglobalread, ladinit,
     &                        optimcycle, mythid,
     &                        xx_ubar_mean_dummy )

        call active_read_xyz( fnamevd, vbar, irec,
     &                        doglobalread, ladinit,
     &                        optimcycle, mythid,
     &                        xx_vbar_mean_dummy )

c--     Read drifter data
        call mdsreadfield( udriftfile, 32, 'RL', 1, udriftdat, 1,
     &                     mythid)
        call mdsreadfield( vdriftfile, 32, 'RL', 1, vdriftdat, 1,
     &                     mythid)
c--     Read error data
        call mdsreadfield( udrifterrfile, 32, 'RL', 1, wudrift, 1,
     &                     mythid)
        call mdsreadfield( vdrifterrfile, 32, 'RL', 1, wvdrift, 1,
     &                     mythid)


        do bj = jtlo,jthi
          do bi = itlo,ithi

            fctile_drift = 0. _d 0
            k = 2

c--           Calculate mask for tracer cells  (0 => land, 1 => water)
              do j = jmin,jmax
                do i = imin,imax
                  mask13c(i,j) = 1. _d 0
                  if (_hFacC(i,j,k,bi,bj) .eq. 0.)
     &               mask13c(i,j) = 0. _d 0

cph(
cph               print *, 'WARNING: SPECIFIC SETUP FOR ECCO'
cph               below statement could be replaced by following
cph               to make it independnet of Nr:
cph
cph               if ( rC(K) .GT. -1000. ) then
cph)
c                 set mask13c=0 in areas shallower than 1000m 
                  if (_hFacC(i,j,13,bi,bj) .eq. 0.) then
                    mask13c(i,j) = 0. _d 0
                  endif

                  www(i,j)     = cosphi(i,j,bi,bj)
                enddo
              enddo

c              iglomin = (bi-1)*snx+1
c              i6min = iglomin-mod(iglomin,6)*6
              i6min=1

              do j = jmin,jmax-1,2
                do i = i6min,imax-5,6
             if ((mask13c(i,j)+mask13c(i+1,j)+mask13c(i+2,j)
     &           +mask13c(i+3,j)+mask13c(i+4,j)+mask13c(i+5,j)
     &           +mask13c(i,j+1)+mask13c(i+1,j+1)+mask13c(i+2,j+1)
     &           +mask13c(i+3,j+1)+mask13c(i+4,j+1)+mask13c(i+5,j+1))
     &         .eq.0.0) then
                    u6bar(i,j) = 0.0
                else
                    u6bar(i,j) = ( 
     &                  ubar(i,j,k,bi,bj)*mask13c(i,j) 
     &                + ubar(i+1,j,k,bi,bj)*mask13c(i+1,j)  
     &                + ubar(i+2,j,k,bi,bj)*mask13c(i+2,j) 
     &                + ubar(i+3,j,k,bi,bj)*mask13c(i+3,j)  
     &                + ubar(i+4,j,k,bi,bj)*mask13c(i+4,j) 
     &                + ubar(i+5,j,k,bi,bj)*mask13c(i+5,j) 
     &                + ubar(i,j+1,k,bi,bj)*mask13c(i,j+1) 
     &                + ubar(i+1,j+1,k,bi,bj)*mask13c(i+1,j+1)  
     &                + ubar(i+2,j+1,k,bi,bj)*mask13c(i+2,j+1) 
     &                + ubar(i+3,j+1,k,bi,bj)*mask13c(i+3,j+1)  
     &                + ubar(i+4,j+1,k,bi,bj)*mask13c(i+4,j+1) 
     &                + ubar(i+5,j+1,k,bi,bj)*mask13c(i+5,j+1) ) 
     &             / (mask13c(i,j)+mask13c(i+1,j)+mask13c(i+2,j)
     &               +mask13c(i+3,j)+mask13c(i+4,j)+mask13c(i+5,j)
     &               +mask13c(i,j+1)+mask13c(i+1,j+1)+mask13c(i+2,j+1)
     &               +mask13c(i+3,j+1)+mask13c(i+4,j+1)
     &               +mask13c(i+5,j+1) )
                  endif
                enddo
              enddo
              
              do j = jmin,jmax-1,2
                do i = i6min,imax-5,6
             if ((mask13c(i,j)+mask13c(i+1,j)+mask13c(i+2,j)
     &           +mask13c(i+3,j)+mask13c(i+4,j)+mask13c(i+5,j)
     &           +mask13c(i,j+1)+mask13c(i+1,j+1)+mask13c(i+2,j+1)
     &           +mask13c(i+3,j+1)+mask13c(i+4,j+1)+mask13c(i+5,j+1))
     &         .eq.0.0) then
                    v6bar(i,j) = 0.0
               else
                    v6bar(i,j) = ( 
     &                  vbar(i,j,k,bi,bj)*mask13c(i,j) 
     &                + vbar(i+1,j,k,bi,bj)*mask13c(i+1,j)  
     &                + vbar(i+2,j,k,bi,bj)*mask13c(i+2,j) 
     &                + vbar(i+3,j,k,bi,bj)*mask13c(i+3,j)  
     &                + vbar(i+4,j,k,bi,bj)*mask13c(i+4,j) 
     &                + vbar(i+5,j,k,bi,bj)*mask13c(i+5,j) 
     &                + vbar(i,j+1,k,bi,bj)*mask13c(i,j+1) 
     &                + vbar(i+1,j+1,k,bi,bj)*mask13c(i+1,j+1)  
     &                + vbar(i+2,j+1,k,bi,bj)*mask13c(i+2,j+1) 
     &                + vbar(i+3,j+1,k,bi,bj)*mask13c(i+3,j+1)  
     &                + vbar(i+4,j+1,k,bi,bj)*mask13c(i+4,j+1) 
     &                + vbar(i+5,j+1,k,bi,bj)*mask13c(i+5,j+1) ) 
     &             / (mask13c(i,j)+mask13c(i+1,j)+mask13c(i+2,j)
     &               +mask13c(i+3,j)+mask13c(i+4,j)+mask13c(i+5,j)
     &               +mask13c(i,j+1)+mask13c(i+1,j+1)+mask13c(i+2,j+1)
     &               +mask13c(i+3,j+1)+mask13c(i+4,j+1)
     &               +mask13c(i+5,j+1) )
                  endif
                enddo
              enddo
              
              do j = jmin,jmax-1,2
                do i = i6min,imax-5, 6
c--   change unit from cm/s to m/s
                  uddat(i,j) = 0.01*udriftdat(i,j,bi,bj)
                  vddat(i,j) = 0.01*vdriftdat(i,j,bi,bj)
c-- 5 cm/s lower limit
                  wud(i,j) = 1e4*max(wudrift(i,j,bi,bj),5.D0)**(-2)
                  wvd(i,j) = 1e4*max(wvdrift(i,j,bi,bj),5.D0)**(-2)
c                  wud(i,j) = 1.0
c                  wvd(i,j) = 1.0
                  mask6c(i,j) = 1.0
                  if ( uddat(i,j).eq.0.0) mask6c(i,j)=0.0
                  if ( abs(uddat(i,j)).gt.900) mask6c(i,j)=0.0
                  if ( vddat(i,j).eq.0.0) mask6c(i,j)=0.0
                  if ( abs(vddat(i,j)).gt.900) mask6c(i,j)=0.0
                enddo
              enddo

c--           Compute model data misfit and cost function term for
c             drifters.
              do j = jmin,jmax-1,2
                do i = i6min,imax-5, 6
                  fctile_drift = fctile_drift 
     &                          + (wud(i,j)*www(i,j)*mask6c(i,j)*
     &                            (u6bar(i,j) - uddat(i,j))*
     &                            (u6bar(i,j) - uddat(i,j))   ) 
     &                          + (wud(i,j)*www(i,j)*mask6c(i,j)*
     &                            (v6bar(i,j) - vddat(i,j))*
     &                            (v6bar(i,j) - vddat(i,j))   )
                enddo
              enddo

            fcthread_drift   = fcthread_drift + fctile_drift
            objf_drift(bi,bj) = objf_drift(bi,bj) + fctile_drift

#ifdef ECCO_VERBOSE
c--         Print cost function for each tile in each thread.
            write(msgbuf,'(a)') ' '
            call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
            write(msgbuf,'(a,i8.8,1x,i3.3,1x,i3.3)')
     &        ' cost_drifter: irec,bi,bj          =  ',irec,bi,bj
            call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
            write(msgbuf,'(a,d22.15)')
     &        '     cost function (temperature) = ',
     &        fctile_theta
            call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
#endif

          enddo
        enddo

#ifdef ECCO_VERBOSE
c--     Print cost function for all tiles.
        _GLOBAL_SUM_R8( fcthread_drift , myThid )
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,i8.8)')
     &    ' cost_drift: irec = ',irec
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a,d22.15)')
     &    ' global cost function value',
     &    ' (drifters) = ',fcthread_drift
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
#endif

#endif

      return
      end

