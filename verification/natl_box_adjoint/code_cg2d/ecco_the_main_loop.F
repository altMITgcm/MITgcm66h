C $Header$

#include "CPP_OPTIONS.h"
#ifdef ALLOW_OBCS
# include "OBCS_OPTIONS.h"
#endif


      subroutine the_main_loop( myTime, myIter, mythid )

c     ==================================================================
c     SUBROUTINE the_main_loop
c     ==================================================================
c
c     o Run the ocean model and evaluate the specified cost function.
c
c     *the_main_loop* is the top-level routine for the Tangent Linear and
c     Adjoint Model Compiler (TAMC). For this purpose, the initialization
c     of the model was split into two parts. Those parameters that do
c     not depend on a specific model run are set in *initialise_fixed*,
c     whereas those that do depend on the specific realization are
c     initialized in *initialise_varia*. In order to do a so called
c     checkpointing during the adjoint calculation and to account for the
c     typical data involved in oceanographic applications a call tree
c     that is divided into yearly, monthly, daily, and step parts can
c     be used.
c
c     This routine is to be used in conjuction with the MITgcmuv release
c     checkpoint 24.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 14-Jul-1999
c
c              - The call to mapping was moved to initialise_varia,
c                since this routine has to be called before 
c                ini_predictor.
c
c              Christian Eckert eckert@mit.edu 11-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c              Patrick Heimbach heimbach@mit.edu 3-Jun-2000
c              - corrected computation of ikey_dynamics and
c                added computation of ikey_dynamics for the case
c                undef ALLOW_TAMC_CHECKPOINTING
c
c              Patrick Heimbach heimbach@mit.edu 6-Jun-2000
c              - corrected initialisation of comlev1 common blocks
c
c     ==================================================================
c     SUBROUTINE the_main_loop
c     ==================================================================

      implicit none

c     == global variables ==

#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "FFIELDS.h"
#include "GAD.h"

c**************************************
#ifdef ALLOW_AUTODIFF_TAMC

c These includes are needed for 
c AD-checkpointing. 
c They provide the fields to be stored.

# ifdef INCLUDE_EXTERNAL_FORCING_PACKAGE
#  include "exf_fields.h"
#  include "exf_clim_fields.h"
#  ifdef ALLOW_BULKFORMULAE
#   include "exf_constants.h"
#  endif
# endif
# ifdef ALLOW_PASSIVE_TRACER
#  include "TR1.h"
# endif
# ifdef ALLOW_NONHYDROSTATIC
#  include "CG3D.h"
# endif
# ifdef EXACT_CONSERV
#  include "SURFACE.h"
# endif
# ifdef ALLOW_OBCS
#  include "OBCS.h"
# endif

# include "tamc.h"
# include "ctrl.h"
# include "ctrl_dummy.h"
# include "cost.h"

#endif /* ALLOW_AUTODIFF_TAMC */
c**************************************

c     == routine arguments ==
c     note: under the multi-threaded model myiter and 
c           mytime are local variables passed around as routine 
c           arguments. Although this is fiddly it saves the need to 
c           impose additional synchronisation points when they are 
c           updated.
c     myiter - iteration counter for this thread
c     mytime - time counter for this thread
c     mythid - thread number for this instance of the routine.
      integer mythid 
      integer myiter
      _RL     mytime 

c     == local variables ==

      integer bi,bj
      integer iloop
      integer mydate(4)
      logical forceOutput
#ifdef ALLOW_SNAPSHOTS
      character yprefix*3
#endif

#ifdef ALLOW_TAMC_CHECKPOINTING
      integer ilev_1
      integer ilev_2
      integer ilev_3
      integer max_lev2
      integer max_lev3
#endif

c--   == end of interface ==

