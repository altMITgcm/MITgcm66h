C $Header$
C $Name$

#ifdef ALLOW_AIM

C--   COMMON /VDICON/: Constants for vertical dif. and sh. conv. 
C                     (init. in INPHYS)
C      TRVDI  = relaxation time (in hours) for moisture diffusion
C      TRSHC  = relaxation time (in hours) for shallow convection
      COMMON /VDICON/ TRVDI, TRSHC
      _RL TRVDI, TRSHC

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
#endif /* ALLOW_AIM */ 
