C $Header$
C $Name$

#include "CPP_OPTIONS.h"

      SUBROUTINE MOM_U_ADV_UU(
     I        bi,bj,k,
     I        uTrans, uFld,
     O        AdvectFluxUU,
     I        myThid)
      IMPLICIT NONE
C
C     Calculate zonal advective flux of U using centered second order diff.
C       - is not vector invariant ...
C

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     == Routine arguments ==
      INTEGER bi,bj,k
      _RL uTrans(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL uFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL AdvectFluxUU(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C     == Local variables ==
      INTEGER I,J

      DO j=1-Oly,sNy+Oly-1
       DO i=1-Olx,sNx+Olx-1
        AdvectFluxUU(i,j) =
     &  0.25*( uTrans(i,j) + uTrans(i+1,j) )
     &      *(   uFld(i,j) +   uFld(i+1,j) )
       ENDDO
      ENDDO

      RETURN
      END