#ifdef ALLOW_AUTODIFF_TAMC
c--   Initialize storage for the outermost loop.
CADJ  INIT tapelev3 = USER
c--   Some more initialisations to please TAMC
CADJ INIT tapelev_ini_bibj_k   = USER
#ifdef ALLOW_TAMC_CHECKPOINTING
       nIter0 = INT( startTime/deltaTClock )
       ikey_dynamics = 1
#endif
#endif

      myTime = startTime
      myIter = nIter0

      call timer_start('ECCO SPIN-UP', mythid)

c--   Get the current date.
      call cal_timestamp( myiter, mytime, mydate, mythid )

C--   Set initial conditions (variable arrays)
      CALL TIMER_START('INITIALISE_VARIA    [THE_MAIN_LOOP]', mythid)
      CALL INITIALISE_VARIA( mythid )
      CALL TIMER_STOP ('INITIALISE_VARIA    [THE_MAIN_LOOP]', mythid)

#ifndef ALLOW_AUTODIFF_TAMC
c--   Dump for start state.
      CALL TIMER_START('WRITE_STATE         [THE_MAIN_LOOP]', mythid)
      CALL WRITE_STATE( mytime, myiter, mythid )
      CALL TIMER_STOP ('WRITE_STATE         [THE_MAIN_LOOP]', mythid)
#endif

#ifndef EXCLUDE_MONITOR
C--   Check status of solution (statistics, cfl, etc...)
      CALL TIMER_START('MONITOR             [THE_MAIN_LOOP]', mythid)
      CALL MONITOR( myIter, myTime, myThid )
      CALL TIMER_STOP ('MONITOR             [THE_MAIN_LOOP]', mythid)
#endif /* EXCLUDE_MONITOR */


#ifdef ALLOW_COST
c--   Compute the cost function contribution of the boundary forcing,
c--   i.e. heat flux, salt flux, zonal and meridional wind stress.
      call timer_start('COST_FORCING       [ECCO SPIN-UP]', mythid)
      call cost_Forcing( myiter, mytime, mythid )
      call timer_stop ('COST_FORCING       [ECCO SPIN-UP]', mythid)
#endif

      call timer_stop ('ECCO SPIN-UP', mythid)
      _BARRIER

c--   Do the model integration.
      call timer_start('ECCO MAIN LOOP',mythid)

c     >>>>>>>>>>>>>>>>>>>>>>>>>>>   LOOP   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>>>>>>>>>  STARTS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<

#ifdef ALLOW_AUTODIFF_TAMC
#ifdef ALLOW_TAMC_CHECKPOINTING
c--   Implement a three level checkpointing. For a two level
c--   checkpointing delete the middle loop; for n levels (n > 3)
c--   insert more loops.

c--   Check the choice of the checkpointing parameters in relation
c--   to nTimeSteps: (nchklev_1*nchklev_2*nchklev_3 .ge. nTimeSteps)
      if (nchklev_1*nchklev_2*nchklev_3 .lt. nTimeSteps) then
        print*
        print*, ' the_main_loop: TAMC checkpointing parameters'
        print*, '            nchklev_1*nchklev_2*nchklev_3 = ',
     &       nchklev_1*nchklev_2*nchklev_3
        print*, '            are not consistent with nTimeSteps = ',
     &       nTimeSteps
        stop    ' ... stopped in the_main_loop.'
      endif
      max_lev3=nTimeSteps/(nchklev_1*nchklev_2)+1
      max_lev2=nTimeSteps/nchklev_1+1

c**************************************
#ifdef ALLOW_DIVIDED_ADJOINT
CADJ loop = divided
#endif
c**************************************

      do ilev_3 = 1,nchklev_3
         if(ilev_3.le.max_lev3) then
c**************************************
#include "checkpoint_lev3_directives.h"
c**************************************

c--     Initialise storage for the middle loop.
CADJ    INIT tapelev2 = USER

        do ilev_2 = 1,nchklev_2
         if(ilev_2.le.max_lev2) then
c**************************************
#include "checkpoint_lev2_directives.h"
c**************************************


