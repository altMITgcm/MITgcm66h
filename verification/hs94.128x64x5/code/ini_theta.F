C $Header$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE INI_THETA( myThid )
C     /==========================================================\
C     | SUBROUTINE INI_THETA                                     |
C     | o Set model initial temperature field.                   |
C     |==========================================================|
C     | There are several options for setting the initial        |
C     | temperature file                                         |
C     |  1. Inline code                                          |
C     |  2. Vertical profile ( uniform T in X and Y )            |
C     |  3. Three-dimensional data from a file. For example from |
C     |     Levitus or from a checkpoint file from a previous    |
C     |     integration.                                         |
C     | In addition to setting the temperature field we also     |
C     | set the initial temperature tendency term here.          |
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"

C     == Routine arguments ==
C     myThid -  Number of this instance of INI_THETA
      INTEGER myThid
CEndOfInterface

C     == Local variables ==
C     iC, jC - Center of domain
C     iD, jD - Disitance from domain center.
C     rad    - Radius of initial patch
C     rD     - Radial displacement of point I,J
C     iG, jG - Global coordinate index
C     bi,bj  - Loop counters
C     I,J,K
      INTEGER iC, jC, iD, jD
      INTEGER iG, jG
      INTEGER bi, bj
      INTEGER I, J, K
      _RL     term1,term2,thetaLim,thetaEq
      _RL     thKappa,p0,phi,rSurf

      _BARRIER

      J = 99+myBxLo(myThid)+nPx*myByLo(myThid)
      CALL SRAND( J )

      IF ( hydrogThetaFile .EQ. ' ' ) THEN
C--    Initialise temperature field to Held & Saurez equilibrium theta
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO K=1,Nr
          rSurf=1.E5
          thKappa = 2./7.
          thetaLim = 200. / ((rC(K)/rSurf)**thKappa)
          DO J=1,sNy
           term1=60.*(sin(yC(1,J,bi,bj)*deg2rad)**2)
           term2=10.*log((rC(K)/rSurf))
     &              *(cos(yC(1,J,bi,bj)*deg2rad)**2)
           thetaEq=315.-term1-term2
           DO I=1,sNx
            theta(I,J,K,bi,bj) = MAX( thetaLim, thetaEq )
     &                          + 0.01*(RAND()-0.5)
C           theta(I,J,K,bi,bj) = tRef(K)
           ENDDO
          ENDDO
         ENDDO
        ENDDO
       ENDDO
       CALL WRITE_FLD_XYZ_RL( 'T1.',' ',theta,0,myThid)
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO K=1,Nr
          DO J=1,sNy
#ifdef ALLOW_ZONAL_FILT
C--   Zonal FFT filter initial conditions
           CALL ZONAL_FILTER(
     U      theta, hFacC,
     I      1, sNy, k, k, bi, bj, 1, myThid)
#endif /* INCLUDE_LAT_CIRC_FFT_FILTER_CODE */
          ENDDO
         ENDDO
        ENDDO
       ENDDO
       CALL WRITE_FLD_XYZ_RL( 'T2.',' ',theta,0,myThid)
      ELSE
       _BEGIN_MASTER( myThid )
       CALL READ_FLD_XYZ_RL( hydrogThetaFile, ' ', theta, 0, myThid )
       _END_MASTER(myThid)
      ENDIF
C     Set initial tendency terms
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         DO J=1,sNy
          DO I=1,sNx
           gt   (I,J,K,bi,bj) = 0. _d 0
           gtNM1(I,J,K,bi,bj) = 0. _d 0
           IF (hFacC(I,J,K,bi,bj).EQ.0.) theta(I,J,K,bi,bj) = 0.
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO
C


      _EXCH_XYZ_R8(theta , myThid )
      _EXCH_XYZ_R8(gt , myThid )
      _EXCH_XYZ_R8(gtNM1 , myThid )

      CALL PLOT_FIELD_XYZRL( theta, 'Initial Temperature' , 
     &                       Nr, 1, myThid )

      RETURN
      END
