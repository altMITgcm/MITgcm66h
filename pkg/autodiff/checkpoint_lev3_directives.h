c
c     store directives for checkpoint level 3
c
c     created: heimbach@mit.edu 10-Jan-2002
c
CADJ STORE gsnm1     = tapelev3, key = ilev_3
CADJ STORE gtnm1     = tapelev3, key = ilev_3
CADJ STORE gunm1     = tapelev3, key = ilev_3
CADJ STORE gvnm1     = tapelev3, key = ilev_3
CADJ STORE theta     = tapelev3, key = ilev_3
CADJ STORE salt      = tapelev3, key = ilev_3
CADJ STORE uvel      = tapelev3, key = ilev_3
CADJ STORE vvel      = tapelev3, key = ilev_3
CADJ STORE wvel      = tapelev3, key = ilev_3
CADJ STORE etan      = tapelev3, key = ilev_3
CADJ STORE gu        = tapelev3, key = ilev_3
CADJ STORE gv        = tapelev3, key = ilev_3

#ifdef INCLUDE_CD_CODE
CADJ STORE uveld     = tapelev3, key = ilev_3
CADJ STORE vveld     = tapelev3, key = ilev_3
CADJ STORE etanm1    = tapelev3, key = ilev_3
CADJ STORE unm1      = tapelev3, key = ilev_3
CADJ STORE vnm1      = tapelev3, key = ilev_3
CADJ STORE gucd      = tapelev3, key = ilev_3
CADJ STORE gvcd      = tapelev3, key = ilev_3
#endif /* INCLUDE_CD_CODE */

#ifdef ALLOW_PASSIVE_TRACER
CADJ STORE tr1       = tapelev3, key = ilev_3
CADJ STORE gtr1nm1   = tapelev3, key = ilev_3
#endif /*  */

#ifdef EXACT_CONSERV
CADJ STORE etaH      = tapelev3, key = ilev_3
CADJ STORE hDivFlow  = tapelev3, key = ilev_3
#endif /*  */

#ifdef INCLUDE_EXTERNAL_FORCING_PACKAGE
# ifdef ALLOW_ATM_TEMP
CADJ STORE aqh0      = tapelev3, key = ilev_3
CADJ STORE aqh1      = tapelev3, key = ilev_3
CADJ STORE atemp0    = tapelev3, key = ilev_3
CADJ STORE atemp1    = tapelev3, key = ilev_3
CADJ STORE precip0   = tapelev3, key = ilev_3
CADJ STORE precip1   = tapelev3, key = ilev_3
CADJ STORE lwflux0   = tapelev3, key = ilev_3
CADJ STORE lwflux1   = tapelev3, key = ilev_3
CADJ STORE swflux0   = tapelev3, key = ilev_3
CADJ STORE swflux1   = tapelev3, key = ilev_3
#  ifdef EXF_READ_EVAP
CADJ STORE evap0     = tapelev3, key = ilev_3
CADJ STORE evap1     = tapelev3, key = ilev_3
#  else
CADJ STORE evap      = tapelev3, key = ilev_3
#  endif
# else
CADJ STORE hflux0    = tapelev3, key = ilev_3
CADJ STORE hflux1    = tapelev3, key = ilev_3
CADJ STORE sflux0    = tapelev3, key = ilev_3
CADJ STORE sflux1    = tapelev3, key = ilev_3
#  ifdef ALLOW_KPP
CADJ STORE swflux0   = tapelev3, key = ilev_3
CADJ STORE swflux1   = tapelev3, key = ilev_3
#  endif
# endif /* ALLOW_ATM_TEMP */
# ifdef ALLOW_ATM_WIND
CADJ STORE uwind0    = tapelev3, key = ilev_3
CADJ STORE uwind1    = tapelev3, key = ilev_3
CADJ STORE vwind0    = tapelev3, key = ilev_3
CADJ STORE vwind1    = tapelev3, key = ilev_3
# else
CADJ STORE ustress0  = tapelev3, key = ilev_3
CADJ STORE ustress1  = tapelev3, key = ilev_3
CADJ STORE vstress0  = tapelev3, key = ilev_3
CADJ STORE vstress1  = tapelev3, key = ilev_3
# endif  /* ALLOW_ATM_WIND */
# ifdef ALLOW_CLIMSSS_RELAXATION
CADJ STORE climsss0   = tapelev3, key = ilev_3
CADJ STORE climsss1   = tapelev3, key = ilev_3
# endif
#ifdef ALLOW_CLIMSST_RELAXATION
CADJ STORE climsst0   = tapelev3, key = ilev_3
CADJ STORE climsst1   = tapelev3, key = ilev_3
# endif
#ifdef ALLOW_CLIMSALT_RELAXATION
cph not used so far
cphCADJ STORE climsalt0  = tapelev3, key = ilev_3
cphCADJ STORE climsalt1  = tapelev3, key = ilev_3
# endif
#ifdef ALLOW_CLIMTEMP_RELAXATION
cph not used so far
cphCADJ STORE climtemp0  = tapelev3, key = ilev_3
cphCADJ STORE climtemp1  = tapelev3, key = ilev_3
# endif
#ifdef ALLOW_HFLUX_CONTROL
CADJ STORE xx_hflux0     = tapelev3, key = ilev_3
CADJ STORE xx_hflux1     = tapelev3, key = ilev_3
#endif
#ifdef ALLOW_SFLUX_CONTROL
CADJ STORE xx_sflux0     = tapelev3, key = ilev_3
CADJ STORE xx_sflux1     = tapelev3, key = ilev_3
#endif
#ifdef ALLOW_USTRESS_CONTROL
CADJ STORE xx_tauu0      = tapelev3, key = ilev_3
CADJ STORE xx_tauu1      = tapelev3, key = ilev_3
#endif
#ifdef ALLOW_VSTRESS_CONTROL
CADJ STORE xx_tauv0      = tapelev3, key = ilev_3
CADJ STORE xx_tauv1      = tapelev3, key = ilev_3
#endif
#endif /* INCLUDE_EXTERNAL_FORCING_PACKAGE */

