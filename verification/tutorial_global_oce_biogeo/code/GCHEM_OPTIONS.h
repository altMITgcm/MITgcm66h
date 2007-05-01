C $Header$
C $Name$

#ifndef GCHEM_OPTIONS_H
#define GCHEM_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#ifdef ALLOW_GCHEM

#include "CPP_OPTIONS.h"

CBOP
C    !ROUTINE: GCHEM_OPTIONS.h
C    !INTERFACE:

C    !DESCRIPTION:
c options for biogeochemistry package
CEOP

#define GCHEM_SEPARATE_FORCING

c------------------------------------
c specifics for dic pkg
#define DIC_BIOTIC
#undef  ALLOW_FE
#define ALLOW_O2
#undef READ_PAR
#undef MINFE
c -------------------------------------

#undef  ALLOW_CFC

#endif /* ALLOW_GCHEM */
#endif /* GCHEM_OPTIONS_H */
