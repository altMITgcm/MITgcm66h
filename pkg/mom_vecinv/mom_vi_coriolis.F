C $Header$
C $Name$

#include "CPP_OPTIONS.h"

      SUBROUTINE MOM_VI_CORIOLIS( 
     I        bi,bj,K,
     I        uFld,vFld,omega3,
     O        uCoriolisTerm,vCoriolisTerm,
     I        myThid)
      IMPLICIT NONE
C     /==========================================================\
C     | S/R VORTICITY_X_V                                        |
C     |==========================================================|
C     \==========================================================/

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "GRID.h"
#include "PARAMS.h"

C     == Routine arguments ==
      INTEGER bi,bj,K
      _RL uFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL vFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL omega3(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL uCoriolisTerm(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL vCoriolisTerm(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C     == Local variables ==
      INTEGER I,J
      _RL vBarXY,uBarXY,vort3u,vort3v
      LOGICAL upwindVort3

      upwindVort3=.FALSE.

       DO J=1-Oly,sNy+Oly-1
        DO I=2-Olx,sNx+Olx
c        vBarXY=0.5*(vBarY(I,J,K,bi,bj)+vBarY(I-1,J,K,bi,bj))
         vBarXY=0.25*(vFld( i ,j)+vFld( i ,j+1)
     &               +vFld(i-1,j)+vFld(i-1,j+1))
         IF (upwindVort3) THEN
          IF (vBarXY.GT.0.) THEN
           vort3u=omega3(I,J)
          ELSE
           vort3u=omega3(I,J+1)
          ENDIF
         ELSE
          vort3u=0.5*(omega3(I,J)+omega3(I,J+1))
         ENDIF
         uCoriolisTerm(i,j)=
C high order vorticity advection term
     &   +vort3u*vBarXY
C linear Coriolis term
c    &   +0.5*(fCoriG(I,J,bi,bj)+fCoriG(I,J+1,bi,bj))*vBarXY
C full nonlinear Coriolis term
c    &   +0.5*(omega3(I,J)+omega3(I,J+1))*vBarXY
C correct energy conserving form of Coriolis term
c    &   +0.5*( fCori(I  ,J,bi,bj)*vBarY(I  ,J,K,bi,bj) +
c    &          fCori(I-1,J,bi,bj)*vBarY(I-1,J,K,bi,bj)  )
C original form of Coriolis term (copied from calc_mom_rhs)
c    &   +0.5*(fCori(i,j,bi,bj)+fCori(i-1,j,bi,bj))*vBarXY
     &   *_maskW(I,J,K,bi,bj)
        ENDDO
       ENDDO

       DO J=2-Oly,sNy+Oly
        DO I=1-Olx,sNx+Olx-1
c        uBarXY=0.5*(uBarX(I,J,K,bi,bj)+uBarX(I,J-1,K,bi,bj))
         uBarXY=0.25*( uFld(i, j )+uFld(i+1, j )
     &                +uFld(i,j-1)+uFld(i+1,j-1))
         IF (upwindVort3) THEN
          IF (uBarXY.GT.0.) THEN
           vort3v=omega3(I,J)
          ELSE
           vort3v=omega3(I+1,J)
          ENDIF
         ELSE
          vort3v=0.5*(omega3(I,J)+omega3(I+1,J))
         ENDIF
         vCoriolisTerm(i,j)=
C high order vorticity advection term
     &   -vort3v*uBarXY
C linear Coriolis term
c    &   -0.5 *(fCoriG(I,J,bi,bj)+fCoriG(I+1,J,bi,bj))*uBarXY
C full nonlinear Coriolis term
c    &   -0.5*(omega3(I,J)+omega3(I+1,J))*uBarXY
C correct energy conserving form of Coriolis term
c    &   -0.5 *( fCori(I,J  ,bi,bj)*uBarX(I,J  ,K,bi,bj) +
c    &           fCori(I,J-1,bi,bj)*uBarX(I,J-1,K,bi,bj)  )
C original form of Coriolis term (copied from calc_mom_rhs)
c    &   -0.5*(fCori(i,j,bi,bj)+fCori(i,j-1,bi,bj))*uBarXY
     &   *_maskS(I,J,K,bi,bj)
        ENDDO
       ENDDO


      RETURN
      END
