C $Header$
C $Name$

#include "OBCS_OPTIONS.h"

      SUBROUTINE OBCS_INIT_VARIABLES( myThid )
C     /==========================================================\
C     | SUBROUTINE OBCS_INIT_VARIABLES                           |
C     | o Initialise OBCs variable data                          |
C     |==========================================================|
C     |                                                          |
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "OBCS.h"

C     == Routine arguments ==
C     myThid -  Number of this instance of INI_DEPTHS
      INTEGER myThid

#ifdef ALLOW_OBCS

C     == Local variables ==
      INTEGER bi, bj
      INTEGER I, J, K

      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)

        DO K=1,Nr
         DO I=1-Olx,sNx+Olx
#ifdef ALLOW_OBCS_NORTH
          OBNu(I,K,bi,bj)=0. _d 0
          OBNv(I,K,bi,bj)=0. _d 0
          OBNt(I,K,bi,bj)=0. _d 0
          OBNs(I,K,bi,bj)=0. _d 0
#ifdef ALLOW_NONHYDROSTATIC
          OBNw(I,K,bi,bj)=0. _d 0
#endif
#endif

#ifdef ALLOW_OBCS_SOUTH
          OBSu(I,K,bi,bj)=0. _d 0
          OBSv(I,K,bi,bj)=0. _d 0
          OBSt(I,K,bi,bj)=0. _d 0
          OBSs(I,K,bi,bj)=0. _d 0
#ifdef ALLOW_NONHYDROSTATIC
          OBSw(I,K,bi,bj)=0. _d 0
#endif
#endif
         ENDDO

         DO J=1-Oly,sNy+Oly
#ifdef ALLOW_OBCS_EAST
          OBEu(J,K,bi,bj)=0. _d 0
          OBEv(J,K,bi,bj)=0. _d 0
          OBEt(J,K,bi,bj)=0. _d 0
          OBEs(J,K,bi,bj)=0. _d 0
#ifdef ALLOW_NONHYDROSTATIC
          OBEw(J,K,bi,bj)=0. _d 0
#endif
#endif

#ifdef ALLOW_OBCS_WEST
          OBWu(J,K,bi,bj)=0. _d 0
          OBWv(J,K,bi,bj)=0. _d 0
          OBWt(J,K,bi,bj)=0. _d 0
          OBWs(J,K,bi,bj)=0. _d 0
#ifdef ALLOW_NONHYDROSTATIC
          OBWw(J,K,bi,bj)=0. _d 0
#endif
#endif
         ENDDO
        ENDDO

#ifdef ALLOW_ORLANSKI
        IF (useOrlanskiNorth.OR.useOrlanskiSouth.OR.
     &      useOrlanskiEast.OR.useOrlanskiWest) THEN
          CALL ORLANSKI_INIT(bi, bj, myThid)
        ENDIF
#endif /* ALLOW_ORLANSKI */

       ENDDO
      ENDDO     

#ifdef INCLUDE_EXTERNAL_FORCING_PACKAGE
      CALL EXF_GETOBCS(startTime, nIter0, mythid)
#else
C--   Apply OBCS values to initial conditions for consistancy
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        CALL OBCS_CALC( bi, bj, startTime,
     &        uVel, vVel, wVel, theta, salt, myThid )
       ENDDO
      ENDDO
#endif

      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         CALL OBCS_APPLY_UV( bi, bj, k, uVel, vVel, myThid )
         CALL OBCS_APPLY_TS( bi, bj, k, theta, salt, myThid )
        ENDDO
       ENDDO
      ENDDO

#endif /* ALLOW_OBCS */

      RETURN
      END
