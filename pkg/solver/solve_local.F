C $Header$

#include "CPP_OPTIONS.h"

      subroutine solve_local(
     I                        bi, bj
     I                      , cg2d_b
     U                      , cg2d_x
     I                      , mythid
     &                      )
C     /==========================================================\
C     | SUBROUTINE SOLVE_LOCAL                                   |
C     | by Ralf Giering
C     \==========================================================/
      implicit none

C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"

#include "CG2D.h"
#include "solve_direct.h"

C     === Routine arguments ===
C     myThid - Thread on which I am working.
      integer bi, bj
      _RL     cg2d_b(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL     cg2d_x(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      integer mythid

#ifdef ALLOW_DIRECT_SOLVER
#ifdef ALLOW_USE_MPI

C     === Local variables ====
      integer info
      integer i, j

      double precision rhs(2:sNy,2:sNx)
      double precision sol(2:sNy,2:sNx)

      integer    nloc
      parameter( nloc = (sNx-1)*(sNy-1) )

      _RL    err, rr

C--   build RHS of equations
      do i = 2,sNx
         do j = 2,sNy
            rhs(j,i) = - cg2d_b(i,j,bi,bj)
         end do
      end do
      do i = 2,sNx
         rhs(  2,i) = rhs(  2,i)
     &              + aS2d(i,    2,bi,bj)*cg2d_x(i,    1,bi,bj)
         rhs(sNy,i) = rhs(sNy,i)
     &              + aS2d(i,sNy+1,bi,bj)*cg2d_x(i,sNy+1,bi,bj)
      end do
      do j = 2,sNy
         rhs(j,  2) = rhs(j,  2)
     &              + aW2d(    2,j,bi,bj)*cg2d_x(    1,j,bi,bj)
         rhs(j,sNx) = rhs(j,sNx)
     &              + aW2d(sNx+1,j,bi,bj)*cg2d_x(sNx+1,j,bi,bj)
      end do

      do i = 2,sNx
         do j = 2,sNy
            sol(j,i) = rhs(j,i)
         end do
      end do

      call DPBTRS( 'L', nsolve, kdsolve, 1, solve_band(1,2,2,bi,bj)
     &           , kdsolve+1, sol, nsolve, info )

      if (info .ne. 0) then
         _BEGIN_MASTER( myThid )
         write(0,'(a,i6)') 'SOLVE_LOCAL: DPBTRS info = ', info
         _END_MASTER( )
      end if

      do j = 2,sNy
         do i = 2,sNx
            cg2d_x(i,j,bi,bj) = sol(j,i)
         end do
      end do

C--   check local residuals
#ifdef SOLVE_LOCAL_CHECK
      err    = 0.
      DO j=2,sNy
         DO i=2,sNx
            rr     = cg2d_b(i,j,bi,bj) - (
     &            aW2d(i  ,j  ,bi,bj)*cg2d_x(i-1,j  ,bi,bj)
     &           +aW2d(i+1,j  ,bi,bj)*cg2d_x(i+1,j  ,bi,bj)
     &           +aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j-1,bi,bj)
     &           +aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j+1,bi,bj)
     &           -aW2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aW2d(i+1,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aS2d(i  ,j  ,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -aS2d(i  ,j+1,bi,bj)*cg2d_x(i  ,j  ,bi,bj)
     &           -freeSurfFac*_rA(i,j,bi,bj)*
     &           cg2d_x(i  ,j  ,bi,bj)/deltaTmom/deltaTmom*cg2dNorm
     &           )
            err    = err    + rr*rr
         ENDDO
      ENDDO

      _BEGIN_MASTER( myThid )
      WRITE(0,'(A,x,1PE30.14)') ' SOLVE LOCAL err = ', sqrt(err)
      _END_MASTER( )
#endif

#endif /* ALLOW_USE_MPI */
#endif /* ALLOW_DIRECT_SOLVER */

      end
