C $Header$
C $Name$

#ifdef ALLOW_AIM

C     /==========================================================\
C     | AIM_FFIELDS.h                                            |
C     | o AIM forcing fields.                                    |
C     \==========================================================/


C     aim_albedo       - Holds surface albedo ( 0-1 )
C     aim_surfTemp     - Holds surface temperature ( K )
C     aim_soilMoisture - Holds soil moisture ( 0-20 )
C
      COMMON /AIM_FFIELDS_R/
     &                   aim_albedo,
     &                   aim_surfTemp,
     &                   aim_soilMoisture
      _RS  aim_albedo      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  aim_surfTemp    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  aim_soilMoisture(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

#endif /* ALLOW_AIM */
