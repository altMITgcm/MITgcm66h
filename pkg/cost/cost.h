
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================
c
c     o Header for averaged temperature, salinity, and surface pressure
c       fields and counters associated with the averaging.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c     changed: Christian Eckert eckert@mit.edu  01-Mar-2000
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c     added sea-ice term: menemenlis@jpl.nasa.gov 26-Feb-2003
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
c     vbar  - contains the averaged zonal velocity component for the
c             whole integration period. Before, it accumulates the
c             intantaneous field.
c     tauxbar  - contains the averaged zonal velocity component for the
c             whole integration period. Before, it accumulates the
c             intantaneous field.
c     tauybar  - contains the averaged zonal velocity component for the
c             whole integration period. Before, it accumulates the
c             intantaneous field.
c     hfluxbar  - contains the averaged zonal velocity component for the
c             whole integration period. Before, it accumulates the
c             intantaneous field.
c     sfluxbar  - contains the averaged zonal velocity component for the
c             whole integration period. Before, it accumulates the
c             intantaneous field.

      common /averages_r/ 
     &                    tbar,
     &                    sbar,
     &                    psbar,
     &                    ubar,
     &                    vbar,
     &                    wbar,
     &                    tauxbar,
     &                    tauybar,
     &                    hfluxbar,
     &                    sfluxbar,
     &                    Slmean, 
     &                    Tlmean,
     &                    wlmean,
     &                    Sfmean,
     &                    Tfmean,                   
     &                    wfmean

#if (defined (ALLOW_THETA_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDT_COST_CONTRIBUTION) || \
     defined (ALLOW_XBT_COST_CONTRIBUTION) || \
     defined (ALLOW_DRIFT_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
      _RL tbar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
#ifdef ALLOW_SST_COST_CONTRIBUTION
      _RL tbar  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
#else
      _RL tbar
#endif
#endif

#if (defined (ALLOW_SALT_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDS_COST_CONTRIBUTION) || \
     defined (ALLOW_DRIFT_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))
      _RL sbar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
#ifdef ALLOW_SSS_COST_CONTRIBUTION
      _RL sbar  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
#else
      _RL sbar
#endif
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

#ifdef ALLOW_DRIFTW_COST_CONTRIBUTION
      _RL wbar  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
      _RL wbar
#endif

