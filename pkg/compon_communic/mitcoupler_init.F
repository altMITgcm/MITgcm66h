C $Header$
C $Name$

!=======================================================================
      subroutine MITCOUPLER_init( myTypeStr, MPI_COMM_local )
      implicit none

! MPI variables
#include "mpif.h"

! Predefined constants/arrays
#include "CPLR_SIG.h"

! Arguments
      character*(*) myTypeStr
      integer MPI_COMM_local

! Functions

! Local
      logical couplerFlag

!     ------------------------------------------------------------------

! Homogeneous registration phase (every process Bcasts)
      couplerFlag=.TRUE.
      call MITCPLR_init1( myTypeStr, couplerFlag )

! Return the communicator for my component
      MPI_COMM_local = MPI_COMM_mylocal

! Heterogeneous registration phase (within component incl. coupler)
      call mitcplr_init2b( myTypeStr )

!     ------------------------------------------------------------------
      return
      end
!=======================================================================
