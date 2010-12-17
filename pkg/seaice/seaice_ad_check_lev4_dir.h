C $Header$
C $Name$

CADJ STORE StoreSEAICE    = tapelev4, key = ilev_4

#ifdef SEAICE_MULTICATEGORY
CADJ STORE tices      =     tapelev4, key = ilev_4
#endif

#ifdef NONLIN_FRSURF
CADJ STORE area  = tapelev4, key = ilev_4
CADJ STORE heff  = tapelev4, key = ilev_4
CADJ STORE uice  = tapelev4, key = ilev_4
CADJ STORE vice  = tapelev4, key = ilev_4
#endif

#ifdef ALLOW_COST_ICE
CADJ STORE objf_ice = tapelev4, key = ilev_4
#endif
#ifdef ALLOW_SEAICE_COST_EXPORT
CADJ STORE uHeffExportCell = tapelev4, key = ilev_4
CADJ STORE vHeffExportCell = tapelev4, key = ilev_4
#endif
