#include "EXF_CPPOPTIONS.h"



      subroutine exf_init_evap( mythid )

c     ==================================================================
c     SUBROUTINE exf_init_evap
c     ==================================================================
c
c     o 
c
c     started: Ralf.Giering@FastOpt.de 25-Mai-2000
c     changed: heimbach@mit.edu 10-Jan-2002
c
c     ==================================================================
c     SUBROUTINE exf_init_evap
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

#include "exf_param.h"
#include "exf_fields.h"

c     == routine arguments ==

      integer mythid

#if defined(ALLOW_ATM_TEMP) || defined(EXF_READ_EVAP)
c     == local variables ==

      integer bi, bj
      integer i, j

c     == end of interface ==

      do bj = mybylo(mythid), mybyhi(mythid)
        do bi = mybxlo(mythid), mybxhi(mythid)
          do j = 1, sny
            do i = 1, snx
              evap(i,j,bi,bj)  = 0. _d 0
#ifdef EXF_READ_EVAP
              evap0(i,j,bi,bj) = 0. _d 0
              evap1(i,j,bi,bj) = 0. _d 0
#endif
            enddo
          enddo
        enddo
      enddo

#endif

      end