c--       Initialize storage for the innermost loop.
c--       Always check common block sizes for the checkpointing!
CADJ INIT comlev1        = COMMON,nchklev_1
CADJ INIT comlev1_bibj   = COMMON,nchklev_1*nsx*nsy*nthreads_chkpt
CADJ INIT comlev1_bibj_k = COMMON,nchklev_1*nsx*nsy*nr*nthreads_chkpt
CADJ INIT comlev1_kpp    = COMMON,nchklev_1*nsx*nsy
CADJ INIT comlev1_exf    = COMMON,nchklev_1*nthreads_chkpt
#ifndef DISABLE_MULTIDIM_ADVECTION
CADJ INIT comlev1_bibj_pass
CADJ &    = COMMON,nchklev_1*nsx*nsy*nr*nthreads_chkpt*maxpass
#endif
#ifdef ALLOW_BULKFORMULAE
CADJ INIT comlev1_exf_1
CADJ &     = COMMON,nchklev_1*snx*nsx*sny*nsy*nthreads_chkpt
CADJ INIT comlev1_exf_2
CADJ &     = COMMON,niter_bulk*nchklev_1*snx*nsx*sny*nsy*nthreads_chkpt
#endif
#ifdef ALLOW_AUTODIFF_CG2D
CADJ INIT comlev1_cg2d_loop
CADJ &     = COMMON,nchklev_1*nthreads_chkpt
cphCADJ INIT comlev1_cg2d_loop
cphCADJ &     = COMMON,nchklev_1*nthreads_chkpt*numItersMax
CADJ INIT comlev1_cg2d
CADJ &     = COMMON,nchklev_1*nthreads_chkpt
#endif

          do ilev_1 = 1,nchklev_1

c--         The if-statement below introduces a some flexibility in the
c--         choice of the 3-tupel ( nchklev_1, nchklev_2, nchklev_3 ).
c--
c--         Requirement: nchklev_1*nchklev_2*nchklev_3 .ge. nTimeSteps .

            iloop = (ilev_3 - 1)*nchklev_2*nchklev_1 +
     &              (ilev_2 - 1)*nchklev_1           + ilev_1

            if ( iloop .le. nTimeSteps ) then

#else /* ALLOW_TAMC_CHECKPOINTING  undefined */
c--   Initialise storage for the reference trajectory without TAMC check-
c--   pointing.
CADJ INIT history        = USER
CADJ INIT comlev1_bibj   = COMMON,nchklev_0*nsx*nsy*nthreads_chkpt
CADJ INIT comlev1_bibj_k = COMMON,nchklev_0*nsx*nsy*nr*nthreads_chkpt
CADJ INIT comlev1_kpp    = COMMON,nchklev_0*nsx*nsy

c--   Check the choice of the checkpointing parameters in relation
c--   to nTimeSteps: (nchklev_0 .ge. nTimeSteps)
      if (nchklev_0 .lt. nTimeSteps) then
        print*
        print*, ' the_main_loop: ',
     &       'TAMC checkpointing parameter nchklev_0 = ', 
     &       nchklev_0
        print*, '            is not consistent with nTimeSteps = ', 
     &       nTimeSteps
        stop    ' ... stopped in the_main_loop.'
      endif

      do iloop = 1, nTimeSteps

#endif /* ALLOW_TAMC_CHECKPOINTING */

#else /* ALLOW_AUTODIFF_TAMC  undefined */
c--   Start the main loop of ecco_Objfunc. Automatic differentiation is
c--   NOT enabled.
      do iloop = 1, nTimeSteps
#endif /* ALLOW_AUTODIFF_TAMC */

#ifdef ALLOW_TAMC_CHECKPOINTING
        nIter0 = INT( startTime/deltaTClock )
        ikey_dynamics = ilev_1
#endif

c--     Set the model iteration counter and the model time.
        myiter = nIter0 + (iloop-1)
        mytime = startTime + float(iloop-1)*deltaTclock