#ifdef ALLOW_DRIFT_COST_CONTRIBUTION
      _RL   Tlmean(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL   Slmean(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL   Tfmean(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL   Sfmean(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
      _RL   Tlmean
      _RL   Slmean
      _RL   Tfmean
      _RL   Sfmean        
#endif

#ifdef ALLOW_DRIFTW_COST_CONTRIBUTION
      _RL   wlmean(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL   wfmean(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#else
      _RL   wlmean
      _RL   wfmean
#endif

#ifdef ALLOW_SCAT_COST_CONTRIBUTION
      _RL tauxbar  (1-olx:snx+olx,1-oly:sny+oly,  nsx,nsy)
      _RL tauybar  (1-olx:snx+olx,1-oly:sny+oly,  nsx,nsy)
#else
      _RL tauxbar 
      _RL tauybar 
#endif

#ifdef ALLOW_MEAN_HFLUX_COST_CONTRIBUTION
      _RL hfluxbar  (1-olx:snx+olx,1-oly:sny+oly,  nsx,nsy)
#else 
      _RL hfluxbar
#endif

#ifdef ALLOW_MEAN_SFLUX_COST_CONTRIBUTION
      _RL sfluxbar  (1-olx:snx+olx,1-oly:sny+oly,  nsx,nsy)    
#else 
      _RL sfluxbar
#endif


      common /averages_c/ 
     &                    tbarfile,
     &                    sbarfile,
     &                    psbarfile,
     &                    ubarfile,
     &                    vbarfile,
     &                    wbarfile,
     &                    tauxbarfile,
     &                    tauybarfile,
     &                    hfluxbarfile,
     &                    sfluxbarfile
      character*(MAX_LEN_FNAM) tbarfile
      character*(MAX_LEN_FNAM) sbarfile
      character*(MAX_LEN_FNAM) psbarfile
      character*(MAX_LEN_FNAM) ubarfile
      character*(MAX_LEN_FNAM) vbarfile
      character*(MAX_LEN_FNAM) wbarfile
      character*(MAX_LEN_FNAM) tauxbarfile
      character*(MAX_LEN_FNAM) tauybarfile
      character*(MAX_LEN_FNAM) hfluxbarfile
      character*(MAX_LEN_FNAM) sfluxbarfile

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
c     objf_hfluxm    - time-mean Heat flux contribution.
c     objf_sfluxm    - time-mean Salt flux contribution.
c     objf_tauum  - time-mean Zonal wind stress contribution.
c     objf_tauvm  - time-mean Meridional wind stress contribution.
c     objf_hfluxmm    - Global time-mean Heat flux contribution.
c     objf_sfluxmm    - Global time-mean Salt flux contribution.
c     objf_hmean - Mean sea surface height contribution.
c     objf_h     - Residual sea surface height contribution.
c     objf_temp  - Temperature contribution.
c     objf_salt  - Salinity contribution.
c     objf_temp0 - Initial conditions Temperature contribution.
c     objf_salt0 - Initial conditions Salinity contribution.
c     objf_sst   - Sea surface temperature contribution.
c     objf_sss   - Sea surface salinity contribution.
c     objf_atl   - Meridional heat transport in the N-Atlantic
c     objf_ctdt  - Temperature measurements from Woce CTD 
c     objf_ctds  - Salinity measurements from Woce CTD 
c     objf_xbt   - XBT temperature data
c     objf_argot - ARGO temperature profiles
c     objf_argos - ARGO salt profiles
c     objf_scatxm - time-mean zonal SCAT  contribution
c     objf_scatym - time-mean meridional SCAT  contribution
c     objf_scatx  - zonal SCAT  contribution
c     objf_scaty  - meridional SCAT  contribution
c     objf_ice    - sea-ice volume
c
c     mult_"var" - multipliers for the individual cost
c                  function contributions.

      common /cost_r/
     &                fc,
     &                objf_hflux,
     &                objf_hfluxm,
     &                objf_hfluxmm,
     &                objf_sflux,
     &                objf_sfluxm,
     &                objf_sfluxmm,
     &                objf_tauu,
     &                objf_tauum,
     &                objf_tauv,
     &                objf_tauvm,
     &                objf_hmean,
     &                objf_h,
     &                objf_temp,
     &                objf_salt,
     &                objf_temp0,
     &                objf_salt0,
     &                objf_sst,
     &                objf_sss,
     &                objf_atl,
     &                objf_ctdt,
     &                objf_ctds,
     &                objf_xbt,
     &                objf_argot,
     &                objf_argos,
     &                objf_drift,
     &                objf_tdrift,
     &                objf_sdrift,
     &                objf_wdrift,
     &                objf_scatx,
     &                objf_scaty,
     &                objf_scatxm,
     &                objf_scatym,
     &                objf_atemp,
     &                objf_aqh,
     &                objf_uwind,
     &                objf_vwind,
     &                objf_obcsn,
     &                objf_obcss,
     &                objf_obcsw,
     &                objf_obcse,
     &                objf_ice
      _RL  fc
      _RL  objf_hflux  (nsx,nsy)
      _RL  objf_hfluxm (nsx,nsy)
      _RL  objf_hfluxmm(nsx,nsy)
      _RL  objf_sflux  (nsx,nsy)
      _RL  objf_sfluxm (nsx,nsy)
      _RL  objf_sfluxmm(nsx,nsy)
      _RL  objf_tauu   (nsx,nsy)
      _RL  objf_tauum  (nsx,nsy)
      _RL  objf_tauv   (nsx,nsy)
      _RL  objf_tauvm  (nsx,nsy)
      _RL  objf_hmean
      _RL  objf_h    (nsx,nsy)
      _RL  objf_temp (nsx,nsy)
      _RL  objf_salt (nsx,nsy)
      _RL  objf_temp0(nsx,nsy)
      _RL  objf_salt0(nsx,nsy)
      _RL  objf_sst  (nsx,nsy)
      _RL  objf_sss  (nsx,nsy) 
      _RL  objf_atl  (nsx,nsy)
      _RL  objf_ctdt (nsx,nsy)
      _RL  objf_ctds (nsx,nsy)
      _RL  objf_xbt  (nsx,nsy)
      _RL  objf_argot(nsx,nsy)
      _RL  objf_argos(nsx,nsy)
      _RL  objf_drift(nsx,nsy)
      _RL  objf_tdrift(nsx,nsy)
      _RL  objf_sdrift(nsx,nsy)
      _RL  objf_wdrift(nsx,nsy)
      _RL  objf_scatx(nsx,nsy)
      _RL  objf_scaty(nsx,nsy)
      _RL  objf_scatxm(nsx,nsy)
      _RL  objf_scatym(nsx,nsy)
      _RL  objf_atemp(nsx,nsy)
      _RL  objf_aqh  (nsx,nsy)
      _RL  objf_uwind(nsx,nsy)
      _RL  objf_vwind(nsx,nsy)
      _RL  objf_obcsn(nsx,nsy)
      _RL  objf_obcss(nsx,nsy)
      _RL  objf_obcsw(nsx,nsy)
      _RL  objf_obcse(nsx,nsy)
      _RL  objf_ice  (nsx,nsy)

      common /cost_aux_r/
     &                    mult_hflux,
     &                    mult_sflux,
     &                    mult_tauu,
     &                    mult_tauv,
     &                    mult_hmean,
     &                    mult_h,
     &                    mult_temp,
     &                    mult_salt,
     &                    mult_temp0,
     &                    mult_salt0,
     &                    mult_sst,
     &                    mult_sss,
     &                    mult_atl,
     &                    mult_ctdt,
     &                    mult_ctds,
     &                    mult_xbt,
     &                    mult_argot,
     &                    mult_argos,
     &                    mult_drift,
     &                    mult_tdrift,
     &                    mult_sdrift,
     &                    mult_wdrift,
     &                    mult_scatx,
     &                    mult_scaty,
     &                    mult_atemp,
     &                    mult_aqh,
     &                    mult_uwind,
     &                    mult_vwind,
     &                    mult_obcsn,
     &                    mult_obcss,
     &                    mult_obcsw,
     &                    mult_obcse,
     &                    mult_ice
      _RL  mult_hflux
      _RL  mult_sflux
      _RL  mult_tauu
      _RL  mult_tauv
      _RL  mult_hmean
      _RL  mult_h
      _RL  mult_temp
      _RL  mult_salt
      _RL  mult_temp0
      _RL  mult_salt0
      _RL  mult_sst
      _RL  mult_sss
      _RL  mult_atl
      _RL  mult_ctdt
      _RL  mult_ctds
      _RL  mult_xbt
      _RL  mult_argot
      _RL  mult_argos
      _RL  mult_drift
      _RL  mult_tdrift
      _RL  mult_sdrift
      _RL  mult_wdrift
      _RL  mult_scatx
      _RL  mult_scaty
      _RL  mult_atemp
      _RL  mult_aqh
      _RL  mult_uwind
      _RL  mult_vwind
      _RL  mult_obcsn
      _RL  mult_obcss
      _RL  mult_obcsw
      _RL  mult_obcse
      _RL  mult_ice


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
c     tauum_errfile         - zonal wind stress error.
c     tauv_errfile          - meridional wind stress error.
c     tauvm_errfile         - meridional wind stress error.
c     tscatx_errfile        - zonal wind stress error.
c     tscaty_errfile        - meridional wind stress error.
c     data_errfile          - weights for theta, salt, and SST
c     geoid_errfile         - geoid error.
c     geoid_covariancefile  - geoid error covariance.
c     ssh_errfile           - sea surface height error.
c     ctdt_errfile          - CTD temperature error.
c     ctds_errfile          - CTD salinity error.
c     drift_errfile         - drifter error.
c     salterrfile           - representation error due unresolved eddies
c     temperrfile           - representation error due unresolved eddies

      common /cost_c/ 
     &                hflux_errfile,
     &                hfluxm_errfile,
     &                sflux_errfile,
     &                sfluxm_errfile,
     &                tauu_errfile,
     &                tauum_errfile,
     &                tauv_errfile,
     &                tauvm_errfile,
     &                scatx_errfile,
     &                scaty_errfile,
     &                data_errfile,
     &                geoid_errfile,
     &                geoid_covariancefile,
     &                ssh_errfile,
     &                ctdt_errfile,
     &                ctds_errfile, 
     &                drift_errfile,
     &                udrifterrfile, 
     &                vdrifterrfile, 
     &                salterrfile,
     &                temperrfile,
     &                atemp_errfile,
     &                aqh_errfile,
     &                uwind_errfile,
     &                vwind_errfile
      character*(MAX_LEN_FNAM) hflux_errfile
      character*(MAX_LEN_FNAM) sflux_errfile
      character*(MAX_LEN_FNAM) tauu_errfile
      character*(MAX_LEN_FNAM) tauv_errfile
      character*(MAX_LEN_FNAM) hfluxm_errfile
      character*(MAX_LEN_FNAM) sfluxm_errfile
      character*(MAX_LEN_FNAM) tauum_errfile
      character*(MAX_LEN_FNAM) tauvm_errfile
      character*(MAX_LEN_FNAM) scatx_errfile
      character*(MAX_LEN_FNAM) scaty_errfile
      character*(MAX_LEN_FNAM) data_errfile
      character*(MAX_LEN_FNAM) geoid_errfile
      character*(MAX_LEN_FNAM) geoid_covariancefile
      character*(MAX_LEN_FNAM) ssh_errfile
      character*(MAX_LEN_FNAM) ctdt_errfile 
      character*(MAX_LEN_FNAM) ctds_errfile 
      character*(MAX_LEN_FNAM) drift_errfile
      character*(MAX_LEN_FNAM) udrifterrfile
      character*(MAX_LEN_FNAM) vdrifterrfile      
      character*(MAX_LEN_FNAM) salterrfile
      character*(MAX_LEN_FNAM) temperrfile
      character*(MAX_LEN_FNAM) atemp_errfile
      character*(MAX_LEN_FNAM) aqh_errfile
      character*(MAX_LEN_FNAM) uwind_errfile
      character*(MAX_LEN_FNAM) vwind_errfile


c     Arrays where the weights are stored:
c     ====================================
c
c     cosphi     - cosine of latitude.
c     whflux     - weight for heat flux.
c     wsflux     - weight for salt flux.
c     wtauu      - weight for zonal wind stress.
c     wtauu      - weight for meridional wind stress.
c     wscatx     - weight for zonal scat stress.
c     wscaty     - weight for meridional scat stress.
c     wtheta     - weight for temperature.
c     wtheta2    - representation error due to unresolved eddies
c     wsst       - weight for sea surface temperature.
c     wsss       - weight for sea surface salinity.
c     wsalt      - weight for salinity.
c     wsalt2     - representation error due to unresolved eddies
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
     &                      wscatx,wscaty,
     &                      wtheta,wtheta2,wsst,wsss,
     &                      wsalt,wsalt2,
     &                      wtp,wers,
     &                      wp,
     &                      wctdt,wctds,
     &                      wudrift,wvdrift,
     &                      whfluxmm,wsfluxmm
      _RL frame   (1-olx:snx+olx,1-oly:sny+oly           )
      _RL cosphi  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL whflux  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL whfluxm (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL whfluxmm(1-olx:snx+olx,1-oly:sny+oly)
      _RL wsflux  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wsfluxm (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wsfluxmm(1-olx:snx+olx,1-oly:sny+oly)
      _RL wtauu   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtauv   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtauum  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtauvm  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wscatx  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wscaty  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL watemp  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL waqh    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wuwind  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wvwind  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL wtheta  (                            nr,nsx,nsy)
      _RL wsalt   (                            nr,nsx,nsy)
      _RL wtheta2 (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL wsalt2  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
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
c     scatxdat   - reference zonal wind stress.
c     scatydat   - reference meridional wind stress.
c     sstdat     - reference sea surface temperature data.
c     sssdat     - reference sea surface temperature data.
c     tauxmask   - mask for reference wind stress data.
c     tauymask   - mask for reference wind stress data. 
c     scatxmask  - mask for scat wind stress data.
c     scatymask  - mask for scat wind stress data. 
c     sstmask    - mask for reference sea surface temperature data.
c     sssmask    - mask for reference sea surface temperature data.
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
c     argot      - ARGO  temperature data 
c     argos      - ARGO  salt data 
c     udriftdat  - drifters zonal velocities
c     vdriftdat  - drifters meridional velocities

      common /cost_data_r/
     &                     tdat,
     &                     scatxdat,
     &                     scatydat,
     &                     sstdat,
     &                     sssdat,
     &                     sstmask,
     &                     sssmask,
     &                     tauxmask,
     &                     tauymask,
     &                     scatxmask,
     &                     scatymask,
     &                     sdat,
     &                     tpmean,
     &                     tpmeanmask,
     &                     tpobs,
     &                     tpmask,
     &                     ersobs,
     &                     ersmask,
     &                     ctdtobs,
     &                     ctdsobs,
     &                     xbtobs,
     &                     argotobs,
     &                     argosobs,
     &                     udriftdat,
     &                     vdriftdat
     
      _RL tdat      (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL scatxdat  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL scatydat  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sstdat    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sssdat    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tauxmask  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tauymask  (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL scatxmask (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL scatymask (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sstmask   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sssmask   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL sdat      (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL tpmean    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpmeanmask(1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpobs     (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL tpmask    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL ersobs    (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL ersmask   (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL ctdtobs   (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL ctdsobs   (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL xbtobs    (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL argotobs  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL argosobs  (1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL udriftdat (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)
      _RL vdriftdat (1-olx:snx+olx,1-oly:sny+oly,   nsx,nsy)


c     Files that contain obervations:
c     ===============================
c
c     tdatfile      - reference data file for temperature.
c     sdatfile      - reference data file for salinity.
c     scatxdatfile  - reference data file for zonal wind stress.
c     scatydatfile  - reference data file for meridional wind stress.
c     sstdatfile    - reference data file for sea surface temperature.
c     topexmeanfile - reference data file for mean sea surface height.
c     topexfile     - reference data file for sea surface height data
c                     (TOPEX/POSEIDON).
c     ersfile       - reference data file for sea surface height data
c                     (ERS).
c ctdtfile, ctdsfile- reference data file for temperature and salinity 
c                     from CTD
c     xbtfile       - reference data file for xbt
c     ARGOtfile     - reference data file for ARGO
c     ARGOsfile     - reference data file for ARGO
c     driftfile     - reference data file for drifter's mean velocities

      common /cost_data_c/
     &                     tdatfile,
     &                     sdatfile,
     &                     scatxdatfile,
     &                     scatydatfile,
     &                     sstdatfile,
     &                     sssdatfile,
     &                     topexmeanfile,
     &                     topexfile,
     &                     ersfile,
     &                     ctdtfile,
     &                     ctdsfile,
     &                     xbtfile,
     &                     argotfile,
     &                     argosfile,
     &                     udriftfile, 
     &                     vdriftfile 
      character*(MAX_LEN_FNAM) tdatfile
      character*(MAX_LEN_FNAM) sdatfile
      character*(MAX_LEN_FNAM) scatxdatfile
      character*(MAX_LEN_FNAM) scatydatfile
      character*(MAX_LEN_FNAM) sstdatfile
      character*(MAX_LEN_FNAM) sssdatfile
      character*(MAX_LEN_FNAM) topexmeanfile
      character*(MAX_LEN_FNAM) topexfile
      character*(MAX_LEN_FNAM) ersfile
      character*(MAX_LEN_FNAM) ctdtfile
      character*(MAX_LEN_FNAM) ctdsfile
      character*(MAX_LEN_FNAM) xbtfile
      character*(MAX_LEN_FNAM) argotfile
      character*(MAX_LEN_FNAM) argosfile
      character*(MAX_LEN_FNAM) argofile
      character*(MAX_LEN_FNAM) udriftfile
      character*(MAX_LEN_FNAM) vdriftfile      


c     Flags used in the model-data comparison:
c     ========================================
c
c     using_ers - flag that indicates the use of ERS data

      common /cost_data_flags/
     &                         using_topex,
     &                         using_ers
      logical using_topex
      logical using_ers

c     Calendar information for the observations:
c     ==========================================
c
c     sststartdate   - start date of the sea surface temperature data.
c     topexstartdate - start date of the sea surface height data.
c     ersstartdate   - start date of the sea surface height data.
c     sshperiod      - sampling interval for the sea surface height data.

      common /cost_data_times_i/
     &                           scatxstartdate,
     &                           scatystartdate,
     &                           sststartdate,
     &                           sssstartdate,
     &                           topexstartdate,
     &                           ersstartdate
      integer scatxstartdate(4)
      integer scatystartdate(4)
      integer sststartdate(4)
      integer sssstartdate(4)
      integer topexstartdate(4)
      integer ersstartdate(4)


      common /cost_data_times_r/
     &                           topexperiod,
     &                           ersperiod,
     &                           scatperiod
      _RL topexperiod
      _RL ersperiod
      _RL scatperiod

c     ==================================================================
c     END OF HEADER COST
c     ==================================================================


