C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_CTDS(
     I                     myiter,
     I                     mytime,
     I                     mythid
     &                   )

c     ==================================================================
c     SUBROUTINE cost_CTDS
c     ==================================================================
c
c     o Evaluate cost function contribution of CTD temperature data.
c
c     started:  Elisabeth Remy eremy@ucsd.edu 30-Aug-2000
c
c
c     ==================================================================
c     SUBROUTINE cost_CTDS
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
      integer nrec
      integer irec
      integer ilu
      
      _RL fctile_ctds
      _RL fcthread_ctds
      _RL www (1-olx:snx+olx,1-oly:sny+oly)
      _RL wtmp (1-olx:snx+olx,1-oly:sny+oly)
      _RL tmpobs (1-olx:snx+olx,1-oly:sny+oly)
      _RL tmpbar (1-olx:snx+olx,1-oly:sny+oly)
      _RL cmask (1-olx:snx+olx,1-oly:sny+oly)  
      _RL spval
      
      character*(80) fnamesalt

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
      
      spval = -9990.

c--   Read state record from global file.
      doglobalread = .false.
      ladinit      = .false.
      
c      call cal_TimePassed( topexstartdate, middate, difftime, mythid )
c      call cal_ToSeconds( difftime, diffsecs, mythid )

#ifdef ALLOW_CTDS_COST_CONTRIBUTION

#ifdef ECCO_VERBOSE
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i8.8)')
     &  ' cost_CTDS: number of records to process =', nmonsrec
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif

      if (optimcycle .ge. 0) then
        ilu=ilnblnk( sbarfile )
        write(fnamesalt(1:80),'(2a,i10.10)') sbarfile(1:ilu),'.',
     &                                   optimcycle
      else
        print*
        print*,' cost_CTDS: optimcycle has a wrong value.'
        print*,'                 optimcycle = ',optimcycle
        print*
        stop   '  ... stopped in cost_CTDS.'
      endif
      
      fcthread_ctds = 0. _d 0

c--   Loop over records.
      do irec = 1,nmonsrec

c--     Read time averages and the monthly mean data.
        call active_read_xy( fnamesalt, sbar, irec,
     &          doglobalread, ladinit,
     &          optimcycle, mythid
     &   , xx_sbar_mean_dummy )
  
ce     &                       myiter, mytime )

c--     Determine the record to be read on observations.

c        levoff = mod(modelstartdate(1)/100,100)
c        levmon = (irec-1) + levoff
c        levmon = mod(levmon-1,12)+1
              
ccc        call cost_ReadCtd( mythid )
        call mdsreadfield( ctdsfile, 64, 'RL', nr, ctdsobs, irec,
     &                     mythid)

c--     Loop over this thread's tiles.
        do bj = jtlo,jthi
          do bi = itlo,ithi
c--         Loop over the model layers

            fctile_ctds = 0. _d 0

            do k = 1,nr

c--           Determine the weights to be used.
              do j = jmin,jmax
                do i = imin,imax
                  cmask(i,j) = 1. _d 0
                  if (ctdsobs(i,j,k,bi,bj) .eq. 0.) then
                    cmask(i,j) = 0. _d 0
                  endif
                 
                  if (ctdsobs(i,j,k,bi,bj) .lt. spval) then
                    cmask(i,j) = 0. _d 0
                  endif
                  
                enddo
              enddo
              
              do j = jmin,jmax
                do i = imin,imax
                  www(i,j)    = cosphi(i,j,bi,bj)*cmask(i,j)                
                  tmpobs(i,j) = ctdsobs(i,j,k,bi,bj)
                  tmpbar(i,j) = sbar(i,j,k,bi,bj)
                  wtmp(i,j) = wsalt(k,bi,bj)
                enddo
              enddo

              do j = jmin,jmax
                do i = imin,imax
c--               The array ctdsobs contains CTD salinity.
                  if(cmask(i,j).eq.1.0) then 
                    print *,'cost_ctds',i,j,tmpbar(i,j),tmpobs(i,j)
                  endif
                  fctile_ctds = fctile_ctds + 
     &                             (wtmp(i,j)*www(i,j))*
     &                             (tmpbar(i,j)-tmpobs(i,j))*
     &                             (tmpbar(i,j)-tmpobs(i,j))

                enddo
              enddo
            enddo
c--         End of loop over layers.

            fcthread_ctds    = fcthread_ctds    + fctile_ctds
            objf_ctds(bi,bj) = objf_ctds(bi,bj) + fctile_ctds   

#ifdef ECCO_VERBOSE
            write(msgbuf,'(a)') ' '
            call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
            write(msgbuf,'(a,i8.8,1x,i3.3,1x,i3.3)')
     &        ' COST_CTDS: irec,bi,bj            =  ',irec,bi,bj
            call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
            write(msgbuf,'(a,d22.15)')
     &        ' COST_CTDS: cost function         = ', fctile_ctds
            call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
            write(msgbuf,'(a)') ' '
            call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
#endif

         enddo
        enddo

#ifdef ECCO_VERBOSE
c--     Print cost function for all tiles.
        _GLOBAL_SUM_R8( fcthread_ctds , myThid )
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,i8.8)')
     &    ' cost_CTDS: irec =  ',irec
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a,d22.15)')
     &    ' global cost function value',
     &    ' ( CTD sal. )  = ',fcthread_ctds
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
#endif

      enddo
c--   End of second loop over records.

#else
c--   Do not enter the calculation of the CTD temperature contribution
c--   to the final cost function.
      
      fctile_ctds   = 0. _d 0
      fcthread_ctds = 0. _d 0

crg
      nrec = 1
crg

      _BEGIN_MASTER( mythid )
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a)')
     &    ' cost_CTDS: no contribution of CTD temperature ',
     &                    ' to cost function.'
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a,i9.8)')
     &    ' cost_CDTS: number of records that would have',
     &                      ' been processed: ',nrec
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
      _END_MASTER( mythid )
#endif

      return
      end