#ifdef ALLOW_COST
c--     Accumulate time averages of temperature, salinity, and SSH.
        call timer_start('COST_AVERAGESFIELDS   [ECCO MAIN]', mythid)
        call cost_AveragesFields( mytime, myiter, mythid )
        call timer_stop ('COST_AVERAGESFIELDS   [ECCO MAIN]', mythid)
#ifdef ALLOW_COST_ATLANTIC
c--     Compute meridional heat transport 
        call timer_start('cost_atlantic         [ECCO MAIN]', mythid)
        call cost_atlantic(  mytime, myiter,mythid )
        call timer_stop ('cost_atlantic         [ECCO MAIN]', mythid)
#endif
#endif

#ifdef EXACT_CONSERV
      IF (exactConserv) THEN
C--   Update etaH(n+1) :
        DO bj=myByLo(myThid),myByHi(myThid)
         DO bi=myBxLo(myThid),myBxHi(myThid)
           CALL CALC_EXACT_ETA( .FALSE., bi,bj, uVel,vVel,
     I                          startTime, nIter0, myThid )
         ENDDO
        ENDDO
        IF (implicDiv2Dflow .NE. 1. _d 0 )
     &     _EXCH_XY_R8(etaH, myThid )
      ENDIF
#endif /* EXACT_CONSERV */ 

#ifdef NONLIN_FRSURF
C--   compute the future surface level thickness
C      according to etaH(n+1) 
        IF ( nonlinFreeSurf.GT.0) THEN
          CALL CALC_SURF_DR(etaH, myTime, myIter, myThid )
        ENDIF
#endif /* NONLIN_FRSURF */

c--     Get forcing fluxes of heat, salt, zonal and meridional
c--     momentum at the ocean surface and map them onto the
c--     ocean model.
#ifdef ALLOW_AUTODIFF_TAMC
c**************************************
#include "checkpoint_lev1_directives.h"
c**************************************
#endif
        call timer_start('EXF_GETFORCING        [ECCO MAIN]', mythid)
        call exf_GetForcing( mytime, myiter, mythid )
        _BARRIER
        call timer_stop ('EXF_GETFORCING        [ECCO MAIN]', mythid)

#ifdef ALLOW_AUTODIFF_TAMC
C       Include call to a dummy routine. Its adjoint will be 
C       called at the proper place in the adjoint code.
C       The adjoint routine will print out adjoint values 
C       if requested. The location of the call is important, 
C       it has to be after the adjoint of the exchanges 
C       (DO_GTERM_BLOCKING_EXCHANGES).
        myiter = niter0 + iloop
        mytime = starttime + float(iloop)*deltaTClock
        CALL DUMMY_IN_STEPPING( myTime, myIter, myThid )
        CALL DO_FIELDS_BLOCKING_EXCHANGES( myThid )
        myiter = nIter0 + (iloop-1)
        mytime = startTime + float(iloop-1)*deltaTclock
#endif

cph(
#ifdef ALLOW_SNAPSHOTS
        yprefix = 'kf_'
        call ecco_check_exp( mythid, myiter, mytime, yprefix )
#endif
cph)

C--     Step forward fields and calculate time tendency terms.
        CALL TIMER_START('THERMODYNAMICS      [THE_MAIN_LOOP]',mythid)
        CALL THERMODYNAMICS( myTime, myIter, myThid )
        CALL TIMER_STOP ('THERMODYNAMICS      [THE_MAIN_LOOP]',mythid)

C--     Step forward fields and calculate time tendency terms.
        IF ( momStepping ) THEN
        CALL TIMER_START('DYNAMICS            [THE_MAIN_LOOP]',mythid)
        CALL DYNAMICS( myTime, myIter, myThid )
        CALL TIMER_STOP ('DYNAMICS            [THE_MAIN_LOOP]',mythid)
        ENDIF

