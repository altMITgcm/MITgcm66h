C $Header$
C $Name$
C $Namer: $

#ifdef ALLOW_AIM

C--   COMMON /FORCON/: Constants for forcing fields (initial. in INPHYS)
C      SOLC   = Solar constant (area averaged) in W/m^2
C      ALBSEA = Albedo over sea
C      ALBICE = Albedo over sea ice (for ice fraction = 1)
C      ALBSN  = Albedo over snow (for snow depth > SDALB)
C      SDALB  = Snow depth (mm water) corresponding to maximum albedo
C      SWCAP  = Soil wetness at field capacity (volume fraction)
C      SWWIL  = Soil wetness at wilting point  (volume fraction)

      COMMON /FORCON/ SOLC, ALBSEA, ALBICE, ALBSN, SDALB,
     &                SWCAP, SWWIL
      _RL SOLC, ALBSEA, ALBICE, ALBSN, SDALB, SWCAP, SWWIL

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
#endif /* ALLOW_AIM */ 
