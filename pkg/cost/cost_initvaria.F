C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_InitVaria(
     I                           mythid
     &                         )

c     ==================================================================
c     SUBROUTINE cost_InitVaria
c     ==================================================================
c
c     o Initialise the variable cost function part.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 18-Apr-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     SUBROUTINE cost_InitVaria
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"

#include "cost.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer bi,bj
      integer itlo,ithi
      integer jtlo,jthi
      integer imin, imax
      integer jmin, jmax
      integer i,j,k

c     == external functions ==

c     == end of interface ==
      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1-OLy
      jmax = sny+OLy
      imin = 1-OLx
      imax = snx+OLy

c--   Initialize the tiled cost function contributions.
      do bj = jtlo,jthi
        do bi = itlo,ithi
          objf_hflux(bi,bj)   = 0. _d 0
          objf_sflux(bi,bj)   = 0. _d 0
          objf_tauu(bi,bj)    = 0. _d 0
          objf_tauv(bi,bj)    = 0. _d 0
          objf_temp(bi,bj)    = 0. _d 0
          objf_salt(bi,bj)    = 0. _d 0
          objf_sst(bi,bj)     = 0. _d 0
          objf_h(bi,bj)       = 0. _d 0
          objf_atl(bi,bj)     = 0. _d 0
          objf_ctdt(bi,bj)    = 0. _d 0
          objf_ctds(bi,bj)    = 0. _d 0
          objf_atemp(bi,bj)   = 0. _d 0
          objf_aqh(bi,bj)     = 0. _d 0
          objf_uwind(bi,bj)   = 0. _d 0
          objf_vwind(bi,bj)   = 0. _d 0
          objf_obcsn(bi,bj)   = 0. _d 0
          objf_obcss(bi,bj)   = 0. _d 0
          objf_obcsw(bi,bj)   = 0. _d 0
          objf_obcse(bi,bj)   = 0. _d 0
        enddo
      enddo

      k = 1
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
#ifdef ALLOW_SSH_COST_CONTRIBUTION
               if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                  tpmeanmask(i,j,bi,bj) = 0. _d 0
               else
                  tpmeanmask(i,j,bi,bj) = 1. _d 0
               endif
               tpmean(i,j,bi,bj)     = 0. _d 0
#endif
#ifdef ALLOW_SSH_TPANOM_COST_CONTRIBUTION
               if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                  tpmask(i,j,bi,bj) = 0. _d 0
               else
                  tpmask(i,j,bi,bj) = 1. _d 0
               endif
               tpobs(i,j,bi,bj)      = 0. _d 0
#endif
#ifdef ALLOW_SSH_ERSANOM_COST_CONTRIBUTION
               if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                  ersmask(i,j,bi,bj) = 0. _d 0
               else
                  ersmask(i,j,bi,bj) = 1. _d 0
               endif
               ersobs(i,j,bi,bj)     = 0. _d 0
#endif
#ifdef ALLOW_SST_COST_CONTRIBUTION
               if (_hFacC(i,j,k,bi,bj) .eq. 0.) then
                  sstmask(i,j,bi,bj) = 0. _d 0
               else
                  sstmask(i,j,bi,bj) = 1. _d 0
               endif
               sstdat(i,j,bi,bj)     = 0. _d 0
#endif
            enddo
          enddo
        enddo
      enddo

c--   Initialise the "global" parts of the cost function.
      _BEGIN_MASTER( mythid )
        objf_hmean = 0. _d 0
        fc         = 0. _d 0
      _END_MASTER( mythid )

      _BARRIER

      return
      end