#ifndef ALLOW_AUTODIFF_TAMC
#ifdef ALLOW_NONHYDROSTATIC
C--   Step forward W field in N-H algorithm
        IF ( nonHydrostatic ) THEN
          CALL TIMER_START('CALC_GW          [THE_MAIN_LOOP]',myThid)
          CALL CALC_GW(myThid)
          CALL TIMER_STOP ('CALC_GW          [THE_MAIN_LOOP]',myThid)
        ENDIF
#endif
#endif /* ALLOW_AUTODIFF_TAMC */

#ifdef NONLIN_FRSURF
C--   update hfacC,W,S and recip_hFac according to etaH(n+1) :
      IF ( momStepping ) THEN
      IF ( nonlinFreeSurf.GT.0) THEN
        CALL UPDATE_SURF_DR( myTime, myIter, myThid )
      ENDIF
C-    update also CG2D matrix (and preconditioner)
      IF ( nonlinFreeSurf.GT.2) THEN
        CALL UPDATE_CG2D( myTime, myIter, myThid )
      ENDIF
      ENDIF
#endif

#ifndef ALLOW_AUTODIFF_TAMC
#ifdef ALLOW_SHAP_FILT
CC--   Step forward all tiles, filter and exchange.
C      CALL TIMER_START('SHAP_FILT           [THE_MAIN_LOOP]',myThid)
C      CALL SHAP_FILT_APPLY( 
C     I                     gUnm1, gVnm1, gTnm1, gSnm1,
C     I                     myTime, myIter, myThid )
C      IF (implicDiv2Dflow.LT.1.) THEN
CC--   Explicit+Implicit part of the Barotropic Flow Divergence
CC      => Filtering of uVel,vVel is necessary
C         CALL SHAP_FILT_UV( uVel, vVel, myTime, myThid )
C      ENDIF
C      CALL TIMER_STOP ('SHAP_FILT           [THE_MAIN_LOOP]',myThid)
#endif
#ifdef ALLOW_ZONAL_FILT
C      IF (zonal_filt_lat.LT.90.) THEN 
C        CALL TIMER_START('ZONAL_FILT_APPLY    [THE_MAIN_LOOP]',myThid)
C        CALL ZONAL_FILT_APPLY(
C     U           gUnm1, gVnm1, gTnm1, gSnm1,
C     I           myThid )
C        CALL TIMER_STOP ('ZONAL_FILT_APPLY    [THE_MAIN_LOOP]',myThid)
C      ENDIF
#endif
#endif /* ALLOW_AUTODIFF_TAMC */

C--   Solve elliptic equation(s).
C     Two-dimensional only for conventional hydrostatic or 
C     three-dimensional for non-hydrostatic and/or IGW scheme.
      CALL TIMER_START('SOLVE_FOR_PRESSURE  [THE_MAIN_LOOP]',myThid)
      CALL SOLVE_FOR_PRESSURE( myThid )
      CALL TIMER_STOP ('SOLVE_FOR_PRESSURE  [THE_MAIN_LOOP]',myThid)

C--   Correct divergence in flow field and cycle time-stepping
C     arrays (for all fields) ; update time-counter
      myiter = niter0 + iloop
      mytime = starttime + float(iloop)*deltaTClock
      CALL TIMER_START('THE_CORRECTION_STEP [THE_MAIN_LOOP]',myThid)
      CALL THE_CORRECTION_STEP(myTime, myIter, myThid)
      CALL TIMER_STOP ('THE_CORRECTION_STEP [THE_MAIN_LOOP]',myThid)

C--   Do "blocking" sends and receives for tendency "overlap" terms
c     CALL TIMER_START('BLOCKING_EXCHANGES  [THE_MAIN_LOOP]',myThid)
c     CALL DO_GTERM_BLOCKING_EXCHANGES( myThid )
c     CALL TIMER_STOP ('BLOCKING_EXCHANGES  [THE_MAIN_LOOP]',myThid)

