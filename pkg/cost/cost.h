
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================
c
c     o Header for averaged temperature, salinity, and surface pressure
c       fields and counters associated with the averaging.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu  01-Mar-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================

c     Averaging counters:
c     ===================
c
c     sum1day - counter for the daily averaging
c     sum1mon - counter for the monthly averaging
c     dayrec  - number of averaged surface pressure records.
c     monrec  - number of averaged theta and salinity records.

      common /average_i/ 
     &                   sum1day,sum1mon,
     &                   dayrec,monrec
      integer sum1day
      integer sum1mon
      integer dayrec
      integer monrec


c     Averaged Fields:
c     ================
c
c     tbar  - contains the averaged temperature field after the call
c             to subroutine POST_MONTHLY. Before, it accumulates the
c             intantaneous temperatures.
c     sbar  - contains the averaged salinity field after the call
c             to subroutine POST_MONTHLY. Before, it accumulates the
c             intantaneous salinities.
c     psbar - contains the averaged surface pressure field after the call
c             to subroutine POST_DAILY. Before, it accumulates the
c             intantaneous surface pressure field.
c     ubar  - contains the averaged zonal velocity component for the 
c             whole integration period. Before, it accumulates the
c             intantaneous field.

      common /averages_r/ 
     &                    tbar,
     &                    sbar,
     &                    psbar,
     &                    ubar,
     &                    vbar

