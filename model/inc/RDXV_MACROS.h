C $Header$
C
C     /==========================================================\
C     | RDXV_MACROS.h                                             |
C     |==========================================================|
C     | These macros are used to reduce memory requirement and/or|
C     | memory references when variables are fixed along a given |
C     | axis or axes.                                            |
C     \==========================================================/

#ifdef RDXV_CONST
#define  _rdxV(i,j,bi,bj) rdxV(1,1,1,1)
#endif

#ifdef RDXV_FX
#define  _rdxV(i,j,bi,bj) rdxV(i,1,bi,1)
#endif

#ifdef RDXV_FY
#define  _rdxV(i,j,bi,bj) rdxV(1,j,1,bj)
#endif

#ifndef _rdxV
#define  _rdxV(i,j,bi,bj) rdxV(i,j,bi,bj)
#endif
