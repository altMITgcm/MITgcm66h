C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: EXTERNAL_FORCING_TR
C     !INTERFACE:
      SUBROUTINE EXTERNAL_FORCING_TR(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myTime,myThid)

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R EXTERNAL_FORCING_TR                                    
C     | o Contains problem specific forcing for tracer Tr1.   
C     *==========================================================*
C     | Adds terms to gTr1 for forcing by external sources.
C     | This routine is hardcoded for OCMIP CFC-11 experiment.
C     | It assumes that myTime=0 on January 1 for FICE, XKW,
C     | and PATM, and data.cal provides the date for cfc1112.atm.
C     | See the OCMIP-2 CFC HOWTO for details.
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "TR1.h"

      _RL      sc_cfc, sol_cfc
      EXTERNAL sc_cfc, sol_cfc

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myTime
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     i,j          :: Loop counters
C     aWght, bWght :: Interpolation weights
      INTEGER i,j,intime0,intime1,nForcingPeriods
      INTEGER currentdate(4), tempdate(4), timediff(4)
      _RL aWght,bWght,rdt,timeint
      _RL fprd,fcyc,ftm,ftmold
      _RL KW,CSAT,ALPHA,PCFC,PCFC1,PCFC2,TMP1,TMP2
CEOP

      IF ( kLev .EQ. 1 ) THEN

C     Find records and compute interpolation weights
         fprd    = 2629800
         fcyc    = 31557600
         nForcingPeriods = fcyc / fprd
         ftm     = mod( myTime + fcyc - fprd / 2 , fcyc )
         intime0 = int( ftm / fprd )
         intime1 = mod( intime0 + 1, nForcingPeriods )
         aWght   = ( ftm - fprd * intime0 ) / ( fprd )
         bWght   = 1. - aWght
         intime0 = intime0 + 1
         intime1 = intime1 + 1

C     Now calculate whether it is time to update the forcing arrays
         ftmold = mod( myTime - deltaTclock + fcyc - fprd / 2 , fcyc )
         IF (
     &        (int(ftmold/fprd)+1) .NE. intime0
     &        .OR. myTime .EQ. startTime
     &        ) THEN
C     If the above condition is met then we need to read in
C     data for the period ahead and the period behind myTime.
            _BEGIN_MASTER(myThid)
            WRITE(*,*)
     &           'S/R EXTERNAL_FORCING_TR: Reading new data',myTime

#define CFC_USE_INTERP
C-- CFC_USE_INTERP option is useful for high-resolution integrations.
C   For low-resolution, less that 1-deg, it's best to generate files
C   separately because of sea-ice fraction.
C   Caution: CFC_USE_INTERP as used is not thread-safe.
#ifdef CFC_USE_INTERP
            CALL NEW_INTERP( FiceFile,readBinaryPrec,fice0,intime0,
     &           xC,yC,lon0,lon_inc,lat0,lat_inc,nlon,nlat,mythid )
            CALL NEW_INTERP( FiceFile,readBinaryPrec,fice1,intime1,
     &           xC,yC,lon0,lon_inc,lat0,lat_inc,nlon,nlat,mythid )
            CALL NEW_INTERP( XkwFile,readBinaryPrec,xkw0,intime0,
     &           xC,yC,lon0,lon_inc,lat0,lat_inc,nlon,nlat,mythid )
            CALL NEW_INTERP( XkwFile,readBinaryPrec,xkw1,intime1,
     &           xC,yC,lon0,lon_inc,lat0,lat_inc,nlon,nlat,mythid )
            CALL NEW_INTERP( PatmFile,readBinaryPrec,patm0,intime0,
     &           xC,yC,lon0,lon_inc,lat0,lat_inc,nlon,nlat,mythid )
            CALL NEW_INTERP( PatmFile,readBinaryPrec,patm1,intime1,
     &           xC,yC,lon0,lon_inc,lat0,lat_inc,nlon,nlat,mythid )
