
#include "EXF_CPPOPTIONS.h"

CStartOfInterface
      SUBROUTINE EXF_DIAGS( myTime, myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE EXF_DIAGS                                  |
C     | o Do EXF diagnostic output                           |
C     |==========================================================|
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "exf_fields.h"
#include "exf_diag.h" 

C     == Routine arguments ==
C     myTime - Current time of simulation ( s )
C     myIter - Iteration number
C     myThid -  Number of this instance 
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
#ifdef ALLOW_BULKFORMULAE

CEndOfInterface


C     == Local variables ==
      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE
      INTEGER bi, bj
      CHARACTER*(MAX_LEN_MBUF) suff
      INTEGER I,J


       WRITE(suff,'(I10.10)') myIter
C     Dump snap shots
      IF ( DIFFERENT_MULTIPLE(dumpFreq,myTime,myTime-deltaTClock)
     &     ) THEN

C      Dump shap-shots of fields
       _BEGIN_MASTER(myThid)
       CALL WRITE_FLD_XY_RL('EXF_hflux.',suff,hflux,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_sflux.',suff,sflux,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_evap.',suff, evap,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_precip.',suff,precip,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_hs.',suff,hs,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_hl.',suff,hl,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_lwflux.',suff,lwflux,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_swflux.',suff,swflux,
     &     myIter,myThid)
       _END_MASTER(myThid)

       ENDIF

#ifdef ALLOW_EXF_TIMEAVE
C     Dump files and restart average computation if needed
      IF ( DIFFERENT_MULTIPLE(taveFreq,myTime,myTime-deltaTClock)
     &     ) THEN


C      Normalize by integrated time
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_NORMALIZ(EXF_Qnet_AVE,EXF_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(EXF_EmPmR_AVE,EXF_timeave, 1 ,
     &                 bi,bj,myThid)
        ENDDO
       ENDDO
         

       _BEGIN_MASTER(myThid)

       CALL WRITE_FLD_XY_RL('EXF_QnetTave.',suff,EXF_Qnet_AVE,
     &     myIter,myThid)
       CALL WRITE_FLD_XY_RL('EXF_EmPmRTave.',suff,
     &     EXF_EmPmR_AVE,myIter,myThid)
       _END_MASTER(myThid)


C      Reset averages to zero
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_RESET(EXF_Qnet_AVE,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(EXF_EmPmR_AVE,1,bi,bj,myThid)
        ENDDO
       ENDDO

      ENDIF
#endif /* ALLOW_TIMEAVE */
#endif /* ALLOW_EXF */
      
      RETURN
      END
