C $Header$
C $Name$

#ifdef ALLOW_PTRACERS
# ifdef NONLIN_FRSURF
CADJ STORE ptracer   = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE gptrnm1   = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE gptr      = comlev1, key = ikey_dynamics, kind = isbyte
# endif
#endif /* ALLOW_PTRACERS */