#if (defined (ALLOW_THETA_COST_CONTRIBUTION) || \
     defined (ALLOW_SST_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDT_COST_CONTRIBUTION) || \
     defined (ALLOW_XBT_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
      _RL tbar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
      _RL tbar
#endif

#if (defined (ALLOW_SALT_COST_CONTRIBUTION) || \
     defined (ALLOW_SSS_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDS_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
      _RL sbar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
      _RL sbar
#endif

#ifdef ALLOW_SSH_COST_CONTRIBUTION
      _RL psbar  (1-olx:snx+olx,1-oly:sny+oly,  nsx,nsy)
#else
      _RL psbar
#endif

#if (defined (ALLOW_DRIFTER_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
      _RL ubar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL vbar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
      _RL ubar
      _RL vbar
#endif



      common /averages_c/ 
     &                    tbarfile,
     &                    sbarfile,
     &                    psbarfile,
     &                    ubarfile,
     &                    vbarfile
      character*(MAX_LEN_FNAM) tbarfile
      character*(MAX_LEN_FNAM) sbarfile
      character*(MAX_LEN_FNAM) psbarfile
      character*(MAX_LEN_FNAM) ubarfile
      character*(MAX_LEN_FNAM) vbarfile

c     file precision and field type

      common /prec_type_cost/ 
     &                        cost_iprec,
     &                        cost_yftype

      integer cost_iprec
      character*(2) cost_yftype

c     ==================================================================
c     END OF HEADER AVERAGES
c     ==================================================================



c     ==================================================================
c     HEADER COST
c     ==================================================================
c
c     o Header for model-data comparison.
c
c     The individual cost function contributions are multiplied by
c     factors mult_"var" which allow to switch off these contributions
c     without removing them in the adjoint code. This is useful for
c     doing tests with the adjoint and perhaps useful in assimilation
c     experiments where individual contributions are successively
c     switched on. For future applications it would be better to place
c     the initialisation of the multipliers somewhere else, for example
c     in a namelist, which is read in at the start of the model.
c
c     started: Christian Eckert eckert@mit.edu  24-Feb-1999
c
c     changed: Christian Eckert eckert@mit.edu
c
c
c     ==================================================================
c     HEADER COST
c     ==================================================================


c     The cost function, its contributions, and multipliers:
c     ======================================================
c
c     fc         - Final cost function.
c     objf_hflux    - Heat flux contribution.
c     objf_sflux    - Salt flux contribution.
c     objf_tauu  - Zonal wind stress contribution.
c     objf_tauv  - Meridional wind stress contribution.
c     objf_hmean - Mean sea surface height contribution.
c     objf_h     - Residual sea surface height contribution.
c     objf_temp  - Temperature contribution.
c     objf_salt  - Salinity contribution.
c     objf_sst   - Sea surface temperature contribution.
c     objf_sss   - Sea surface salinity contribution.
c     objf_atl   - Meridional heat transport in the N-Atlantic
c     objf_ctdt  - Temperature measurements from Woce CTD 
c     objf_ctds  - Salinity measurements from Woce CTD 
c     objf_xbt   - XBT temperature data
c
c     mult_"var" - multipliers for the individual cost
c                  function contributions.

      common /cost_r/
     &                fc,
     &                objf_hflux,
     &                objf_sflux,
     &                objf_tauu,
     &                objf_tauv,
     &                objf_hmean,
     &                objf_h,
     &                objf_temp,
     &                objf_salt,
     &                objf_sst,
     &                objf_sss,
     &                objf_atl,
     &                objf_ctdt,
     &                objf_ctds,
     &                objf_xbt,
     &                objf_drift,
     &                objf_atemp,
     &                objf_aqh,
     &                objf_uwind,
     &                objf_vwind,
     &                objf_obcsn,
     &                objf_obcss,
     &                objf_obcsw,
     &                objf_obcse
      _RL  fc
      _RL  objf_hflux(nsx,nsy)
      _RL  objf_sflux(nsx,nsy)
      _RL  objf_tauu (nsx,nsy)
      _RL  objf_tauv (nsx,nsy)
      _RL  objf_hmean
      _RL  objf_h    (nsx,nsy)
      _RL  objf_temp (nsx,nsy)
      _RL  objf_salt (nsx,nsy)
      _RL  objf_sst  (nsx,nsy)
      _RL  objf_sss  (nsx,nsy) 
      _RL  objf_atl  (nsx,nsy)
      _RL  objf_ctdt (nsx,nsy)
      _RL  objf_ctds (nsx,nsy)
      _RL  objf_xbt  (nsx,nsy)
      _RL  objf_drift(nsx,nsy)
      _RL  objf_atemp(nsx,nsy)
      _RL  objf_aqh  (nsx,nsy)
      _RL  objf_uwind(nsx,nsy)
      _RL  objf_vwind(nsx,nsy)
      _RL  objf_obcsn(nsx,nsy)
      _RL  objf_obcss(nsx,nsy)
      _RL  objf_obcsw(nsx,nsy)
      _RL  objf_obcse(nsx,nsy)

      common /cost_aux_r/
     &                    mult_hflux,
     &                    mult_sflux,
     &                    mult_tauu,
     &                    mult_tauv,
     &                    mult_hmean,
     &                    mult_h,
     &                    mult_temp,
     &                    mult_salt,
     &                    mult_sst,
     &                    mult_sss,
     &                    mult_atl,
     &                    mult_ctdt,
     &                    mult_ctds,
     &                    mult_xbt,
     &                    mult_drift,
     &                    mult_atemp,
     &                    mult_aqh,
     &                    mult_uwind,
     &                    mult_vwind,
     &                    mult_obcsn,
     &                    mult_obcss,
     &                    mult_obcsw,
     &                    mult_obcse
      _RL  mult_hflux
      _RL  mult_sflux
      _RL  mult_tauu
      _RL  mult_tauv
      _RL  mult_hmean
      _RL  mult_h
      _RL  mult_temp
      _RL  mult_salt
      _RL  mult_sst
      _RL  mult_sss
      _RL  mult_atl
      _RL  mult_ctdt
      _RL  mult_ctds
      _RL  mult_xbt
      _RL  mult_drift
      _RL  mult_atemp
      _RL  mult_aqh
      _RL  mult_uwind
      _RL  mult_vwind
      _RL  mult_obcsn
      _RL  mult_obcss
      _RL  mult_obcsw
      _RL  mult_obcse


c     Record counters relevant for the cost function evaluation.
c     ==========================================================
c
c     nmonsrec - number of monthly records that will be generated by
c                the current model integration.
c     ndaysrec - number of  daily  records that will be generated by
c                the current model integration.

      common /cost_i/
     &                nmonsrec,
     &                ndaysrec
      integer nmonsrec
      integer ndaysrec


c     Data files for the weights used in the cost function:
c     =====================================================
c
c     hflux_errfile         - heat flux error.
c     sflux_errfile         - salt flux error.
c     tauu_errfile          - zonal wind stress error.
c     tauv_errfile          - meridional wind stress error.
c     data_errfile          - weights for theta, salt, and SST
c     geoid_errfile         - geoid error.
c     geoid_covariancefile  - geoid error covariance.
c     ssh_errfile           - sea surface height error.
c     ctdt_errfile          - CTD temperature error.
c     ctds_errfile          - CTD salinity error.
c     drift_errfile         - drifter error.

      common /cost_c/ 
     &                hflux_errfile,
     &                sflux_errfile,
     &                tauu_errfile,
     &                tauv_errfile,
     &                data_errfile,
     &                geoid_errfile,
     &                geoid_covariancefile,
     &                ssh_errfile,
     &                ctdt_errfile,
     &                ctds_errfile, 
     &                drift_errfile,
     &                atemp_errfile,
     &                aqh_errfile,
     &                uwind_errfile,
     &                vwind_errfile
      character*(MAX_LEN_FNAM) hflux_errfile
      character*(MAX_LEN_FNAM) sflux_errfile
      character*(MAX_LEN_FNAM) tauu_errfile
      character*(MAX_LEN_FNAM) tauv_errfile
      character*(MAX_LEN_FNAM) data_errfile
      character*(MAX_LEN_FNAM) geoid_errfile
      character*(MAX_LEN_FNAM) geoid_covariancefile
      character*(MAX_LEN_FNAM) ssh_errfile
      character*(MAX_LEN_FNAM) ctdt_errfile 
      character*(MAX_LEN_FNAM) ctds_errfile 
      character*(MAX_LEN_FNAM) drift_errfile
      character*(MAX_LEN_FNAM) atemp_errfile
      character*(MAX_LEN_FNAM) aqh_errfile
      character*(MAX_LEN_FNAM) uwind_errfile
      character*(MAX_LEN_FNAM) vwind_errfile


c     Arrays where the weights are stored:
c     ====================================
c
c     cosphi     - cosine of latitude.
c     whflux        - weight for heat flux.
c     wsflux        - weight for salt flux.
c     wtauu        - weight for zonal wind stress.
c     wtauu        - weight for meridional wind stress.
c     wtheta         - weight for temperature.
c     wsst       - weight for sea surface temperature.
c     wsss       - weight for sea surface salinity.
c     wsalt         - weight for salinity.
c     wtp        - weight for TOPEX/POSEIDON data.
c     wers       - weight for ERS data.
c     wp         - weight for geoid.
c     wctdt      - weight for CTD temperature.
c     wctds      - weight for CTD salinity.
c     wudrift    - weight for mean zonal velocity from drifters.
c     wvdrift    - weight for mean meridional velocity from drifters.
      common /cost_weights_r/ 
     &                      frame,
     &                      cosphi,
     &                      whflux,wsflux,wtauu,wtauv,
     &                      watemp,waqh,wuwind,wvwind,
     &                      wtheta,wsst,wsss,
     &                      wsalt,
     &                      wtp,wers,
     &                      wp,
     &                      wctdt,wctds,
     &                      wudrift,wvdrift
      _RL frame   (1-olx:snx+olx,1-oly:sny+oly           )
      _RL cosphi  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL whflux  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wsflux  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtauu   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtauv   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL watemp  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL waqh    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wuwind  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wvwind  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtheta  (                            nr,nsx,nsy)
      _RL wsalt   (                            nr,nsx,nsy)
      _RL wsst    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wsss    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtp     (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wers    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wp      (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wctdt   (                            nr,nsx,nsy)
      _RL wctds   (                            nr,nsx,nsy)
      _RL wudrift (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wvdrift (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)

#ifdef ALLOW_OBCSN_COST_CONTRIBUTION
      common /cost_weights_obcsn/ 
     &                      wobcsn
      _RL wobcsn  (                      nr,nobcs)
#endif
#ifdef ALLOW_OBCSS_COST_CONTRIBUTION
      common /cost_weights_obcss/ 
     &                      wobcss
      _RL wobcss  (                      nr,nobcs)
#endif
#ifdef ALLOW_OBCSW_COST_CONTRIBUTION
      common /cost_weights_obcsw/ 
     &                      wobcsw
      _RL wobcsw  (                      nr,nobcs)
#endif
#ifdef ALLOW_OBCSE_COST_CONTRIBUTION
      common /cost_weights_obcse/ 
     &                      wobcse
      _RL wobcse  (                      nr,nobcs)
#endif


c     Arrays that contain observations for the model-data comparison:
c     ===============================================================
c
c     tdat       - reference temperature data.
c     sstdat     - reference sea surface temperature data.
c     sstmask    - mask for reference sea surface temperature data.
c     sdat       - reference salinity data.
c     tpmean     - reference mean sea surface height data.
c     tpmeanmask - mask for reference mean sea surface height data.
c     tpobs      - TOPEX/POSEIDON data.
c     tpmask     - mask for TOPEX/POSEIDON data.
c     ersobs     - ERS data.
c     ersmask    - mask for ERS data.
c     ctdtobs    - CTD temperature data
c     ctdsobs    - CTD salinity data
c     xbtobs     - XBT data 
c     udriftdat  - drifters zonal velocities
c     vdriftdat  - drifters meridional velocities

      common /cost_data_r/
     &                     tdat,
     &                     sstdat,
     &                     sstmask,
     &                     sdat,
     &                     sssdat,
     &                     sssmask, 
     &                     tpmean,
     &                     tpmeanmask,
     &                     tpobs,
     &                     tpmask,
     &                     ersobs,
     &                     ersmask,
     &                     ctdtobs,
     &                     ctdsobs,
     &                     xbtobs,
     &                     udriftdat,
     &                     vdriftdat
     
      _RL tdat      (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL sstdat    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sstmask   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sdat      (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL sssdat    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sssmask   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpmean    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpmeanmask(1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpobs     (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpmask    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL ersobs    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL ersmask   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL ctdtobs   (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL ctdsobs   (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL xbtobs    (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL udriftdat (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL vdriftdat (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)


c     Files that contain obervations:
c     ===============================
c
c     tdatfile      - reference data file for temperature.
c     sdatfile      - reference data file for salinity.
c     sstdatfile    - reference data file for sea surface temperature.
c     topexmeanfile - reference data file for mean sea surface height.
c     topexfile     - reference data file for sea surface height data
c                     (TOPEX/POSEIDON).
c     ersfile       - reference data file for sea surface height data
c                     (ERS).
c ctdtfile, ctdsfile- reference data file for temperature and salinity 
c                     from CTD
c     xbtfile       - reference data file for xbt
c     driftfile     - reference data file for drifter's mean velocities

      common /cost_data_c/
     &                     tdatfile,
     &                     sdatfile,
     &                     sstdatfile,
     &                     sssdatfile,
     &                     topexmeanfile,
     &                     topexfile,
     &                     ersfile,
     &                     ctdtfile,
     &                     ctdsfile,
     &                     xbtfile,
     &                     udriftfile, 
     &                     vdriftfile 
      character*(MAX_LEN_FNAM) tdatfile
      character*(MAX_LEN_FNAM) sdatfile
      character*(MAX_LEN_FNAM) sstdatfile
      character*(MAX_LEN_FNAM) sssdatfile
      character*(MAX_LEN_FNAM) topexmeanfile
      character*(MAX_LEN_FNAM) topexfile
      character*(MAX_LEN_FNAM) ersfile
      character*(MAX_LEN_FNAM) ctdtfile
      character*(MAX_LEN_FNAM) ctdsfile
      character*(MAX_LEN_FNAM) xbtfile
      character*(MAX_LEN_FNAM) udriftfile
      character*(MAX_LEN_FNAM) vdriftfile      


c     Calendar information for the observations:
c     ==========================================
c
c     sststartdate   - start date of the sea surface temperature data.
c     topexstartdate - start date of the sea surface height data.
c     ersstartdate   - start date of the sea surface height data.
c     sshperiod      - sampling interval for the sea surface height data.

      common /cost_data_times_i/
     &                           sststartdate,
     &                           sssstartdate,
     &                           topexstartdate,
     &                           ersstartdate
      integer sststartdate(4)
      integer sssstartdate(4)
      integer topexstartdate(4)
      integer ersstartdate(4)


      common /cost_data_times_r/
     &                           topexperiod,
     &                           ersperiod
      _RL topexperiod
      _RL ersperiod

c     ==================================================================
c     END OF HEADER COST
c     ==================================================================


