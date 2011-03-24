C $Header$
C $Name$

#ifdef ALLOW_PTRACERS
# ifdef AUTODIFF_PTRACERS_SPLIT_FILES
CADJ STORE ptracer(:,:,:,:,:,1:PTRACERS_num)
CADJ &     = tapelev4, key = ilev_4
CADJ STORE gptrnm1(:,:,:,:,:,1:PTRACERS_num)
CADJ &     = tapelev4, key = ilev_4
CADJ STORE gptr(:,:,:,:,:,1:PTRACERS_num)
CADJ &     = tapelev4, key = ilev_4
# else
CADJ STORE ptracer = tapelev4, key = ilev_4
CADJ STORE gptrnm1 = tapelev4, key = ilev_4
CADJ STORE gptr    = tapelev4, key = ilev_4
# endif
#endif /* ALLOW_PTRACERS */
