C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_AveragesFields(
     I                                mytime,
     I                                myiter,
     I                                mythid
     &                              )

c     ==================================================================
c     SUBROUTINE cost_AveragesFields
c     ==================================================================
c
c     o Compute time averages of etaN, theta, and salt. The counters
c       are explicitly calculated instead of being incremented. This
c       reduces dependencies. The latter is useful for the adjoint code
c       generation.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 24-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     SUBROUTINE cost_AveragesFields
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "DYNVARS.h"
#include "CG2D.h"

#include "optim.h"
#include "cost.h"
#include "ctrl_dummy.h"

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

      logical first
      logical startofday
      logical startofmonth
      logical inday
      logical inmonth
      logical last
      logical endofday
      logical endofmonth

      integer ilps, ils,ilt

      _RL     dummy

      character*(128) fnamepsbar
      character*(128) fnametbar
      character*(128) fnamesbar
      character*(128) fnameubar
      character*(128) fnamevbar

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

c--   Get the time flags and record numbers for the time averaging.

      call cost_AveragesFlags(
     I                         myiter,  mytime,     mythid,
     O                         first,   startofday, startofmonth,
     O                         inday,   inmonth,
     O                         last,    endofday,   endofmonth,
     O                         sum1day, dayrec,
     O                         sum1mon, monrec
     &                        )

#ifdef ALLOW_SSH_COST_CONTRIBUTION
c--   First, do the daily averages.
      if (first .or. startofday) then
c--     Assign the first value to the array holding the average.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i =  imin,imax
                psbar(i,j,bi,bj) = etaN(i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo
      else if (last .or. endofday) then
c--     Add the last value and devide by the number of accumulated
c--     records.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                psbar(i,j,bi,bj)  = (psbar (i,j,bi,bj) +
     &                               etaN(i,j,bi,bj)   )/
     &                              float(sum1day)
              enddo
            enddo
          enddo
        enddo

c--     Save psbar on file.
        if (optimcycle .ge. 0) then
          ilps=ilnblnk( psbarfile )
          write(fnamepsbar,'(2a,i10.10)') psbarfile(1:ilps),
     &          '.', optimcycle
        else
          print*
          print*,' cost_AveragesFields: optimcycle has a wrong value.'
          print*,'                      optimcycle = ',optimcycle
          print*
          stop   ' ... stopped in cost_AveragesFields; psbar part.'
        endif

        call active_write_xy( fnamepsbar, psbar, dayrec, optimcycle,
     &                        mythid, xx_psbar_mean_dummy )

ce      , myiter, mytime )

      else if (       (       inday         ) .and.
     &          .not. (first .or. startofday) .and.
     &          .not. (last  .or. endofday  )       ) then
