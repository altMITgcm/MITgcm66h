C $Header$
C $Name$

#ifndef GCHEM_OPTIONS_H
#define GCHEM_OPTIONS_H
#include "PACKAGES_CONF.h"
#ifdef ALLOW_GCHEM

CBOP
C    !ROUTINE: GCHEM_OPTIONS.h
C    !INTERFACE:

C    !DESCRIPTION:
c coptions for biogeochemistry package

#ifdef ALLOW_PTRACERS
#define PTRACERS_SEPERATE_FORCING
#define DIC_BIOTIC
#define ALLOW_FE
#ifdef DIC_BIOTIC
#define DIC_ABIOTIC
#endif
#define ALLOW_DIC_COST
#endif /* ALLOW_PTRACERS */

#endif /* ALLOW_GCHEM */
#endif /* GCHEM_OPTIONS_H */
