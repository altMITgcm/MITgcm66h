C $Header$
C $Name$

C     ==================================================================
C     CTRL_GENARR.h
C     ==================================================================

      COMMON /CONTROLFILES_CARR/
     &     xx_genarr2d_file,
     &     xx_genarr3d_file

      CHARACTER*(MAX_LEN_FNAM) xx_genarr2d_file(maxCtrlArr2D)
      CHARACTER*(MAX_LEN_FNAM) xx_genarr3d_file(maxCtrlArr3D)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
