C $Header$
C $Name$

#include "CPP_OPTIONS.h"

      SUBROUTINE CALC_EXACT_ETA( bi,bj, etaStar, phiSurfX,phiSurfY,
     I                           myTime, myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE CALC_EXACT_ETA                                |
C     | o Compute again the surface "r-anomaly" (eta) to satisfy |
C     |   exactly the convervation of the Total Volume           |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
#include "SURFACE.h"

C     == Routine arguments ==
C     bi,bj   - tile index
C     etaStar - Div. Barotropic Flow at time_step N
C     phiSurfX, phiSurfY - Gradient in the X and Y directions of surface
C       Potentiel anomaly (atmos: =Geopotential ; ocean: =Pressure/rho)
C     myTime - Current time in simulation
C     myIter - Current iteration number in simulation
C     myThid - Thread number for this instance of the routine.
      _RL myTime
      INTEGER myIter
      INTEGER myThid
      INTEGER bi,bj
      _RL etaStar(1-Olx:sNx+Olx,1-Oly:sNy+Oly,nSx,nSy)
      _RL phiSurfX(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL phiSurfY(1-Olx:sNx+Olx,1-Oly:sNy+Oly) 

#ifdef EXACT_CONSERV
C     Local variables
      INTEGER i,j
      _RS uf(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RS vf(1-Olx:sNx+Olx,1-Oly:sNy+Oly)

C-D_bug:
cDbug _RL eta_tmp, difmax
cDbug difmax = 0.

C--   Add the contribution of grad_phi_Surf to Div.(u,v)

C-    compute column side height :
      IF (nonlinFreeSurf) THEN 
        DO j=1,sNy+1
         DO i=1,sNx+1
          uf(i,j)= min(Ro_surf(i,j,bi,bj) + etaNm1(i,j,bi,bj),
     &                 Ro_surf(i-1,j,bi,bj)+etaNm1(i-1,j,bi,bj))
     &           - max(R_low(i,j,bi,bj),R_low(i-1,j,bi,bj))
          vf(i,j)= min(Ro_surf(i,j,bi,bj) + etaNm1(i,j,bi,bj),
     &                 Ro_surf(i,j-1,bi,bj)+etaNm1(i,j-1,bi,bj))
     &           - max(R_low(i,j,bi,bj),R_low(i,j-1,bi,bj))
         ENDDO
        ENDDO
      ELSE
        DO j=1,sNy+1
         DO i=1,sNx+1
          uf(i,j)= min(Ro_surf(i,j,bi,bj) - R_low(i,j,bi,bj),
     &                 Ro_surf(i-1,j,bi,bj)-R_low(i-1,j,bi,bj) )
          vf(i,j)= min(Ro_surf(i,j,bi,bj) - R_low(i,j,bi,bj),
     &                 Ro_surf(i,j-1,bi,bj)-R_low(i,j-1,bi,bj) )
         ENDDO
        ENDDO
      ENDIF
C-    compute flux driven by Phi_surf gradient :
      DO j=1,sNy+1
       DO i=1,sNx+1
         uf(i,j)= implicSurfPress*phiSurfX(i,j)
     &          * _dyG(i,j,bi,bj)*uf(i,j)
         vf(i,j)= implicSurfPress*phiSurfY(i,j)
     &          * _dxG(i,j,bi,bj)*vf(i,j)
       ENDDO
      ENDDO
C-    compute the Divergence and update etaN :
      DO j=1,sNy
       DO i=1,sNx
cDbug    eta_tmp = etaN(i,j,bi,bj) 
         etaN(i,j,bi,bj) =
     &       ( etaStar(i,j,bi,bj) + (uf(i+1,j) - uf(i,j))
     &                            + (vf(i,j+1) - vf(i,j))
     &         )*deltaTMom*deltaTMom*recip_rA(i,j,bi,bj)
cDbug    difmax = max( difmax, abs(etaN(i,j,bi,bj)-eta_tmp) )
       ENDDO
      ENDDO
c--
cDbug write(0,'(A,I6,1P2E16.8)') 'EXACT_conserv:', myIter,difmax

#endif /* EXACT_CONSERV */

      RETURN
      END
