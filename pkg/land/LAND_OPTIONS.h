C $Header$
C $Name$

C  CPP options file for Land package 

#ifndef LAND_OPTIONS_H
#define LAND_OPTIONS_H
#include "PACKAGES_CONF.h"
#ifdef ALLOW_LAND

#include "CPP_OPTIONS.h"

C  allow time average diagnostic:
#define ALLOW_LAND_TAVE

#endif /* ALLOW_LAND */
#endif /* LAND_OPTIONS_H */
