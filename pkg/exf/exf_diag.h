C     /==========================================================\
C     | EXF_DIAG.h                                              |
C     | o Header for Exf formula diagnostic output              |
C     \==========================================================/

#ifdef ALLOW_BULKFORMULAE
#ifdef ALLOW_EXF_TIMEAVE

C     Keep track of time
      _RL EXF_TimeAve(Nr, nSx,nSy)
      COMMON /EXF_TAVE_TIME/ EXF_TimeAve

C     Storage arrays for time-averages
      _RL EXF_Qnet_AVE     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_EmPmR_AVE    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_fu_AVE       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_fv_AVE       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_latent_AVE   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_sensible_AVE (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_evap_AVE     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_flwup_AVE    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_flwupnet_AVE (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_solar_AVE    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL EXF_ssq_AVE      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


      COMMON /EXF_TAVE_ARRAYS/
     &                       EXF_Qnet_AVE, EXF_EmPmR_AVE, 
     &                       EXF_fu_AVE, EXF_fv_AVE,
     &                       EXF_sensible_AVE, EXF_latent_AVE,
     &                       EXF_evap_AVE, EXF_flwup_AVE,
     &                       EXF_solar_AVE, EXF_ssq_AVE,
     &                       EXF_flwupnet_AVE



#endif /* ALLOW_EXF_TIMEAVE*/
#endif /* ALLOW_BULKFORMULAE */