#ifdef ALLOW_OBCS
#ifdef ALLOW_OBCS_NORTH
CADJ STORE OBNt    = tapelev3, key = ilev_3
CADJ STORE OBNs    = tapelev3, key = ilev_3
CADJ STORE OBNu0    = tapelev3, key = ilev_3
CADJ STORE OBNv0    = tapelev3, key = ilev_3
CADJ STORE OBNt0    = tapelev3, key = ilev_3
CADJ STORE OBNs0    = tapelev3, key = ilev_3
CADJ STORE OBNu1    = tapelev3, key = ilev_3
CADJ STORE OBNv1    = tapelev3, key = ilev_3
CADJ STORE OBNt1    = tapelev3, key = ilev_3
CADJ STORE OBNs1    = tapelev3, key = ilev_3
#endif /* ALLOW_OBCS_NORTH */
#ifdef ALLOW_OBCS_SOUTH
CADJ STORE OBSt    = tapelev3, key = ilev_3
CADJ STORE OBSs    = tapelev3, key = ilev_3
CADJ STORE OBSu0    = tapelev3, key = ilev_3
CADJ STORE OBSv0    = tapelev3, key = ilev_3
CADJ STORE OBSt0    = tapelev3, key = ilev_3
CADJ STORE OBSs0    = tapelev3, key = ilev_3
CADJ STORE OBSu1    = tapelev3, key = ilev_3
CADJ STORE OBSv1    = tapelev3, key = ilev_3
CADJ STORE OBSt1    = tapelev3, key = ilev_3
CADJ STORE OBSs1    = tapelev3, key = ilev_3
#endif /* ALLOW_OBCS_SOUTH */
#ifdef ALLOW_OBCS_EAST
CADJ STORE OBEt    = tapelev3, key = ilev_3
CADJ STORE OBEs    = tapelev3, key = ilev_3
CADJ STORE OBEu0    = tapelev3, key = ilev_3
CADJ STORE OBEv0    = tapelev3, key = ilev_3
CADJ STORE OBEt0    = tapelev3, key = ilev_3
CADJ STORE OBEs0    = tapelev3, key = ilev_3
CADJ STORE OBEu1    = tapelev3, key = ilev_3
CADJ STORE OBEv1    = tapelev3, key = ilev_3
CADJ STORE OBEt1    = tapelev3, key = ilev_3
CADJ STORE OBEs1    = tapelev3, key = ilev_3
#endif /* ALLOW_OBCS_EAST */
#ifdef ALLOW_OBCS_WEST
CADJ STORE OBWt    = tapelev3, key = ilev_3
CADJ STORE OBWs    = tapelev3, key = ilev_3
CADJ STORE OBWu0    = tapelev3, key = ilev_3
CADJ STORE OBWv0    = tapelev3, key = ilev_3
CADJ STORE OBWt0    = tapelev3, key = ilev_3
CADJ STORE OBWs0    = tapelev3, key = ilev_3
CADJ STORE OBWu1    = tapelev3, key = ilev_3
CADJ STORE OBWv1    = tapelev3, key = ilev_3
CADJ STORE OBWt1    = tapelev3, key = ilev_3
CADJ STORE OBWs1    = tapelev3, key = ilev_3
#endif /* ALLOW_OBCS_WEST */
#endif  /* ALLOW_OBCS */

