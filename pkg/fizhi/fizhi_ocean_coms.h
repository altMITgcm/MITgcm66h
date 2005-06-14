C $Header$
C $Name$

c Ocean Exports
c -------------------
      common /ocean_exports/ sst, sice, ksst, kice
      _RL sst(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nsx,Nsy)
      _RL sice(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nsx,Nsy)
      integer ksst, kice

