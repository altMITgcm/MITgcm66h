C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine optim_Summary(
     I                          mythid
     &                        )

c     ==================================================================
c     SUBROUTINE optim_Summary
c     ==================================================================
c
c     o Summarize the optimization setup.
c
c     started: Christian Eckert eckert@mit.edu 06-Mar-2000
c
c     changed: 
c
c     ==================================================================
c     SUBROUTINE optim_Summary
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"

#include "ecco.h"
#include "optim.h"

c     == routine arguments ==

      integer mythid 

c     == local variables ==

      character*(max_len_mbuf) msgbuf

c     == end of interface ==

      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// Optimization configuration  >>> START <<<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,a)')
     &'   Optimization version: ',offlineversion
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,a)')
     &'          lsopt version: ',lsoptversion
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

      write(msgbuf,'(a,a)')
     &'   Experiment Id:                       ',expid
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i10)')
     &'   Optimization cycle:                  ',optimcycle
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i10)')
     &'   No. of control variables:            ',nvars
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i10)')
     &'   No. of iterations per call:          ',numiter
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i10)')
     &'   No. of function calls per iteration: ',nfunc
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i10)')
     &'   Printing level (iprint):             ',iprint
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,i10)')
     &'   No. of update pairs:                 ',nupdate
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,e10.3)')
     &'   First guess for minimum:             ',fmin
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,e10.3)')
     &'   Precision on control vector:         ',epsx
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,e10.3)')
     &'   Precision on gradient:               ',epsg
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

      if (nondimcontrol) then
        write(msgbuf,'(a,a)')
     &  '   Non-dimensional control vector?    ','   Yes.'
      else
        write(msgbuf,'(a,a)')
     &  '   Non-dimensional control vector?    ','   No.'
      endif
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// Optimization configuration  >>> END <<<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

      return
      end

