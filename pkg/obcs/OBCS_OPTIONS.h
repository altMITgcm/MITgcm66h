C $Header$
C $Name$
 
C CPP options file for OBCS package
C
C Use this file for selecting options within the OBCS package

#ifndef OBCS_OPTIONS_H
#define OBCS_OPTIONS_H
#include "PACKAGES_CONF.h"
#ifdef ALLOW_OBCS

#include "CPP_OPTIONS.h"

C This include hooks to the Orlanski Open Boundary Radiation code
#define ALLOW_ORLANSKI

#endif /* ALLOW_OBCS */
#endif /* OBCS_OPTIONS_H */
