C $Header$
C $Name$

#include "CPP_OPTIONS.h"

      SUBROUTINE MOM_VI_DEL2UV(
     I        bi,bj,k,
     I        hDiv,vort3,hFacZ,
     O        del2u,del2v,
     I        myThid)
      IMPLICIT NONE
C
C     Calculate del^2 of (u,v) in terms of hDiv and vort3
C

C     == Global variables ==
#include "SIZE.h"
#include "GRID.h"

C     == Routine arguments ==
      INTEGER bi,bj,k
      _RL hDiv(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL vort3(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RS hFacZ(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL del2u(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL del2v(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C     == Local variables ==
      INTEGER I,J
      _RL Zip,Zij,Zpj,Dim,Dij,Dmj

C     - Laplacian  and bi-harmonic terms
      DO j=2-Oly,sNy+Oly-1
       DO i=2-Olx,sNx+Olx-1

c       Dim=dyF( i ,j-1,bi,bj)*hFacC( i ,j-1,k,bi,bj)*hDiv( i ,j-1)
c       Dij=dyF( i , j ,bi,bj)*hFacC( i , j ,k,bi,bj)*hDiv( i , j )
c       Dmj=dyF(i-1, j ,bi,bj)*hFacC(i-1, j ,k,bi,bj)*hDiv(i-1, j )
        Dim=dyF( i ,j-1,bi,bj)*                       hDiv( i ,j-1)
        Dij=dyF( i , j ,bi,bj)*                       hDiv( i , j )
        Dmj=dyF(i-1, j ,bi,bj)*                       hDiv(i-1, j )

        Zip=dxV( i ,j+1,bi,bj)*hFacZ( i ,j+1)*vort3( i ,j+1)
        Zij=dxV( i , j ,bi,bj)*hFacZ( i , j )*vort3( i , j )
        Zpj=dxV(i+1, j ,bi,bj)*hFacZ(i+1, j )*vort3(i+1, j )

c       del2u(i,j) = recip_rAw(i,j,bi,bj)*(
c    &   +recip_hFacW(i,j,k,bi,bj)*( Dij-Dmj )
c    &   -recip_hFacW(i,j,k,bi,bj)*( Zip-Zij ) )
        del2u(i,j) = recip_rAw(i,j,bi,bj)*(
     &   +                         ( Dij-Dmj )
     &   -recip_hFacW(i,j,k,bi,bj)*( Zip-Zij ) )

c       del2v(i,j) = recip_rAs(i,j,bi,bj)*(
c    &    recip_hFacS(i,j,k,bi,bj)*( Zpj-Zij )
c    &   +recip_hFacS(i,j,k,bi,bj)*( Dij-Dim ) )
        del2v(i,j) = recip_rAs(i,j,bi,bj)*(
     &    recip_hFacS(i,j,k,bi,bj)*( Zpj-Zij )
     &   +                         ( Dij-Dim ) )

       ENDDO
      ENDDO

      RETURN
      END
