C $Header: /u/gcmpack/MITgcm/pkg/kl10/kl10_readparms.F,v 1.1 2014/07/30 03:28:05 jmc Exp $
C $Name: checkpoint66d $

#include "NF90IO_OPTIONS.h"

CBOP
C !ROUTINE: NF90IO_READPARMS

C =====================================================
C !!!!  NOT IMPLIMENTED   !!!!
C
C As it stands, this routine is not called or needed.  All NF90IO is done
C via the diagnostics package.  i.e. see 
C      pkg/diagnostics/diagnostics_nf90io_out.F
C
C  This call would go in model/src/packages_readparms.F
C ======================================================


C !INTERFACE: ==========================================================
      SUBROUTINE NF90IO_READPARMS( myThid )

C !DESCRIPTION:
C     Initialize KL10 parameters, read in data.kl10

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "NF90IO.h"
#include "PARAMS.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================
C  none

#ifdef ALLOW_NF90IO

C !LOCAL VARIABLES: ====================================================
C  iUnit                :: unit number for I/O
C  msgBuf               :: message buffer
      INTEGER iUnit
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      NAMELIST /NF90IO_PARM01/
     &     NF90ioFilename,
     &     NF90ioAppend

      IF ( .NOT.useNF90IO ) THEN
C-    pkg nf90io is not used
        _BEGIN_MASTER(myThid)
C-    Track pkg activation status:
         NF90ioisON = .FALSE.
C     print a (weak) warning if data.nf90io is found
         CALL PACKAGES_UNUSED_MSG( 'NF90IO', ' ', ' ' )
        _END_MASTER(myThid)
        RETURN
      ENDIF

      _BEGIN_MASTER(myThid)

C This routine has been called by the main model so we set our
C internal flag to indicate we are in business
      NF90ioisON = .TRUE.

C Set defaults values for parameters in KL10.h
      NF90ioFilename  = "ModelOut.nc"
      NF90ioAppend    = .FALSE.
C Open and read the data.nf90io file
      WRITE(msgBuf,'(A)') ' NF90IO_READPARMS: opening data.nf90io'
      CALL PRINT_MESSAGE(msgBuf, standardMessageUnit,
     &                   SQUEEZE_RIGHT , 1)
      CALL OPEN_COPY_DATA_FILE(
     I                   'data.nf90io', 'NF90IO_READPARMS',
     O                   iUnit,
     I                   myThid )
      READ(UNIT=iUnit,NML=NF90IO_PARM01)
      WRITE(msgBuf,'(A)')
     &  ' NF90IO_READPARMS: finished reading data.nf90io'
      CALL PRINT_MESSAGE(msgBuf, standardMessageUnit,
     &                   SQUEEZE_RIGHT , 1)

C Close the open data file
      CLOSE(iUnit)
      _END_MASTER(myThid)

C Everyone else must wait for the parameters to be loaded
      _BARRIER

C Now set-up any remaining parameters that result from the input parameters
      IF ( NF90ioAppend) THEN
       WRITE(msgBuf,'(A)') 'NF90ioAppend not implimented yet.  Soon!'
       CALL PRINT_ERROR( msgBuf , 1)
       STOP 'ABNORMAL END: S/R NF90IO_READPARMS'
      ENDIF
#endif /* ALLOW_KL10 */

      RETURN
      END
