C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_final_store ( mythid )

c     ==================================================================
c     SUBROUTINE cost_Final
c     ==================================================================
c
c     ==================================================================
c     SUBROUTINE cost_Final
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

#include "cost.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

c     == end of interface ==

c--   Each process has calculated the global part for itself.
      IF (myProcId .eq. 0) THEN
         _BEGIN_MASTER( mythid )    
           open(unit=76,file='costfinal')
           write(76,*) fc        
           close(76)
         _END_MASTER( mythid )
      ENDIF
      _BARRIER

      end
