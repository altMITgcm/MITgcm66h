C $Header$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE INITIALISE_VARIA(myThid)
C     /==========================================================\
C     | SUBROUTINE INITIALISE_VARIA                              |
C     | o Set the initial conditions for dynamics variables      |
C     |   and time dependent arrays                              |
C     |==========================================================|
C     | This routine reads/writes  data from an input file and   |
C     | from various binary files.                               |
C     | Each thread invokes an instance of this routine as does  |
C     | each process in a multi-process parallel environment like|
C     | MPI.                                                     |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     == Routine arguments ==
      INTEGER myThid
CEndOfInterface

C     == Local variables ==
      INTEGER bi,bj,K,iMin,iMax,jMin,jMax

C--   Initialise model fields.
C     Starting values of U, V, W, temp., salt. and tendency terms
C     are set here. Fields are either set to default or read from
C     stored files.
      CALL INI_FIELDS( myThid )
      _BARRIER

C--   Initial conditions are convectively adjusted (for historical reasons)
      IF ( startTime .EQ. 0. ) THEN
        DO bj = myByLo(myThid), myByHi(myThid)
         DO bi = myBxLo(myThid), myBxHi(myThid)
           iMin=1-Olx
           iMax=sNx+Olx
           jMin=1-Oly
           jMax=sNy+Oly
           CALL CONVECTIVE_ADJUSTMENT(
     I       bi, bj, iMin, iMax, jMin, jMax,
     I       startTime, 0, myThid )
         ENDDO
        ENDDO
        _BARRIER
      END IF

C--   Check dependances between packages
      CALL PACKAGES_INIT( myThid )

#ifdef ALLOW_OBCS
C--   Calculate values on open boundaries at iter=nIter0
      IF (openBoundaries) THEN
        DO bj = myByLo(myThid), myByHi(myThid)
         DO bi = myBxLo(myThid), myBxHi(myThid)
          DO K=1,Nr
           CALL SET_OBCS( K, bi, bj, startTime, myThid )
Caja       CALL CYCLE_OBCS( K, bi, bj, myThid )
          ENDDO
         ENDDO
        ENDDO
      ENDIF
#endif

C--   Finally summarise the model state
      CALL STATE_SUMMARY( myThid )

      END