C--   Do "blocking" sends and receives for field "overlap" terms
      CALL TIMER_START('BLOCKING_EXCHANGES  [THE_MAIN_LOOP]',myThid)
      CALL DO_FIELDS_BLOCKING_EXCHANGES( myThid )
      CALL TIMER_STOP ('BLOCKING_EXCHANGES  [THE_MAIN_LOOP]',myThid)

#ifdef ALLOW_FLT
C--   Calculate float trajectories
      IF (useFLT) THEN
        CALL TIMER_START('FLOATS            [THE_MAIN_LOOP]',myThid)
        CALL FLT_MAIN(myIter,myTime, myThid)
        CALL TIMER_STOP ('FLOATS            [THE_MAIN_LOOP]',myThid)
      ENDIF
#endif

#ifndef EXCLUDE_MONITOR
C--   Check status of solution (statistics, cfl, etc...)
      CALL MONITOR( myIter, myTime, myThid )
#endif /* EXCLUDE_MONITOR */

#ifndef ALLOW_AUTODIFF_TAMC
C--   Do IO if needed.
      CALL TIMER_START('DO_THE_MODEL_IO     [THE_MAIN_LOOP]',myThid)
      CALL DO_THE_MODEL_IO( myTime, myIter, myThid )
      CALL TIMER_STOP ('DO_THE_MODEL_IO     [THE_MAIN_LOOP]',myThid)

C--   Save state for restarts
C     Note:    (jmc: is it still the case after ckp35 ?)
C     =====
C     Because of the ordering of the timestepping code and
C     tendency term code at end of loop model arrays hold
C     U,V,T,S  at "time-level" N but gu, gv, gs, gt, guNM1,... 
C     at "time-level" N+1/2 (guNM1 at "time-level" N+1/2 is 
C     gu at "time-level" N-1/2) and etaN at "time-level" N+1/2.
C      where N = I+timeLevBase-1
C     Thus a checkpoint contains U.0000000000, GU.0000000001 and 
C     etaN.0000000001 in the indexing scheme used for the model 
C     "state" files. This example is referred to as a checkpoint 
C     at time level 1 
      CALL TIMER_START('WRITE_CHECKPOINT    [THE_MAIN_LOOP]',myThid)
      CALL WRITE_CHECKPOINT(
     &        .FALSE., myTime, myIter, myThid )
      CALL TIMER_STOP ('WRITE_CHECKPOINT    [THE_MAIN_LOOP]',myThid)

#endif /* ALLOW_AUTODIFF_TAMC */

              myiter = niter0 + iloop
              mytime = starttime + float(iloop)*deltaTClock

c             Calculate current date.
              call cal_TimeStamp( myiter, mytime, mydate, mythid )

#ifdef ALLOW_AUTODIFF_TAMC
#ifdef ALLOW_TAMC_CHECKPOINTING
            endif
          enddo
          endif
        enddo
        endif
      enddo
#else
      enddo
#endif

#else
      enddo
#endif

      _BARRIER
      call timer_stop ('ECCO MAIN LOOP', mythid)

      call timer_start('ECCO SPIN-DOWN', mythid)

#ifdef ALLOW_COST

c--   Accumulate time averages of temperature, salinity, and SSH.
      call timer_start('cost_AveragesFields [ECCO SPIN-DOWN]', mythid)
      call cost_AveragesFields( mytime, myiter, mythid )
      call timer_stop ('cost_AveragesFields [ECCO SPIN-DOWN]', mythid)