#else
            CALL MDSREADFIELD ( FiceFile, readBinaryPrec,
     &           'RS', 1, fice0, intime0, myThid )
            CALL MDSREADFIELD ( FiceFile, readBinaryPrec,
     &           'RS', 1, fice1, intime1, myThid )
            CALL MDSREADFIELD ( XkwFile, readBinaryPrec,
     &           'RS', 1, xkw0, intime0, myThid )
            CALL MDSREADFIELD ( XkwFile, readBinaryPrec,
     &           'RS', 1, xkw1, intime1, myThid )
            CALL MDSREADFIELD ( PatmFile, readBinaryPrec,
     &           'RS', 1, patm0, intime0, myThid )
            CALL MDSREADFIELD ( PatmFile, readBinaryPrec,
     &           'RS', 1, patm1, intime1, myThid )
#endif

            _END_MASTER(myThid)
            _EXCH_XY_R4(fice0 , myThid )
            _EXCH_XY_R4(fice1 , myThid )
            _EXCH_XY_R4(xkw0  , myThid )
            _EXCH_XY_R4(xkw1  , myThid )
            _EXCH_XY_R4(patm0 , myThid )
            _EXCH_XY_R4(patm1 , myThid )
         ENDIF

C--   Interpolate in time
         DO j=1-Oly,sNy+Oly
            DO i=1-Olx,sNx+Olx
               fice(i,j,bi,bj) = bWght*fice0(i,j,bi,bj) +
     &                           aWght*fice1(i,j,bi,bj)
               if( fice(i,j,bi,bj) .LT. 0.2 ) fice(i,j,bi,bj) = 0.0
               xkw(i,j,bi,bj)  = bWght* xkw0(i,j,bi,bj) +
     &                           aWght* xkw1(i,j,bi,bj)
               patm(i,j,bi,bj) = bWght*patm0(i,j,bi,bj) +
     &                           aWght*patm1(i,j,bi,bj)
            ENDDO
         ENDDO

C     Find records and interpolation weights for PCFC
         call cal_FullDate( 19310101, 0, tempdate, mythid )
         call cal_GetDate( 0, mytime, currentdate, mythid )
         call cal_SubDates( currentdate, tempdate, timediff, mythid )
         if( timediff(1) .GT. 0 ) then
            call cal_ToSeconds( timediff, timeint, mythid )
         else
            timeint=0
         endif
         fprd    = 31557600
         ftm     = timeint + fprd / 2
         intime0 = int( ftm / fprd )
         intime1 = intime0 + 1
         aWght   = ( ftm - fprd * intime0 ) / ( fprd )
         bWght   = 1. - aWght
         intime0 = intime0 + 1930
         intime1 = intime1 + 1930
         PCFC1   = bWght * CFCp11(intime0,1) + aWght * CFCp11(intime1,1)
         PCFC2   = bWght * CFCp11(intime0,2) + aWght * CFCp11(intime1,2)

C--   Forcing term: add tracer in top-layer
C     TR1  is tracer concentration in mol/m^3
C     OCMIP formula provides air-sea flux F in mol/m^2/s
C     GTR1 = F / drF(1) in mol/m^3/s
C
         DO j=jMin,jMax
            DO i=iMin,iMax
               TMP1  = theta(i,j,1,bi,bj)
               TMP2  = salt(i,j,1,bi,bj)
               KW    = (1.-fice(i,j,bi,bj)) * xkw(i,j,bi,bj) *
     &                 (sc_cfc(TMP1,11)/660)**(-1/2)
               PCFC  = pCFCw1(I,J,bi,bj) * PCFC1 +
     &                 pCFCw2(I,J,bi,bj) * PCFC2
               ALPHA = sol_cfc(TMP1,TMP2,11)
               CSAT  = ALPHA * PCFC * patm(i,j,bi,bj)
               TMP1  = KW * ( CSAT - Tr1(i,j,1,bi,bj) )
               surfaceTendencyTr1(i,j,bi,bj) =
     &              TMP1 * recip_drF(1) * recip_hFacC(i,j,1,bi,bj)
            ENDDO
         ENDDO

      ENDIF

      RETURN
      END

