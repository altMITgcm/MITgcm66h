C $Header$

#include "CPP_OPTIONS.h"

      SUBROUTINE OBCS_CALC( bi, bj, K, futureTime, myThid )
C     /==========================================================\
C     | SUBROUTINE OBCS_CALC                                     |
C     | o Calculate future boundary data at open boundaries      |
C     |   at time = futureTime                                   |
C     |==========================================================|
C     |                                                          |
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "OBCS.h"
#include "DYNVARS.h"

C     == Routine arguments ==
      INTEGER bi, bj, K
      _RL futureTime
      INTEGER myThid

#ifdef ALLOW_OBCS

C     == Local variables ==
      INTEGER I,J
      _RL obTimeScale,Uinflow
c
      obTimeScale = 2000.0
      Uinflow = 0.25

      DO J=1-Oly,sNy+Oly
       OBEu(J,K,bi,bj)=Uinflow
c    &       *sin(2.*PI*myCurrentTime/obTimeScale)
c    &       *max(myCurrentTime/obTimeScale,1.)
       OBEv(J,K,bi,bj)=0.
       OBEt(J,K,bi,bj)=tRef(K)
       OBWu(J,K,bi,bj)=Uinflow
c    &       *sin(2.*PI*myCurrentTime/obTimeScale)
c    &       *max(myCurrentTime/obTimeScale,1.)
       OBWv(J,K,bi,bj)=0.
       OBWt(J,K,bi,bj)=tRef(K)
      ENDDO
      DO I=1-Olx,sNx+Olx
       OBNu(I,K,bi,bj)=Uinflow
       OBNv(I,K,bi,bj)=0.
       OBNt(I,K,bi,bj)=tRef(K)
       OBSu(I,K,bi,bj)=Uinflow
       OBSv(I,K,bi,bj)=0.
       OBSt(I,K,bi,bj)=tRef(K)
      ENDDO

#endif
      RETURN
      END
