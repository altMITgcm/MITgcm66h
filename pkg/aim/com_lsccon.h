C $Header$
C $Name$

#ifdef ALLOW_AIM

C--   COMMON /LSCCON/: Constants for large-scale condendation 
C                       (initial. in INPHYS)
C      RHLSC  = Relative humidity threshold
C      TRLSC  = Relaxation time (in hours) for supersat. specific humidity 

      COMMON /LSCCON/ RHLSC, TRLSC
      _RL RHLSC, TRLSC

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
#endif /* ALLOW_AIM */ 
