C $Header$

#include "COST_CPPOPTIONS.h"


      subroutine cost_Final(
     I                       mythid
     &                     )

c     ==================================================================
c     SUBROUTINE cost_Final
c     ==================================================================
c
c     o Sum of all cost function contributions.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu 25-Feb-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c     ==================================================================
c     SUBROUTINE cost_Final
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

#include "cost.h"
#include "ctrl.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer bi,bj
      integer itlo,ithi
      integer jtlo,jthi

      character*(MAX_LEN_MBUF) msgbuf

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)

#ifdef ECCO_VERBOSE
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &  ' cost_Final: Evaluating the final cost function.'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif

c--   Sum up all contributions.
      do bj = jtlo,jthi
        do bi = itlo,ithi

          print*,' --> objf_temp(bi,bj)    =',objf_temp(bi,bj)
          print*,' --> objf_salt(bi,bj)    =',objf_salt(bi,bj)
          print*,' --> objf_sst(bi,bj)     =',objf_sst(bi,bj)
          print*,' --> objf_sss(bi,bj)     =',objf_sss(bi,bj)
          print*,' --> objf_h(bi,bj)       =',objf_h(bi,bj)
          print*,' --> objf_hmean          =',objf_hmean
          print*,' --> objf_tauu(bi,bj)    =',objf_tauu(bi,bj)
          print*,' --> objf_tauv(bi,bj)    =',objf_tauv(bi,bj)
          print*,' --> objf_hflux(bi,bj)   =',objf_hflux(bi,bj)
          print*,' --> objf_sflux(bi,bj)   =',objf_sflux(bi,bj)
          print*,' --> objf_atl(bi,bj)     =',objf_atl(bi,bj)
          print*,' --> objf_ctdt(bi,bj)    =',objf_ctdt(bi,bj)
          print*,' --> objf_ctds(bi,bj)    =',objf_ctds(bi,bj)
          print*,' --> objf_uwind(bi,bj)   =',objf_uwind(bi,bj)
          print*,' --> objf_vwind(bi,bj)   =',objf_vwind(bi,bj)
          print*,' --> objf_atemp(bi,bj)   =',objf_atemp(bi,bj)
          print*,' --> objf_aqh(bi,bj)     =',objf_aqh(bi,bj)
          print*,' --> objf_obcsn(bi,bj)   =',objf_obcsn(bi,bj)
          print*,' --> objf_obcss(bi,bj)   =',objf_obcss(bi,bj)
          print*,' --> objf_obcsw(bi,bj)   =',objf_obcsw(bi,bj)
          print*,' --> objf_obcse(bi,bj)   =',objf_obcse(bi,bj)

          fc = fc
     &            + mult_temp    * objf_temp(bi,bj)
     &            + mult_salt    * objf_salt(bi,bj)
     &            + mult_sst     * objf_sst(bi,bj) 
     &            + mult_sss     * objf_sss(bi,bj) 
     &            + mult_tauu    * objf_tauu(bi,bj)
     &            + mult_tauv    * objf_tauv(bi,bj)
     &            + mult_hflux   * objf_hflux(bi,bj)  
     &            + mult_sflux   * objf_sflux(bi,bj)  
     &            + mult_h       * objf_h(bi,bj)
     &            + mult_atl     * objf_atl(bi,bj)
     &            + mult_ctdt    * objf_ctdt(bi,bj)
     &            + mult_ctds    * objf_ctds(bi,bj)
     &            + mult_uwind   * objf_uwind(bi,bj)
     &            + mult_vwind   * objf_vwind(bi,bj)
     &            + mult_atemp   * objf_atemp(bi,bj)  
     &            + mult_aqh     * objf_aqh(bi,bj)  
     &            + mult_obcsn   * objf_obcsn(bi,bj)  
     &            + mult_obcss   * objf_obcss(bi,bj)  
     &            + mult_obcsw   * objf_obcsw(bi,bj)  
     &            + mult_obcse   * objf_obcse(bi,bj)  
        enddo
      enddo


c--   Do global summation.
      _GLOBAL_SUM_R8( fc , myThid )

c--   Each process has calculated the global part for itself.
      _BEGIN_MASTER( mythid )
        fc = fc + mult_hmean*objf_hmean
      _END_MASTER( mythid )

      print *, ' --> fc               =', fc

#ifdef ECCO_VERBOSE
      write(msgbuf,'(a,D22.15)')
     &  ' cost_Final: final cost function = ',fc
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &  '             cost function evaluation finished.'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif

      end
