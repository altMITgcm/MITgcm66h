C $Header$

#include "CPP_OPTIONS.h"

      SUBROUTINE CALC_PHI_HYD(
     I                         bi, bj, iMin, iMax, jMin, jMax, K,
     I                         theta, salt,
     U                         phiHyd, phiHydInterface,
     I                         myThid)
C     /==========================================================\
C     | SUBROUTINE CALC_PHI_HYD                                  |
C     | o Integrate the hydrostatic relation to find phiHyd.     |
C     |                                                          |
C     | On entry:                                                |
C     |   theta,salt    are the current thermodynamics quantities|
C     |                 (unchanged on exit)                      |
C     |   phiHyd(i,j,1:k-1) is the hydrostatic pressure/geopot.  |
C     |                 at cell centers (tracer points)          |
C     |                 - 1:k-1 layers are valid                 |
C     |                 - k:Nr layers are invalid                |
C     |   phiHydInterface(i,j) is the hydrostatic pressure/geop. |
C     |                 at cell the interface k (w point above)  |
C     | On exit:                                                 |
C     |   phiHyd(i,j,1:k) is the hydrostatic pressure/geopot.    |
C     |                 at cell centers (tracer points)          |
C     |                 - 1:k layers are valid                   |
C     |                 - k+1:Nr layers are invalid              |
C     |   phiHydInterface(i,j) is the hydrostatic pressure/geop. |
C     |                 at cell the interface k+1 (w point below)|
C     |                                                          |
C     \==========================================================/
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "GRID.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
C     == Routine arguments ==
      INTEGER bi,bj,iMin,iMax,jMin,jMax,K
      _RL theta(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL salt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL phiHyd(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      _RL phiHydInterface(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

#ifdef INCLUDE_PHIHYD_CALCULATION_CODE

C     == Local variables ==
      INTEGER i,j
      _RL alphaRho(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL dRloc,dRlocKp1
      _RL ddRm1, ddRp1, ddRm, ddRp
      _RL atm_cp, atm_kappa, atm_po

      IF ( buoyancyRelation .eq. 'OCEANIC' ) THEN

        dRloc=drC(k)
        IF (k.EQ.1) dRloc=drF(1)
        IF (k.EQ.Nr) THEN
          dRlocKp1=0.
        ELSE
          dRlocKp1=drC(k+1)
        ENDIF

C--     If this is the top layer we impose the boundary condition
C       P(z=eta) = P(atmospheric_loading)
        IF (k.EQ.1) THEN
          DO j=jMin,jMax
            DO i=iMin,iMax
C             *NOTE* The loading should go here but has not been implemented yet
              phiHydInterface(i,j)=0.
              phiHyd(i,j,k)=0.
            ENDDO
          ENDDO
        ENDIF

C       Calculate density
        CALL FIND_RHO( bi, bj, iMin, iMax, jMin, jMax, k, k, eosType,
     &                 theta, salt,
     &                 alphaRho, myThid)

C       Hydrostatic pressure at cell centers
        DO j=jMin,jMax
          DO i=iMin,iMax
#ifdef ALLOW_AUTODIFF_TAMC
          Is this directive correct or even necessary in this new code?
CADJ GENERAL
#endif
C           This discretization is the "finite volume" form
C           which has not been used to date since it does not
C           conserve KE+PE exactly even though it is more natural
C
C           phiHyd(i,j,k)=phiHydInterface(i,j)+
C    &          0.5*drF(K)*gravity*alphaRho(i,j)
C
C           This discretization is the "energy conserving" form
C           which has been used since at least Adcroft et al., MWR 1997
C
            phiHyd(i,j,k)=phiHyd(i,j,k)+
     &          0.5*dRloc*gravity*alphaRho(i,j)
            phiHyd(i,j,k+1)=phiHyd(i,j,k)+
     &          0.5*dRlocKp1*gravity*alphaRho(i,j)
          ENDDO
        ENDDO
        
C       Hydrostatic pressure at interface below
        DO j=jMin,jMax
          DO i=iMin,iMax
            phiHydInterface(i,j)=phiHydInterface(i,j)+
     &              drF(K)*gravity*alphaRho(i,j)
          ENDDO
        ENDDO

      ELSEIF ( buoyancyRelation .eq. 'ATMOSPHERIC' ) THEN

        atm_cp=1004. _d 0
        atm_kappa=2. _d 0/7. _d 0
        atm_po=1. _d 5
        IF (K.EQ.1) THEN
C       Integrate d Phi / d R
          ddRp1=atm_cp*( ((rC(K)/atm_po)**atm_kappa)
     &                  -((rF(K)/atm_po)**atm_kappa) )
          DO j=jMin,jMax
           DO i=iMin,iMax
             ddRp=ddRp1
             IF (hFacC(I,J, K ,bi,bj).EQ.0.) ddRp=0.
             phiHyd(i,j,K)=0.
     &          -ddRp*(theta(I,J,K,bi,bj)-tRef(K))
           ENDDO
          ENDDO
        ELSE
C       Integrate d Phi / d R
          ddRp1=atm_cp*( ((rC( K )/atm_po)**atm_kappa)
     &                  -((rF( K )/atm_po)**atm_kappa) )
          ddRm1=atm_cp*( ((rF( K )/atm_po)**atm_kappa)
     &                  -((rC(K-1)/atm_po)**atm_kappa) )
          DO j=jMin,jMax
           DO i=iMin,iMax
             ddRp=ddRp1
             ddRm=ddRm1
             IF (hFacC(I,J, K ,bi,bj).EQ.0.) ddRp=0.
             IF (hFacC(I,J,K-1,bi,bj).EQ.0.) ddRm=0.
             phiHyd(i,j,K)=phiHyd(i,j,K-1)
     &          -( ddRm*(theta(I,J,K-1,bi,bj)-tRef(K-1))
     &            +ddRp*(theta(I,J, K ,bi,bj)-tRef( K )) )
           ENDDO
          ENDDO
        ENDIF
                                                                                        
      ELSE
        STOP 'CALC_PHI_HYD: We should never reach this point!'
      ENDIF

#endif

      return
      end
