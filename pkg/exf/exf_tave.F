#include "EXF_CPPOPTIONS.h"

C     !ROUTINE: EXF_TAVE
C     !INTERFACE:
      SUBROUTINE EXF_TAVE(mythid)
C     *==========================================================*
C     | S/R  EXF_TAVE
C     | o save values for timeaveraging
C     |   for sea/ice surface and atmosphere
C     *==========================================================*

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "exf_fields.h"
#include "exf_diag.h" 
c     == routine arguments ==

      integer mythid


#ifdef ALLOW_BULKFORMULAE
#ifdef ALLOW_EXF_TIMEAVE
c     == Local variables ==
      integer bi,bj
      integer i,j
      integer jtlo
      integer jthi
      integer itlo
      integer ithi
      integer jmin
      integer jmax
      integer imin
      integer imax



C--     Time-average
      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1-oly
      jmax = sny+oly
      imin = 1-olx
      imax = snx+olx

      do bj = jtlo,jthi
         do bi = itlo,ithi
            do j = jmin,jmax
               do i = imin,imax

                  EXF_Qnet_AVE(i,j,bi,bj)=EXF_Qnet_AVE(i,j,bi,bj)
     &                 +hflux(i,j,bi,bj)*deltaTclock
#ifdef ALLOW_KPP
     &                 +swflux(i,j,bi,bj)*deltaTclock
#endif
                  EXF_EmPmR_AVE(i,j,bi,bj)=EXF_EmPmR_AVE(i,j,bi,bj)
     &                 +sflux(i,j,bi,bj)*deltaTclock
c     EXF_fu_AVE(i,j,bi,bj)=EXF_fu_AVE(i,j,bi,bj)
c     &                       +fu(i,j,bi,bj)*deltaTclock
c     EXF_fv_AVE(i,j,bi,bj)=EXF_fv_AVE(i,j,bi,bj)
c     &                       +fv(i,j,bi,bj)*deltaTclock
c     EXF_latent_AVE(i,j,bi,bj)=EXF_latent_AVE(i,j,bi,bj)
c     &                       +flh(i,j,bi,bj)*deltaTclock
c     EXF_sensible_AVE(i,j,bi,bj)=EXF_sensible_AVE(i,j,bi,bj)
c     &                       +fsh(i,j,bi,bj)*deltaTclock
c     EXF_evap_AVE(i,j,bi,bj)=EXF_evap_AVE(i,j,bi,bj)
c     &                       +evap(i,j,bi,bj)*deltaTclock
c     EXF_flwup_AVE(i,j,bi,bj)=EXF_flwup_AVE(i,j,bi,bj)
c     &                       +flwup(i,j,bi,bj)*deltaTclock
c     EXF_flwupnet_AVE(i,j,bi,bj)=EXF_flwupnet_AVE(i,j,bi,bj)
c     &                       +flwupnet(i,j,bi,bj)*deltaTclock
c     EXF_solar_AVE(i,j,bi,bj)=EXF_solar_AVE(i,j,bi,bj)
c     &                       +fswnet(i,j,bi,bj)*deltaTclock
c     EXF_ssq_AVE(i,j,bi,bj)=EXF_ssq_AVE(i,j,bi,bj)
c     &                       +savssq(i,j,bi,bj)*deltaTclock
               enddo
            enddo
            EXF_timeave(1,bi,bj)=EXF_timeave(1,bi,bj)+deltaTclock
         enddo
      enddo


#endif /* ALLOW_EXF_TIMEAVE*/
#endif /* ALLOW_BULKFORMULAE */
       return
      end