C====================================================================

      _RL FUNCTION sc_cfc(t,kn)

c---------------------------------------------------
c     CFC 11 and 12 schmidt number 
c     as a fonction of temperature. 
c
c     ref: Zheng et al (1998), JGR, vol 103,No C1 
c
c     t: temperature (degree Celcius)
c     kn: = 11 for CFC-11,  12 for CFC-12
c
c     J-C Dutay - LSCE
c---------------------------------------------------

      IMPLICIT NONE 
      INTEGER kn
      _RL a1 ( 11: 12), a2 ( 11: 12), a3 ( 11: 12), a4 ( 11: 12)
      _RL t
c
c   coefficients with t in degre Celcius
c   ------------------------------------
      a1(11) = 3501.8
      a2(11) = -210.31
      a3(11) =    6.1851
      a4(11) =   -0.07513
c
      a1(12) = 3845.4
      a2(12) = -228.95
      a3(12) =    6.1908
      a4(12) =   -0.067430
c

      sc_cfc = a1(kn) + a2(kn) * t + a3(kn) *t*t  
     &         + a4(kn) *t*t*t
  
      RETURN 
      END 

C====================================================================

      _RL FUNCTION sol_cfc(pt,ps,kn)

c-------------------------------------------------------------------
c
c     CFC 11 and 12 Solubilities in seawater
c     ref: Warner & Weiss (1985) , Deep Sea Research, vol32
c
c     pt:       temperature (degre Celcius)
c     ps:       salinity    (o/oo)
c     kn:       11 = CFC-11, 12 = CFC-12
c     sol_cfc:  in mol/m3/pptv
c               1 pptv = 1 part per trillion = 10^-12 atm = 1 picoatm
c
c     J-C Dutay - LSCE
c-------------------------------------------------------------------

      _RL pt, ps,ta,d
      _RL a1 ( 11: 12), a2 ( 11: 12), a3 ( 11: 12), a4 ( 11: 12)
      _RL b1 ( 11: 12), b2 ( 11: 12), b3 ( 11: 12)

      INTEGER kn

cc
cc coefficient for solubility in  mol/l/atm
cc ----------------------------------------
c
c     for CFC 11
c     ----------
      a1 ( 11) = -229.9261
      a2 ( 11) =  319.6552
      a3 ( 11) =  119.4471
      a4 ( 11) =   -1.39165
      b1 ( 11) =   -0.142382
      b2 ( 11) =    0.091459
      b3 ( 11) =   -0.0157274
c    
c     for CFC/12
c     ----------
      a1 ( 12) = -218.0971
      a2 ( 12) =  298.9702
      a3 ( 12) =  113.8049
      a4 ( 12) =   -1.39165
      b1 ( 12) =   -0.143566
      b2 ( 12) =    0.091015
      b3 ( 12) =   -0.0153924
c

      ta       = ( pt + 273.16)* 0.01
      d    = ( b3 ( kn)* ta + b2 ( kn))* ta + b1 ( kn)
c
c
      sol_cfc 
     $    = exp ( a1 ( kn)
     $    +       a2 ( kn)/ ta 
     $    +       a3 ( kn)* log ( ta )
     $    +       a4 ( kn)* ta * ta  + ps* d )
c
c     conversion from mol/(l * atm) to mol/(m^3 * atm) 
c     ------------------------------------------------
      sol_cfc = 1000. * sol_cfc
c
c     conversion from mol/(m^3 * atm) to mol/(m3 * pptv) 
c     --------------------------------------------------
      sol_cfc = 1.0e-12 * sol_cfc

      END 
