C $Header$

#include "CPP_OPTIONS.h"

      SUBROUTINE OBCS_INIT( myThid )
C     /==========================================================\
C     | SUBROUTINE OBCS_INIT                                     |
C     | o Initialise OBCs arrays                                 |
C     |==========================================================|
C     |                                                          |
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "OBCS.h"

C     == Routine arguments ==
C     myThid -  Number of this instance of INI_DEPTHS
      INTEGER myThid

#ifdef ALLOW_OBCS

C     == Local variables ==
      INTEGER iG, jG, iGm, jGm
      INTEGER bi, bj
      INTEGER I, J, K
c

      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)

        DO I=1-Olx,sNx+Olx
         OB_Jn(I,bi,bj)=0
         OB_Js(I,bi,bj)=0
        ENDDO

        DO J=1-Oly,sNy+Oly
         OB_Ie(J,bi,bj)=0
         OB_Iw(J,bi,bj)=0
        ENDDO

        DO J=1-Oly,sNy+Oly
         jG = myYGlobalLo-1+(bj-1)*sNy+J
         jGm = 1+mod( jG-1+Ny , Ny )
         DO I=1,sNx
          iG = myXGlobalLo-1+(bi-1)*sNx+I
          iGm = 1+mod( iG-1+Nx , Nx )
          IF (iG.EQ.OB_Ieast(jGm))  OB_Ie(J,bi,bj)=I
          IF (iG.EQ.OB_Iwest(jGm))  OB_Iw(J,bi,bj)=I
         ENDDO
        ENDDO
        DO J=1,sNy
         jG = myYGlobalLo-1+(bj-1)*sNy+J
         jGm = 1+mod( jG-1+Ny , Ny )
         DO I=1-Olx,sNx+Olx
          iG = myXGlobalLo-1+(bi-1)*sNx+I
          iGm = 1+mod( iG-1+Nx , Nx )
          IF (jG.EQ.OB_Jnorth(iGm)) OB_Jn(I,bi,bj)=J
          IF (jG.EQ.OB_Jsouth(iGm)) OB_Js(I,bi,bj)=J
         ENDDO
        ENDDO

        DO K=1,Nr
         DO I=1-Olx,sNx+Olx
          OBNu(I,K,bi,bj)=0.
          OBNv(I,K,bi,bj)=0.
          OBNt(I,K,bi,bj)=0.
          OBSu(I,K,bi,bj)=0.
          OBSv(I,K,bi,bj)=0.
          OBSt(I,K,bi,bj)=0.
#ifdef ALLOW_NONHYDROSTATIC
          OBNw(I,K,bi,bj)=0.
          OBSw(I,K,bi,bj)=0.
#endif
         ENDDO
         DO J=1-Oly,sNy+Oly
          OBEu(J,K,bi,bj)=0.
          OBEv(J,K,bi,bj)=0.
          OBEt(J,K,bi,bj)=0.
          OBWu(J,K,bi,bj)=0.
          OBWv(J,K,bi,bj)=0.
          OBWt(J,K,bi,bj)=0.
#ifdef ALLOW_NONHYDROSTATIC
          OBEw(J,K,bi,bj)=0.
          OBWw(J,K,bi,bj)=0.
#endif
         ENDDO
        ENDDO

       ENDDO
      ENDDO

#endif
      RETURN
      END
