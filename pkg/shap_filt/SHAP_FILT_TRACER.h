C $Header$
C $Name$
C
C     /==========================================================\
C     | SHAP_FILT_TRACER.h                                       |
C     | o Globals used by Fortran shapiro filter routine.        |
C     \==========================================================/
      COMMON / SHFT_COMMON_R8 / tmpFld
      _RL tmpFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
