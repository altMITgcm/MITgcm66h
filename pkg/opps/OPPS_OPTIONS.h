C $Header$
C $Name$
C     /==========================================================\
C     | OPPS_OPTIONS.h                                            |
C     | o CPP options file for OPPS package.                      |
C     |==========================================================|
C     | Use this file for selecting options within the OPPS       |
C     | package.  OPPS is enabled with ALLOW_OPPS in CPP_OPTIONS.h |
C     \==========================================================/

#ifndef OPPS_OPTIONS_H
#define OPPS_OPTIONS_H
#include "PACKAGES_CONFIG.h"

#ifdef ALLOW_OPPS

#include "CPP_OPTIONS.h"

C allow debugging OPPS_CALC
#define ALLOW_OPPS_DEBUG

C
#endif /* ALLOW_OPPS */
#endif /* OPPS_OPTIONS_H */

