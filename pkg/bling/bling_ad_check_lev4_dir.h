C $Header$
C $Name$

#ifdef ALLOW_BLING

C common CARBON_NEEDS
CADJ STORE pH                = tapelev4, key = ilev_4
CADJ STORE fice              = tapelev4, key = ilev_4
CADJ STORE silica            = tapelev4, key = ilev_4

CADJ STORE irr_mem           = tapelev4, key = ilev_4
CADJ STORE P_sm              = tapelev4, key = ilev_4 
CADJ STORE P_lg              = tapelev4, key = ilev_4 
CADJ STORE P_diaz            = tapelev4, key = ilev_4
CADJ STORE chl               = tapelev4, key = ilev_4

C CMM(
CADJ STORE atmosp0        = tapelev4, key = ilev_4
CADJ STORE atmosp1        = tapelev4, key = ilev_4
CADJ STORE feinput0       = tapelev4, key = ilev_4
CADJ STORE feinput1       = tapelev4, key = ilev_4
CADJ STORE ice0           = tapelev4, key = ilev_4
CADJ STORE ice1           = tapelev4, key = ilev_4
CADJ STORE silica0        = tapelev4, key = ilev_4
CADJ STORE silica1        = tapelev4, key = ilev_4
C CMM)
#ifdef ALLOW_BLING_COST
CADJ STORE totcost  = tapelev4, key = ilev_4
#endif

#endif /* ALLOW_BLING */

