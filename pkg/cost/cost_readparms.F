C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_readparms(
     I                           mythid
     &                         )

c     ==================================================================
c     SUBROUTINE cost_readparms
c     ==================================================================
c
c     o This routine initialises the package cost.
c
c     started: Ralf Giering 18-Jan-2001
c
c     ==================================================================
c     SUBROUTINE cost_readparms
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"

#include "cost.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer sststartdate1
      integer sststartdate2
      integer sssstartdate1
      integer sssstartdate2
      integer topexstartdate1
      integer topexstartdate2
      integer ersstartdate1
      integer ersstartdate2

c     == end of interface ==

c--   Read the namelist input.
      namelist /cost_nml/ 
     &                   data_errfile,
     &                   tbarfile, sbarfile, psbarfile,
     &                   ubarfile, vbarfile, 
     &                   topexstartdate1, topexstartdate2,
     &                   topexperiod, topexfile, topexmeanfile,
     &                   ersstartdate1, ersstartdate2,
     &                   ersperiod, ersfile,
     &                   ssh_errfile,
     &                   sststartdate1, sststartdate2, sstdatfile, 
     &                   sssstartdate1, sssstartdate2, sssdatfile, 
     &                   tdatfile, sdatfile,
     &                   ctdtfile, ctdsfile,
     &                   xbtfile, 
     &                   udriftfile, vdriftfile,
     &                   hflux_errfile, sflux_errfile,
     &                   tauu_errfile, tauv_errfile,
     &                   atemp_errfile, aqh_errfile,
     &                   uwind_errfile, vwind_errfile,
     &                   geoid_errfile, geoid_covariancefile,
     &                   mult_hflux, mult_sflux, mult_tauu, mult_tauv,
     &                   mult_atemp, mult_aqh, mult_uwind, mult_vwind,
     &                   mult_hmean, mult_h, mult_temp, mult_salt,
     &                   mult_sst, mult_sss, mult_atl,
     &                   mult_ctdt, mult_ctds, mult_xbt, mult_drift,
     &                   cost_iprec, cost_yftype

      _BEGIN_MASTER( myThid )

c--     Set default values.
        data_errfile          =    ' '
        tbarfile              =    ' '
        sbarfile              =    ' '
        psbarfile             =    ' '
        ubarfile              =    ' '
        vbarfile              =    ' '
        topexstartdate1       =      0
        topexstartdate2       =      0
        topexperiod           =      0. _d 0
        topexfile             =    ' '
        topexmeanfile         =    ' '
        ersstartdate1         =      0
        ersstartdate2         =      0
        ersperiod             =      0. _d 0
        ersfile               =    ' '
        ssh_errfile           =    ' '
        sststartdate1         =      0
        sststartdate2         =      0
        sstdatfile            =    ' '
        sssstartdate1         =      0
        sssstartdate2         =      0
        sssdatfile            =    ' '
        tdatfile              =    ' '
        sdatfile              =    ' '
        ctdtfile              =    ' '
        ctdsfile              =    ' '
        xbtfile               =    ' '
        udriftfile            =    ' '
        vdriftfile            =    ' '
        hflux_errfile         =    ' '
        sflux_errfile         =    ' '
        tauu_errfile          =    ' '
        tauv_errfile          =    ' '
        atemp_errfile         =    ' '
        aqh_errfile           =    ' '
        uwind_errfile         =    ' '
        vwind_errfile         =    ' '
        geoid_errfile         =    ' '
        geoid_covariancefile  =    ' '
        mult_hflux            =      0. _d 0
        mult_sflux            =      0. _d 0
        mult_tauu             =      0. _d 0
        mult_tauv             =      0. _d 0
        mult_atemp            =      0. _d 0
        mult_aqh              =      0. _d 0
        mult_uwind            =      0. _d 0
        mult_vwind            =      0. _d 0
        mult_hmean            =      0. _d 0
        mult_h                =      0. _d 0
        mult_temp             =      0. _d 0
        mult_salt             =      0. _d 0
        mult_sst              =      0. _d 0
        mult_sss              =      0. _d 0
        mult_atl              =      0. _d 0
        mult_ctdt             =      0. _d 0
        mult_ctds             =      0. _d 0
        mult_xbt              =      0. _d 0
        mult_drift            =      0. _d 0

c--     Check versions.

c--     Next, read the cost data file.
        call nml_filter( 'data.cost', scrunit1, myThid )
        if (scrunit1 .eq. 0) then
           stop 'cost_readparms: reading namelist failed'
        end if
        read(  scrunit1, nml = cost_nml )
        close( scrunit1 )

c--     Get the complete dates of the ...
c--     ... SST data.
        call cal_FullDate( sststartdate1,   sststartdate2,
     &                     sststartdate,    mythid )
c--     ... SSS data.
        call cal_FullDate( sssstartdate1,   sssstartdate2,
     &                     sssstartdate,    mythid )     
c--     ... T/P data.
        call cal_FullDate( topexstartdate1, topexstartdate2,
     &                     topexstartdate,  mythid )
c--     ... ERS data.
        call cal_FullDate( ersstartdate1,   ersstartdate2,
     &                     ersstartdate,    mythid )

      _END_MASTER( mythid )

      _BARRIER

      end
