C $Header$
C
C     /==========================================================\
C     | RDYF_MACROS.h                                             |
C     |==========================================================|
C     | These macros are used to reduce memory requirement and/or|
C     | memory references when variables are fixed along a given |
C     | axis or axes.                                            |
C     \==========================================================/

#ifdef RDYF_CONST
#define  _rdyF(i,j,bi,bj) rdyF(1,1,1,1)
#endif

#ifdef RDYF_FX
#define  _rdyF(i,j,bi,bj) rdyF(i,1,bi,1)
#endif

#ifdef RDYF_FY
#define  _rdyF(i,j,bi,bj) rdyF(1,j,1,bj)
#endif

#ifndef _rdyF
#define  _rdyF(i,j,bi,bj) rdyF(i,j,bi,bj)
#endif