c--     Accumulate the array holding the average.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                psbar(i,j,bi,bj) = psbar(i,j,bi,bj) + etaN(i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo
      else
        print*
        print*,' cost_AveragesFields: Daily flags are set',
     &                              ' inappropriately.'
        print*
        stop   ' ... stopped in cost_AveragesFields; psbar part.'
      endif
#endif

#if (defined (ALLOW_THETA_COST_CONTRIBUTION) || \
     defined (ALLOW_SST_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDT_COST_CONTRIBUTION) || \
     defined (ALLOW_XBT_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
c--   Next, do the monthly average for temperature.
      if (first .or. startofmonth) then
c--     Assign the first value to the array holding the average.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i =  imin,imax
                  tbar(i,j,k,bi,bj) = theta(i,j,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        enddo
      else if (last .or. endofmonth) then
c--     Add the last value and devide by the number of accumulated
c--     records.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i = imin,imax
                  tbar(i,j,k,bi,bj)  = (tbar (i,j,k,bi,bj) +
     &                                  theta(i,j,k,bi,bj)   )/
     &                                 float(sum1mon)
                enddo
              enddo
            enddo
          enddo
        enddo

c--     Save tbar on file.
        if (optimcycle .ge. 0) then
          ilt=ilnblnk( tbarfile )
          write(fnametbar,'(2a,i10.10)') tbarfile(1:ilt),'.',optimcycle
        else
          print*
          print*,' cost_AveragesFields: optimcycle has a wrong value.'
          print*,'                      optimcycle = ',optimcycle
          print*
          stop   ' ... stopped in cost_AveragesFields; tbar part (3d).'
        endif

        call active_write_xyz( fnametbar, tbar, monrec, optimcycle,
     &                         mythid, xx_tbar_mean_dummy )

ce      , myiter, mytime )

      else if (       (       inmonth         ) .and.
     &          .not. (first .or. startofmonth) .and.
     &          .not. (last  .or. endofmonth  )       ) then
c--     Accumulate the array holding the average.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i =  imin,imax
                  tbar(i,j,k,bi,bj) = tbar (i,j,k,bi,bj) +
     &                                theta(i,j,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        enddo
      else
        print*
        print*,' cost_AveragesFields: Monthly flags a set',
     &                              ' inappropriately.'
        print*
        stop   ' ... stopped in cost_AveragesFields; tbar part (3d).'
      endif
#endif

#if (defined (ALLOW_SALT_COST_CONTRIBUTION) || \
     defined (ALLOW_SSS_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDS_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
c--   Next, do the monthly averages for salinity.
      if (first .or. startofmonth) then
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i =  imin,imax
                  sbar(i,j,k,bi,bj) = salt(i,j,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        enddo
      else if (last .or. endofmonth) then
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i = imin,imax
                  sbar(i,j,k,bi,bj)  = (sbar (i,j,k,bi,bj) +
     &                                  salt(i,j,k,bi,bj)   )/
     &                                 float(sum1mon)
                enddo
              enddo
            enddo
          enddo
        enddo

c--     Save sbar.
        if (optimcycle .ge. 0) then
          ils=ilnblnk( sbarfile )
          write(fnamesbar,'(2a,i10.10)') sbarfile(1:ils),'.',
     &                                             optimcycle
        else
          print*
          print*,' cost_AveragesFields: optimcycle has a wrong value.'
          print*
          stop   ' ... stopped in cost_AveragesFields; sbar part.'
        endif

        call active_write_xyz( fnamesbar, sbar, monrec, optimcycle,
     &                         mythid, xx_sbar_mean_dummy)

ce      , myiter, mytime )

      else if (       (       inmonth         ) .and.
     &          .not. (first .or. startofmonth) .and.
     &          .not. (last  .or. endofmonth  )       ) then
c--     Accumulate sbar.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i =  imin,imax
                  sbar(i,j,k,bi,bj) = sbar (i,j,k,bi,bj) +
     &                                salt (i,j,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        enddo
      else
        print*
        print*,' cost_AveragesFields: Monthly flags a set',
     &                              ' inappropriately.'
        print*
        stop   ' ... stopped in cost_AveragesFields; sbar part.'
      endif
#endif

#if (defined (ALLOW_DRIFTER_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
c--   Next, do the averages for velocitty.
      if (first) then
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i =  imin,imax
                  ubar(i,j,k,bi,bj) = uVel(i,j,k,bi,bj)
                  vbar(i,j,k,bi,bj) = vVel(i,j,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        enddo
      else if (last) then
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i = imin,imax
                  ubar(i,j,k,bi,bj)  = (ubar (i,j,k,bi,bj) +
     &                                  uVel(i,j,k,bi,bj)   )/
     &                                 float(sum1mon)
                  vbar(i,j,k,bi,bj)  = (vbar (i,j,k,bi,bj) +
     &                                  vVel(i,j,k,bi,bj)   )/
     &                                 float(sum1mon)
                enddo
              enddo
            enddo
          enddo
        enddo

c--     Save ubar and vbar.
        if (optimcycle .ge. 0) then
          ils=ilnblnk( ubarfile )
          write(fnameubar,'(2a,i10.10)') ubarfile(1:ils),'.',
     &                                             optimcycle
          write(fnamevbar,'(2a,i10.10)') vbarfile(1:ils),'.',
     &                                             optimcycle
        else
          print*
          print*,' cost_AveragesFields: optimcycle has a wrong value.'
          print*
          stop   ' ... stopped in cost_AveragesFields; sbar part.'
        endif

        call active_write_xyz( fnameubar, ubar, 1, optimcycle,
     &                         mythid, xx_ubar_mean_dummy)

        call active_write_xyz( fnamevbar, vbar, 1, optimcycle,
     &                         mythid, xx_vbar_mean_dummy)

ce      , myiter, mytime )

      else if ( .not. (first) .and.
     &          .not. (last)       ) then
c--     Accumulate ubar and vbar.
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr
              do j = jmin,jmax
                do i =  imin,imax
                  ubar(i,j,k,bi,bj) = ubar (i,j,k,bi,bj) +
     &                                uVel (i,j,k,bi,bj)
                  vbar(i,j,k,bi,bj) = vbar (i,j,k,bi,bj) +
     &                                vVel (i,j,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        enddo
      else
        print*
        print*,' cost_AveragesFields: Monthly flags a set',
     &                              ' inappropriately.'
        print*
        stop   ' ... stopped in cost_AveragesFields; ubar part.'
      endif
      
      
#endif

      return
      end