#ifdef ALLOW_COST_ATLANTIC
c--   Compute meridional heat transport 
      call timer_start('cost_atlantic      [ECCO SPIN-DOWN]', mythid)
      call cost_atlantic(  mytime, myiter,mythid )
      call timer_stop ('cost_atlantic      [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of Temperature and Salinity.
      call timer_start('COST_HYD           [ECCO SPIN-DOWN]', mythid)
      call cost_Hyd( myiter, mytime, mythid )
      call timer_stop ('COST_HYD           [ECCO SPIN-DOWN]', mythid)

#ifdef ALLOW_OBCS_COST_CONTRIBUTION
      call timer_start('cost_obcs          [ECCO SPIN-DOWN]', mythid)
      call cost_obcs( myiter, mytime, mythid )
      call timer_stop ('cost_obcs          [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of SSH.
#ifdef ALLOW_SSH_COST_CONTRIBUTION
      call timer_start('cost_SSH           [ECCO SPIN-DOWN]', mythid)
      call cost_SSH( myiter, mytime, mythid )
      call timer_stop ('cost_SSH           [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of SSS. 
#ifdef ALLOW_SST_COST_CONTRIBUTION 
      call timer_start('cost_SST           [ECCO SPIN-DOWN]', mythid)
      call cost_SST( myiter, mytime, mythid )
      call timer_stop ('cost_SST           [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of SSS.
#ifdef ALLOW_SSS_COST_CONTRIBUTION
      call timer_start('cost_SSS           [ECCO SPIN-DOWN]', mythid)
      call cost_SSS( myiter, mytime, mythid )
      call timer_stop ('cost_SSS           [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of drifter's velocities.
#ifdef ALLOW_DRIFTER_COST_CONTRIBUTION
      call timer_start('cost_Drifter         [ECCO SPIN-DOWN]', mythid)
      call cost_drifter( myiter, mytime, mythid )
      call timer_stop ('cost_Drifter         [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of wind stress observations.
#ifdef ALLOW_SCAT_COST_CONTRIBUTION
      call timer_start('cost_scat            [ECCO SPIN-DOWN]', mythid) 
      call cost_scat( myiter, mytime, mythid )
      call timer_stop ('cost_scat            [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of wind stress observations.  
#ifdef ALLOW_MEAN_HFLUX_COST_CONTRIBUTION
      call timer_start('cost_mean_heatflux   [ECCO SPIN-DOWN]', mythid)
      call cost_mean_heatflux( myiter, mytime, mythid )
      call timer_stop ('cost_mean_heatflux   [ECCO SPIN-DOWN]', mythid)
#endif

c--   Compute cost function contribution of wind stress observations.
#ifdef ALLOW_MEAN_SFLUX_COST_CONTRIBUTION
      call timer_start('cost_mean_saltflux   [ECCO SPIN-DOWN]', mythid)
      call cost_mean_saltflux( myiter, mytime, mythid )
      call timer_stop ('cost_mean_saltflux   [ECCO SPIN-DOWN]', mythid)        
#endif

c--   Compute cost function contribution of drift between the first 
c     and the last year.
#ifdef ALLOW_DRIFT_COST_CONTRIBUTION
      call timer_start('cost_Drift         [ECCO SPIN-DOWN]', mythid)
      call cost_drift( myiter, mytime, mythid )
      call timer_stop ('cost_Drift         [ECCO SPIN-DOWN]', mythid)
#endif
#ifdef ALLOW_DRIFTW_COST_CONTRIBUTION
      call timer_start('cost_Driftw        [ECCO SPIN-DOWN]', mythid)
      call cost_driftw( myiter, mytime, mythid )
      call timer_stop ('cost_Driftw        [ECCO SPIN-DOWN]', mythid)
#endif

      _BARRIER

c--   Sum all cost function contributions.
      call timer_start('COST_FINAL         [ECCO SPIN-DOWN]', mythid)
      call cost_Final( mythid )
      call timer_stop ('COST_FINAL         [ECCO SPIN-DOWN]', mythid)

c--   Finalize the average fields used for the cost function
c--   evaluation.
      call timer_start('COST_AVERAGESFINAL [ECCO SPIN-DOWN]', mythid)
      call cost_AveragesFinal( mythid )
      call timer_stop ('COST_AVERAGESFINAL [ECCO SPIN-DOWN]', mythid)

#endif /* ALLOW_COST */

      call timer_stop ('ECCO SPIN-DOWN', mythid)

      return
      end

