C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_weights(
     I                         mythid
     &                       )

c     ==================================================================
c     SUBROUTINE cost_weights
c     ==================================================================
c
c     o Read the weights used for the cost function evaluation.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 25-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c              Christian Eckert eckert@mit.edu 02-May-2000
c
c              - corrected typo in mdsreadfield( sflux_errfile );
c                wp --> wsflux. Spotted by Patrick Heimbach.
c
c     ==================================================================
c     SUBROUTINE cost_weights
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"

#include "ctrl.h"
#include "cost.h"

c     == routine arguments ==

      integer  mythid

c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer gwunit
      integer irec,nnz
      integer ilo,ihi
      integer iobcs

      _RL factor
      _RL wti(nr)
      _RL wsi(nr)
      _RL wui(nr)
      _RL wvi(nr)
      _RL whflux0
      _RL wsflux0
      _RL wtau0
      _RL ratio
      _RL dummy

c     == external ==

      integer  ifnblnk
      external ifnblnk
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

c--   Initialize variance (weight) fields.
      do k = 1,nr
         wti(k) = 0. _d 0
         wsi(k) = 0. _d 0
         wui(k) = 0. _d 0
         wvi(k) = 0. _d 0
      enddo
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              whflux  (i,j,bi,bj) = 0. _d 0
              wsflux  (i,j,bi,bj) = 0. _d 0
              wtauu   (i,j,bi,bj) = 0. _d 0
              wtauv   (i,j,bi,bj) = 0. _d 0
              watemp  (i,j,bi,bj) = 0. _d 0
              waqh    (i,j,bi,bj) = 0. _d 0
              wuwind  (i,j,bi,bj) = 0. _d 0
              wvwind  (i,j,bi,bj) = 0. _d 0
              wsst    (i,j,bi,bj) = 0. _d 0
              wsss    (i,j,bi,bj) = 0. _d 0
              wtp     (i,j,bi,bj) = 0. _d 0
              wers    (i,j,bi,bj) = 0. _d 0
              wp      (i,j,bi,bj) = 0. _d 0
              wudrift (i,j,bi,bj) = 0. _d 0
              wvdrift (i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do k = 1,Nr
            wtheta (k,bi,bj) = 0. _d 0
            wsalt  (k,bi,bj) = 0. _d 0
            wctdt  (k,bi,bj) = 0. _d 0
            wctds  (k,bi,bj) = 0. _d 0
          enddo
        enddo
      enddo

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do k = 1,Nr
            do iobcs = 1,nobcs
#ifdef ALLOW_OBCSN_COST_CONTRIBUTION
              wobcsn(iobcs,k,bi,bj) = 0. _d 0
#endif
#ifdef ALLOW_OBCSS_COST_CONTRIBUTION
              wobcss(iobcs,k,bi,bj) = 0. _d 0
#endif
#ifdef ALLOW_OBCSW_COST_CONTRIBUTION
              wobcsw(iobcs,k,bi,bj) = 0. _d 0
#endif
#ifdef ALLOW_OBCSE_COST_CONTRIBUTION
              wobcse(iobcs,k,bi,bj) = 0. _d 0
#endif
            enddo
          enddo
        enddo
      enddo

c--   Build area weighting matrix used in the cost function
c--   contributions.

c--   Define frame.
      do j = jmin,jmax
        do i = imin,imax
c--       North/South and West/East edges set to zero.
          if ( (j .lt. 1) .or. (j .gt. sny) .or.
     &         (i .lt. 1) .or. (i .gt. snx)      ) then
            frame(i,j) = 0. _d 0
          else
            frame(i,j) = 1. _d 0
          endif
        enddo
      enddo

c--   First account for the grid used.
      if (usingCartesianGrid) then
        factor = 0. _d 0
      else if (usingSphericalPolarGrid) then
        factor = 1. _d 0
      endif

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              cosphi(i,j,bi,bj) = cos(yc(i,j,bi,bj)*deg2rad*factor)*
     &                            frame(i,j)
            enddo
          enddo
        enddo
      enddo

c--   Read error information and set up weight matrices.
      _BEGIN_MASTER(myThid)
        call mdsfindunit( gwunit, mythid )
        ilo = ifnblnk(data_errfile)
        ihi = ilnblnk(data_errfile)
        open(gwunit, file=data_errfile(ilo:ihi),
     &               status='old', form='formatted')

        read(gwunit,*) whflux0, wsflux0, wtau0, ratio
        do k = 1,nr
          read(gwunit,*) wti(k), wsi(k)
        end do
        close(gwunit)
      _END_MASTER(myThid)

      _BARRIER

      jmin = 1
      jmax = sny
      imin = 1
      imax = snx

      do bj = jtlo,jthi
        do bi = itlo,ithi

c--       The "classic" state estimation tool wastes memory here;
c--       as long as there is not more information available there
c--       is no need to add the zonal and meridional directions.
          do k = 1,nr
            wtheta(k,bi,bj) = wti(k)
            wsalt (k,bi,bj) = wsi(k)
          enddo

          do k = 1,nr
#ifdef ALLOW_OBCSN_COST_CONTRIBUTION
            wobcsn(1,k,bi,bj) = wti(k)
            wobcsn(2,k,bi,bj) = wsi(k)
            wobcsn(3,k,bi,bj) = wui(k)
            wobcsn(4,k,bi,bj) = wvi(k)
#endif
#ifdef ALLOW_OBCSS_COST_CONTRIBUTION
            wobcss(1,k,bi,bj) = wti(k)
            wobcss(2,k,bi,bj) = wsi(k)
            wobcss(3,k,bi,bj) = wui(k)
            wobcss(4,k,bi,bj) = wvi(k)
#endif
#ifdef ALLOW_OBCSW_COST_CONTRIBUTION
            wobcsw(1,k,bi,bj) = wti(k)
            wobcsw(2,k,bi,bj) = wsi(k)
            wobcsw(3,k,bi,bj) = wui(k)
            wobcsw(4,k,bi,bj) = wvi(k)
#endif
#ifdef ALLOW_OBCSE_COST_CONTRIBUTION
            wobcse(1,k,bi,bj) = wti(k)
            wobcse(2,k,bi,bj) = wsi(k)
            wobcse(3,k,bi,bj) = wui(k)
            wobcse(4,k,bi,bj) = wvi(k)
#endif
          enddo

          k = 1
          do j = jmin,jmax
            do i = imin,imax
              if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                wsst(i,j,bi,bj) = 0. _d 0
                wsss(i,j,bi,bj) = 0. _d 0
              else
                wsst(i,j,bi,bj) = wtheta(k,bi,bj)*10.
                wsss(i,j,bi,bj) = wsalt(k,bi,bj)*10.
              endif
            enddo
          enddo
        enddo
      enddo

#ifdef ALLOW_EGM96_ERROR_COV
c--   Read egm-96 geoid covariance. Data in units of meters.
      nnz   =  1
      irec  =  1
      call mdsreadfield( geoid_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wp, irec, mythid )
#else
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              wp(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
#endif

#ifdef ALLOW_SSH_COST_CONTRIBUTION
c--   Read T/P SSH anomaly rms field. Data in units of centimeters.
      nnz   =   1
      irec  =   1
      call mdsreadfield( ssh_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wtp, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          k = 1
          do j = jmin,jmax
            do i = imin,imax
c--           Unit conversion to meters. ERS error is set to
c--           T/P error + 5cm
              if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                wtp (i,j,bi,bj) = 0. _d 0
                wers(i,j,bi,bj) = 0. _d 0
              else
                wtp (i,j,bi,bj) = wtp(i,j,bi,bj) * 0.01 * 0.5
                wers(i,j,bi,bj) = wtp(i,j,bi,bj) + 0.05
              endif
            enddo
          enddo
        enddo
      enddo
#endif /* ALLOW_SSH_COST_CONTRIBUTION */

c--   Read zonal wind stress variance.
#if (defined (ALLOW_NSCAT_DATA))
      nnz   =   1
      irec  =   1
      call mdsreadfield( tauu_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wtauu, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          k = 1
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (wtauu(i,j,bi,bj) .lt. -9900.) then
                wtauu(i,j,bi,bj) = 0. _d 0
              endif
              wtauu(i,j,bi,bj) = wtauu(i,j,bi,bj)*0.1
              wtauu(i,j,bi,bj) = max(wtauu(i,j,bi,bj),wtau0)
              wtauu(i,j,bi,bj) = wtauu(i,j,bi,bj)*maskw(i,j,k,bi,bj)*
     &                         frame(i,j)
            enddo
          enddo
        enddo
      enddo
#elif (defined (ALLOW_USTRESS_COST_CONTRIBUTION))
      nnz   =   1
ce      irec  =   2
ce(   due to Patrick's processing:
      irec  = 1
ce)
      call mdsreadfield( tauu_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wtauu, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          k = 1
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (wtauu(i,j,bi,bj) .lt. -9900.) then
                wtauu(i,j,bi,bj) = 0. _d 0
              endif
              wtauu(i,j,bi,bj) = wtauu(i,j,bi,bj)*0.1
              wtauu(i,j,bi,bj) = max(wtauu(i,j,bi,bj),wtau0)
              wtauu(i,j,bi,bj) = wtauu(i,j,bi,bj)*maskw(i,j,k,bi,bj)*
     &                         frame(i,j)
             enddo
          enddo
        enddo
      enddo
#elif (defined (ALLOW_UWIND_COST_CONTRIBUTION))
      nnz   =   1
ce      irec  =   2
ce(   due to Patrick's processing:
      irec  = 1
ce)
      call mdsreadfield( uwind_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wuwind, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          k = 1
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (wuwind(i,j,bi,bj) .lt. -9900.) then
                wuwind(i,j,bi,bj) = 0. _d 0
              endif
              wuwind(i,j,bi,bj) = wuwind(i,j,bi,bj)*0.1
              wuwind(i,j,bi,bj) = max(wuwind(i,j,bi,bj),wtau0)
              wuwind(i,j,bi,bj) = wuwind(i,j,bi,bj)*maskw(i,j,k,bi,bj)*
     &                         frame(i,j)
             enddo
          enddo
        enddo
      enddo
cph(
      print *, 'WARNING: wtau0 needs to be replaced by wwind0!!!'
cph)
#endif

c--   Read meridional wind stress variance.
#if (defined (ALLOW_NSCAT_DATA))
      nnz   =   1
      irec  =   1
      call mdsreadfield( tauv_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wtauv, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          k = 1
          do j = jmin,jmax
            do i = imiin,imax
c--           Test for missing values.
              if (wtauv(i,j,bi,bj) .lt. -9900.) then
                wtauv(i,j,bi,bj) = 0. _d 0
              endif
              wtauv(i,j,bi,bj) = wtauv(i,j,bi,bj)*0.1
              wtauv(i,j,bi,bj) = max(wtauv(i,j,bi,bj),wtau0)
              wtauv(i,j,bi,bj) = wtauv(i,j,bi,bj)*masks(i,j,k,bi,bj)*
     &                         frame(i,j)
            enddo
          enddo
        enddo
      enddo
#elif (defined (ALLOW_VSTRESS_COST_CONTRIBUTION))
      nnz   =   1
ce      irec  =   2
ce(   due to Patrick's processing:
      irec  = 1
ce)

      call mdsreadfield( tauv_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wtauv, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (wtauv(i,j,bi,bj) .lt. -9900.) then
                wtauv(i,j,bi,bj) = 0. _d 0
              endif
              wtauv(i,j,bi,bj) = wtauv(i,j,bi,bj)*0.1
              wtauv(i,j,bi,bj) = max(wtauv(i,j,bi,bj),wtau0)
              wtauv(i,j,bi,bj) = wtauv(i,j,bi,bj)*masks(i,j,k,bi,bj)*
     &                         frame(i,j)
            enddo
          enddo
        enddo
      enddo
#elif (defined (ALLOW_VWIND_COST_CONTRIBUTION))
      nnz   =   1
ce      irec  =   2
ce(   due to Patrick's processing:
      irec  = 1
ce)

      call mdsreadfield( vwind_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wvwind, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (wvwind(i,j,bi,bj) .lt. -9900.) then
                wvwind(i,j,bi,bj) = 0. _d 0
              endif
              wvwind(i,j,bi,bj) = wvwind(i,j,bi,bj)*0.1
              wvwind(i,j,bi,bj) = max(wvwind(i,j,bi,bj),wtau0)
              wvwind(i,j,bi,bj) = wvwind(i,j,bi,bj)*masks(i,j,k,bi,bj)*
     &                         frame(i,j)
            enddo
          enddo
        enddo
      enddo
#endif

#if (defined (ALLOW_HFLUX_COST_CONTRIBUTION))
c--   Read heat flux flux variance.
      nnz   =  1
c--   First  record in data file:  mean field.
c--   Second record in data file:  rms  field.
ce      irec  =  2
ce(   due to Patrick's processing:
      irec  = 1
ce)
      call mdsreadfield( hflux_errfile, cost_iprec, cost_yftype, nnz, 
     &                   whflux, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (whflux(i,j,bi,bj) .lt. -9900.) then
                whflux(i,j,bi,bj) = 0. _d 0
              endif
              whflux(i,j,bi,bj) = max(whflux(i,j,bi,bj),whflux0)
c--           Data are in units of W/m**2.
              whflux(i,j,bi,bj) = whflux(i,j,bi,bj)/3.
            enddo
          enddo
        enddo
      enddo
#elif (defined (ALLOW_ATEMP_COST_CONTRIBUTION))
c--   Read atmos. temp. variance.
      nnz   =  1
c--   First  record in data file:  mean field.
c--   Second record in data file:  rms  field.
ce      irec  =  2
ce(   due to Patrick's processing:
      irec  = 1
ce)
      call mdsreadfield( atemp_errfile, cost_iprec, cost_yftype, nnz, 
     &                   watemp, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (watemp(i,j,bi,bj) .lt. -9900.) then
                watemp(i,j,bi,bj) = 0. _d 0
              endif
              watemp(i,j,bi,bj) = max(watemp(i,j,bi,bj),whflux0)
c--           Data are in units of W/m**2.
              watemp(i,j,bi,bj) = watemp(i,j,bi,bj)/3.
            enddo
          enddo
        enddo
      enddo
cph(
      print *, 'WARNING: whflux0 needs to be replaced by watemp0!!!'
cph)
#endif

#if (defined (ALLOW_SFLUX_COST_CONTRIBUTION))
c--   Read salt flux variance. Second read: data in units of m/s.
      nnz   =  1
c--   First  record in data file:  mean field.
c--   Second record in data file:  rms  field.
ce      irec  =  2
ce(   due to Patrick's processing:
      irec  = 1
ce)
      call mdsreadfield( sflux_errfile, cost_iprec, cost_yftype, nnz, 
     &                   wsflux, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (wsflux(i,j,bi,bj) .lt. -9900.) then
                wsflux(i,j,bi,bj) = 0. _d 0
              endif
              wsflux(i,j,bi,bj) = max(wsflux(i,j,bi,bj),wsflux0)
c--           Data are in units of m/s.
            enddo
          enddo
        enddo
      enddo
#elif (defined (ALLOW_AQH_COST_CONTRIBUTION))
c--   Secific humid. variance. Second read: data in units of m/s.
      nnz   =  1
c--   First  record in data file:  mean field.
c--   Second record in data file:  rms  field.
ce      irec  =  2
ce(   due to Patrick's processing:
      irec  = 1
ce)
      call mdsreadfield( aqh_errfile, cost_iprec, cost_yftype, nnz, 
     &                   waqh, irec, mythid )

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
c--           Test for missing values.
              if (waqh(i,j,bi,bj) .lt. -9900.) then
                waqh(i,j,bi,bj) = 0. _d 0
              endif
              waqh(i,j,bi,bj) = max(waqh(i,j,bi,bj),wsflux0)
c--           Data are in units of m/s.
            enddo
          enddo
        enddo
      enddo
cph(
      print *, 'WARNING: wsflux0 needs to be replaced by waqh0!!!'
cph)
#endif

c--   Units have to be checked!
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              if (wtp(i,j,bi,bj) .ne. 0.) then
                wtp (i,j,bi,bj) = 1./wtp(i,j,bi,bj)/wtp(i,j,bi,bj)
              endif
              if (wers(i,j,bi,bj) .ne. 0.) then
                wers(i,j,bi,bj) = 1./wers(i,j,bi,bj)/wers(i,j,bi,bj)
              endif
              if (wsst(i,j,bi,bj) .ne. 0.) then
                wsst(i,j,bi,bj) = 1./wsst(i,j,bi,bj)/wsst(i,j,bi,bj)
              endif
              if (wsss(i,j,bi,bj) .ne. 0.) then
                wsss(i,j,bi,bj) = 1./wsss(i,j,bi,bj)/wsss(i,j,bi,bj)
              endif
              if (wp(i,j,bi,bj) .ne. 0.) then
                wp(i,j,bi,bj) = 1./wp(i,j,bi,bj)/wp(i,j,bi,bj)
              endif
              if (wtauu(i,j,bi,bj) .ne. 0.) then
                wtauu(i,j,bi,bj) = 1./wtauu(i,j,bi,bj)/wtauu(i,j,bi,bj)
              else
                wtauu(i,j,bi,bj) = 1.0 _d 0
              endif
              if (wtauv(i,j,bi,bj) .ne. 0.) then
                wtauv(i,j,bi,bj) = 1./wtauv(i,j,bi,bj)/wtauv(i,j,bi,bj)
              else
                wtauv(i,j,bi,bj) = 1.0 _d 0
              endif
              if (whflux(i,j,bi,bj) .ne. 0.) then
                whflux(i,j,bi,bj) =
     &                1./whflux(i,j,bi,bj)/whflux(i,j,bi,bj)
              else
                whflux(i,j,bi,bj) = 1.0 _d 0
              endif
              if (wsflux(i,j,bi,bj) .ne. 0.) then
                wsflux(i,j,bi,bj) =
     &                1./wsflux(i,j,bi,bj)/wsflux(i,j,bi,bj)
              else
                wsflux(i,j,bi,bj) = 1.0 _d 0
              endif
              if (wuwind(i,j,bi,bj) .ne. 0.) then
                wuwind(i,j,bi,bj) = 
     &                1./wuwind(i,j,bi,bj)/wuwind(i,j,bi,bj)
              else
                wuwind(i,j,bi,bj) = 1.0 _d 0
              endif
              if (wvwind(i,j,bi,bj) .ne. 0.) then
                wvwind(i,j,bi,bj) = 
     &                1./wvwind(i,j,bi,bj)/wvwind(i,j,bi,bj)
              else
                wvwind(i,j,bi,bj) = 1.0 _d 0
              endif
              if (watemp(i,j,bi,bj) .ne. 0.) then
                watemp(i,j,bi,bj) =
     &                1./watemp(i,j,bi,bj)/watemp(i,j,bi,bj)
              else
                watemp(i,j,bi,bj) = 1.0 _d 0
              endif
              if (waqh(i,j,bi,bj) .ne. 0.) then
                waqh(i,j,bi,bj) =
     &                1./waqh(i,j,bi,bj)/waqh(i,j,bi,bj)
              else
                waqh(i,j,bi,bj) = 1.0 _d 0
              endif
            enddo
          enddo

          do k = 1,nr
            if (wtheta(k,bi,bj) .ne. 0.) then
              wtheta(k,bi,bj) = ratio/wtheta(k,bi,bj)/wtheta(k,bi,bj)
            else
              wtheta(k,bi,bj) = 1.0 _d 0
            endif
            if (wsalt(k,bi,bj) .ne. 0.) then
              wsalt(k,bi,bj) = ratio/wsalt(k,bi,bj)/wsalt(k,bi,bj)
            else
              wsalt(k,bi,bj) = 1.0 _d 0
            endif
          enddo

          do k = 1,nr
            do iobcs = 1,nobcs
#ifdef ALLOW_OBCSN_COST_CONTRIBUTION
              if (wobcsn(iobcs,k,bi,bj) .ne. 0.) then
                 wobcsn(iobcs,k,bi,bj) = 
     &                ratio/wobcsn(iobcs,k,bi,bj)/wobcsn(iobcs,k,bi,bj)
              else
                 wobcsn(iobcs,k,bi,bj) = 1.0 _d 0
              endif
#endif
#ifdef ALLOW_OBCSS_COST_CONTRIBUTION
              if (wobcss(iobcs,k,bi,bj) .ne. 0.) then
                 wobcss(iobcs,k,bi,bj) = 
     &                ratio/wobcss(iobcs,k,bi,bj)/wobcss(iobcs,k,bi,bj)
              else
                 wobcss(iobcs,k,bi,bj) = 1.0 _d 0
              endif
#endif
#ifdef ALLOW_OBCSW_COST_CONTRIBUTION
              if (wobcsw(iobcs,k,bi,bj) .ne. 0.) then
                 wobcsw(iobcs,k,bi,bj) = 
     &                ratio/wobcsw(iobcs,k,bi,bj)/wobcsw(iobcs,k,bi,bj)
              else
                 wobcsw(iobcs,k,bi,bj) = 1.0 _d 0
              endif
#endif
#ifdef ALLOW_OBCSE_COST_CONTRIBUTION
              if (wobcse(iobcs,k,bi,bj) .ne. 0.) then
                 wobcse(iobcs,k,bi,bj) = 
     &                ratio/wobcse(iobcs,k,bi,bj)/wobcse(iobcs,k,bi,bj)
              else
                 wobcse(iobcs,k,bi,bj) = 1.0 _d 0
              endif
#endif
            enddo
          enddo

        enddo
      enddo

c--   Loop over the whole tile.
      jmin = 1
      jmax = sny
      imin = 1
      imax = snx

c--   Set all tile edges to zero.
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              cosphi(i,j,bi,bj) = cosphi(i,j,bi,bj)*frame(i,j)
              whflux(i,j,bi,bj) = whflux(i,j,bi,bj)*frame(i,j)
              wsflux(i,j,bi,bj) = wsflux(i,j,bi,bj)*frame(i,j)
              wtauu (i,j,bi,bj) = wtauu (i,j,bi,bj)*frame(i,j)
              wtauv (i,j,bi,bj) = wtauv (i,j,bi,bj)*frame(i,j)
              watemp(i,j,bi,bj) = watemp(i,j,bi,bj)*frame(i,j)
              waqh  (i,j,bi,bj) = waqh  (i,j,bi,bj)*frame(i,j)
              wuwind(i,j,bi,bj) = wuwind(i,j,bi,bj)*frame(i,j)
              wvwind(i,j,bi,bj) = wvwind(i,j,bi,bj)*frame(i,j)
              wsst  (i,j,bi,bj) = wsst  (i,j,bi,bj)*frame(i,j)
              wsss  (i,j,bi,bj) = wsss  (i,j,bi,bj)*frame(i,j)
              wtp   (i,j,bi,bj) = wtp   (i,j,bi,bj)*frame(i,j)
              wers  (i,j,bi,bj) = wers  (i,j,bi,bj)*frame(i,j)
              wp    (i,j,bi,bj) = wp    (i,j,bi,bj)*frame(i,j)
            enddo
          enddo
        enddo
      enddo
      
c
c     write masks and weights to files to be read by a master process
c
      call active_write_xyz( 'hFacC',hFacC ,   1, 0, mythid, dummy)
      call active_write_xyz( 'maskW', maskW,   1, 0, mythid, dummy)
      call active_write_xyz( 'maskS', maskS,   1, 0, mythid, dummy)

#if   (defined (ALLOW_HFLUX_COST_CONTRIBUTION))
      call active_write_xy(  'whflux', whflux, 1, 0, mythid, dummy)
#elif (defined (ALLOW_ATEMP_COST_CONTRIBUTION))
      call active_write_xy(  'watemp', watemp, 1, 0, mythid, dummy)
#endif

#if   (defined (ALLOW_SFLUX_COST_CONTRIBUTION))
      call active_write_xy(  'wsflux', wsflux, 1, 0, mythid, dummy)
#elif (defined (ALLOW_AQH_COST_CONTRIBUTION))
      call active_write_xy(  'waqh', waqh, 1, 0, mythid, dummy)
#endif

#if   (defined (ALLOW_USTRESS_COST_CONTRIBUTION))
      call active_write_xy(  'wtauu', wtauu,   1, 0, mythid, dummy)
#elif (defined (ALLOW_UWIND_COST_CONTRIBUTION))
      call active_write_xy(  'wuwind', wuwind, 1, 0, mythid, dummy)
#endif

#if   (defined (ALLOW_VSTRESS_COST_CONTRIBUTION))
      call active_write_xy(  'wtauv', wtauv,   1, 0, mythid, dummy)
#elif (defined (ALLOW_VWIND_COST_CONTRIBUTION))
      call active_write_xy(  'wvwind', wvwind, 1, 0, mythid, dummy)
#endif

      end
