C--   These common blocks are extracted from the
C--   automatically created tangent linear code.
C--   You need to make sure that they are up-to-date
C--   (i.e. in right order), and customize them
C--   accordingly.
C--
C--   heimbach@mit.edu 11-Jan-2001

      common /addynvars_r/ 
     &                     adetan,
     &                     aduvel, advvel, adwvel, 
     &                     adtheta, adsalt, 
     &                     adgu, adgv, adgt, adgs, 
     &                     adgunm1, adgvnm1, adgtnm1, adgsnm1
      _RL adetan(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adgs(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgsnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgt(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgtnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgu(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgunm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgv(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgvnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adsalt(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adtheta(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL aduvel(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL advvel(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adwvel(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)

cgg      common /addynvars_cd/ 
cgg     &                      aduveld, advveld,
cgg     &                       adetanm1, 
cgg     &                      adunm1, advnm1, 
cgg     &                      adgucd, adgvcd
cgg      _RL aduveld(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cgg      _RL advveld(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cgg      _RL adetanm1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
cgg      _RL adunm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cgg      _RL advnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cgg      _RL adgucd(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cgg      _RL adgvcd(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)

cph      common /adtr1_r/ 
cph     &                 adtr1, adgtr1, adgtr1nm1
cph      _RL adgtr1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cph      _RL adgtr1nm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
cph      _RL adtr1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)

      common /adffields/
     &                   adfu, adfv
     &                 , adqnet, adempmr
cph     &                 , adsst, adsss
      _RL adfu(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adfv(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adqnet(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adempmr(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
cph      _RL adsst(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
cph      _RL adsss(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)

cgg      double precision adobns(1-olx:snx+olx,nr,nsx,nsy)
cgg      double precision adobnt(1-olx:snx+olx,nr,nsx,nsy)
cgg      double precision adobnu(1-olx:snx+olx,nr,nsx,nsy)
cgg      double precision adobnv(1-olx:snx+olx,nr,nsx,nsy)
cg      common /adgrid_n_ob/ adobnu, adobnv, adobnt, adobns








