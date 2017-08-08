C $Header: /u/gcmpack/MITgcm/pkg/kl10/KL10_OPTIONS.h,v 1.1 2014/07/30 03:28:05 jmc Exp $
C $Name: checkpoint66d $

C     *==========================================================*
C     | NF90IO_OPTIONS.h
C     | o CPP options file for NF90IO package.
C     *==========================================================*
C     | Use this file for selecting options within the NF90IO
C     | package.
C     *==========================================================*

C =====================================================
C !!!!  NOT IMPLIMENTED   !!!!
C
C As it stands, this routine is not called or needed.  All NF90IO is done
C via the diagnostics package.  i.e. see 
C      pkg/diagnostics/diagnostics_nf90io_out.F
C
C  This call would go in model/src/packages_readparms.F
C ======================================================

#ifndef NF90IO_OPTIONS_H
#define NF90IO_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

#ifdef ALLOW_NF90IO
C     Package-specific Options & Macros go here

#endif /* ALLOW_NF90IO */
#endif /* NF90IO_OPTIONS_H */
