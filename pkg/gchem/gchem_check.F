C $Header$
C $Name$

#include "GCHEM_OPTIONS.h"

      SUBROUTINE GCHEM_CHECK( myThid )
C     /==========================================================\
C     | SUBROUTINE GCHEM_CHECK                                   |
C     | o Validate basic package setup and inter-package         |
C     | dependencies.                                            |
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GCHEM.h"

C     === Routine arguments ===
C     myThid -  Number of this instance
      INTEGER myThid

#ifdef ALLOW_GCHEM

C     === Local variables ===
C     msgBuf      - Informational/error meesage buffer
      CHARACTER*(MAX_LEN_MBUF) msgBuf

      _BEGIN_MASTER(myThid)

      WRITE(msgBuf,'(A)') 'GCHEM_CHECK: #define ALLOW_GCHEM'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &     SQUEEZE_RIGHT , myThid )

C     GCHEM needs passive tracer package
      IF ( .NOT.usePTRACERS) THEN
         WRITE(msgBuf,'(A)') 'usePTRACERS has to be .TRUE. for GCHEM'
         CALL PRINT_ERROR( msgBuf , myThid )
         STOP 'ABNORMAL END: S/R GCHEM_CHECK'
      ENDIF

C     GCHEM cannot (yet!) run cfc and dic together
      IF ( useDIC .AND. useCFC ) THEN
         WRITE(msgBuf,'(A)') 'useDIC and useCFC cannot both be .TRUE.'
         CALL PRINT_ERROR( msgBuf , myThid )
         STOP 'ABNORMAL END: S/R GCHEM_CHECK'
      ENDIF

      _END_MASTER(myThid)

#endif /* ALLOW_GCHEM */

      RETURN
      END
