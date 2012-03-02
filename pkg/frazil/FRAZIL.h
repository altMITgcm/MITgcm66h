C $Header$
C $Name$

#ifdef ALLOW_FRAZIL

C     frazil_TendT           - temperature tendency (Kelvin/s)
      _RL frazil_TendT(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      COMMON /FRAZIL_TENDENCY/ frazil_TendT

#endif /* ALLOW_FRAZIL */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
