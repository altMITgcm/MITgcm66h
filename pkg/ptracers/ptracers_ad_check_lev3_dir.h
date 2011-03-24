C $Header$
C $Name$

#ifdef ALLOW_PTRACERS
# ifdef AUTODIFF_PTRACERS_SPLIT_FILES
CADJ STORE ptracer(:,:,:,:,:,1:PTRACERS_num)
CADJ &     = tapelev3_ptr, key = ilev_3
CADJ STORE gptrnm1(:,:,:,:,:,1:PTRACERS_num)
CADJ &     = tapelev3_ptr, key = ilev_3
CADJ STORE gptr(:,:,:,:,:,1:PTRACERS_num)
CADJ &     = tapelev3_ptr, key = ilev_3
# else
CADJ STORE ptracer = tapelev3, key = ilev_3
CADJ STORE gptrnm1 = tapelev3, key = ilev_3
CADJ STORE gptr    = tapelev3, key = ilev_3
# endif
#endif /* ALLOW_PTRACERS */
