C $Header$
C $Name$
C
C     /==========================================================\
C     | SHAP_FILT_UV.h                                           |
C     | o Globals used by Fortran shapiro filter routine.        |
C     \==========================================================/
      COMMON / SHFT_UV_COMMON_R8 / tmpFldU, tmpFldV
      _RL tmpFldU(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL tmpFldV(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
