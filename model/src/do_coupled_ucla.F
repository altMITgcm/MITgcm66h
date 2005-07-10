C Atmospheric land mask appears to be shifted westward by 1 degree.
C As a quick fix, rather than fix the atmospheric landmask, shift
C the oceanic grid definition one degree westward.
#define SHIFT_MASK

C************************************************************************
C************************************************************************

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: DO_COUPLED_UCLA
C     !INTERFACE:
      SUBROUTINE DO_COUPLED_UCLA( myTime, myIter, myThid )

C     !DESCRIPTION: \bv
C     *==================================================================
C     | SUBROUTINE do_coupled_ucla
C     | o Couple MIT ocean model with UCLA atmosphere model
C     |   - Initialize UCLA AGCM-OGCM interface
C     |   - Transfer SST to UCLA atmosphere model
C     |   - Get surface forcing fields from the UCLA atmosphere model
C     *==================================================================
C     | When myTime = startTime + ...
C     | 0.0 * coupling_dt: send ocean grid information to coupler
C     |                    get coupling interval from coupler
C     |                    send SST to coupler
C     |                    get surface fluxes from coupler
C     | 0.5 * coupling_dt: send SST to coupler
C     | 1.0 * coupling_dt: get surface fluxes from coupler
C     | 1.5 * coupling_dt: send SST to coupler
C     | 2.0 * coupling_dt: get surface fluxes from coupler
C     | ...
C     *==================================================================
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "FFIELDS.h"
#include "GRID.h"
      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE

C     !LOCAL VARIABLES:
C     == Routine arguments ==
C     note: under the multi-threaded model myiter and 
C           mytime are local variables passed around as routine 
C           arguments. Although this is fiddly it saves the need to 
C           impose additional synchronisation points when they are 
C           updated.
C     mytime - time counter for this thread (seconds)
C     myiter - iteration counter for this thread
C     mythid - thread number for this instance of the routine.
      _RL     mytime
      INTEGER myiter, mythid 
CEOP
#ifdef COUPLED_UCLA

C     coupling_dt - coupling interval (seconds)
      COMMON /COUPLING_DT/ coupling_dt
      Real*8  coupling_dt

C     Sea-ice and land mask (0 = land; 1 = sea ice; 2 = ocean)
      COMMON /ICEMASK/ icemask
      _RL     icemask(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C     i,j,bi,bj     - loop counters
C     terminate     - when .TRUE. indicates that last SST request
C                     from coupler is coming up
C     global, local - working variable and arrays
      INTEGER i,j,bi,bj,msgid
      COMMON /COUPLED_TERMINATE/ terminate, terminate_pending
      LOGICAL terminate, terminate_pending
      Real*8  global(Nx,Ny)
      _RL     local(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C-----------------------------------------------------------------------
C     Initialize UCLA AGCM-OGCM interface
C     - Transfer T, U, and V longitude and latitude points:
C         T (longitude, latitude) is (xC, yC)
C         U (longitude, latitude) is (xG, yC)
C         V (longitude, latitude) is (xC, yG)
C         Note that units are in degrees for spherical-polar grid
C         and in m for Cartesian grids (see GRID.h for details)
C     - Get coupling interval (seconds)
C-----------------------------------------------------------------------

      IF( myTime .EQ. startTime ) THEN
         terminate_pending = .FALSE.
         terminate = .FALSE.

C--   Initialize UCLA coupler
         CALL INIT_UCLA_COUPLER (myThid)

C--   Send grid information to coupler.
         CALL GATHER_2D( global, xC, mythid  )
         CALL SEND_T_LONGITUDE( global, mythid )

         CALL GATHER_2D( global, yC, mythid  )
         CALL SEND_T_LATITUDE( global, mythid )

         CALL GATHER_2D( global, xG, mythid  )
         CALL SEND_U_LONGITUDE( global, mythid )

         CALL GATHER_2D( global, yG, mythid  )
         CALL SEND_V_LATITUDE( global, mythid )

C--   Initialize interpolation routines
         CALL INIT_INTERPOLATION( myThid )

C--   Get coupling interval in s from coupler.
         CALL GET_COUPLING_DT( coupling_dt, myTime, mythid )
         CALL BROADCAST_R8( coupling_dt, mythid  )

#ifdef COUPLED_DEBUG
         print*,'COUPLED_UCLA coupling_dt:', coupling_dt
#endif COUPLED_DEBUG

      ENDIF

C-----------------------------------------------------------------------
C
C     Transfer SST to UCLA atmosphere model
C     Variable to transfer is theta(:,:,1,:,:)
C     (see DYNVARS.h for details)
C
C-----------------------------------------------------------------------
      IF( myTime .EQ. startTime .OR.
     &     DIFFERENT_MULTIPLE( coupling_dt,
     &     myTime-startTime+0.5*coupling_dt,
     &     myTime-startTime+0.5*coupling_dt-deltaTClock )) THEN
#ifdef COUPLED_DEBUG
         print*,'COUPLED_UCLA xfer SST myTime:', myTime
#endif COUPLED_DEBUG
         DO bj = myByLo(myThid), myByHi(myThid)
            DO bi = myBxLo(myThid), myBxHi(myThid)
               DO J=1-Oly,sNy+Oly
                  DO I=1-Olx,sNx+Olx
C--   Transfer SST to array local.
C--   Mask to -1000 land points.
                     local(I,J,bi,bj) =
     &                    ( theta(I,J,1,bi,bj) + 1000.0 _d 0 ) *
     &                      maskC(I,J,1,bi,bj) - 1000.0 _d 0
                  ENDDO
               ENDDO
            ENDDO
         ENDDO
         CALL GATHER_2D( global, local, myThid )
         CALL SEND_SST( global, myThid )
         CALL UCLA_O2GEIU (myTime, myThid)
         terminate = terminate_pending
         IF( terminate ) RETURN
      ENDIF

C-----------------------------------------------------------------------
C
C     Get surface forcing fields from the UCLA atmosphere model
C     Variables to transfer are listed below (see FFIELDS.h for details)
C     - fu, zonal surface wind stress, N/m^2 (>0 from East to West)
C     - fv, meridional surface wind stress, N/m^2 (>0 from North to South)
C     - EmPmR, Evaporation - Precipitation - Runoff, m/s (>0 for ocean salting)
C     - Qnet, Surface heat flux, W/m^2=kg/s^3 (>0 for ocean cooling)
C     - Qsw, Short-wave surface heat flux, W/m^2=kg/s^3 (>0 for ocean cooling)
C
C-----------------------------------------------------------------------
      IF( myTime .EQ. startTime .OR.
     &     DIFFERENT_MULTIPLE( coupling_dt,
     &     myTime-startTime, myTime-startTime-deltaTClock )) THEN
         CALL UCLA_G2OEIU (terminate_pending, myTime, mythid)
#ifdef COUPLED_DEBUG
         print*,'COUPLED_UCLA xfer FLUXES myTime:', myTime
#else COUPLED_DEBUG
         CALL GET_ICEMASK( global, mythid )
         CALL SCATTER_2D( global, ICEMASK, myThid )
         CALL GET_FU( global, mythid )
         CALL SCATTER_2D( global, fu, myThid )
         CALL GET_FV( global, mythid )
         CALL SCATTER_2D( global, fv, myThid )
         CALL GET_EMPMR( global, mythid )
         CALL SCATTER_2D( global, EmPmR, myThid )
         CALL GET_QNET( global, mythid )
         CALL SCATTER_2D( global, Qnet, myThid )
         CALL GET_QSW( global, mythid )
         CALL SCATTER_2D( global, Qsw, myThid )
#endif COUPLED_DEBUG
C     Set all fluxes that correspond to atmosphere
C     model land or sea-ice mask to zero.
cdm      DO bj = myByLo(myThid), myByHi(myThid)
cdm         DO bi = myBxLo(myThid), myBxHi(myThid)
cdm            DO j=1,sNy
cdm               DO i=1,sNx
cdm                  IF( icemask(i,j,bi,bj) .LT. 1.5 ) THEN
cdm                     fu   (i,j,bi,bj) = 0.0
cdm                     fv   (i,j,bi,bj) = 0.0
cdm                     EmPmR(i,j,bi,bj) = 0.0
cdm                     Qnet (i,j,bi,bj) = 0.0
cdm                     Qsw  (i,j,bi,bj) = 0.0
cdm                  ENDIF
cdm               ENDDO
cdm            ENDDO
cdm         ENDDO
cdm      ENDDO
#ifndef SHORTWAVE_HEATING
         DO bj = myByLo(myThid), myByHi(myThid)
            DO bi = myBxLo(myThid), myBxHi(myThid)
               DO J=1,sNy
                  DO I=1,sNx
                     Qnet(I,J,bi,bj) = Qnet(I,J,bi,bj) + Qsw(I,J,bi,bj)
                  ENDDO
               ENDDO
            ENDDO
         ENDDO
#endif SHORTWAVE_HEATING
         _EXCH_XY_R4( ICEMASK, myThid )
         _EXCH_XY_R4( fu     , myThid )
         _EXCH_XY_R4( fv     , myThid )
         _EXCH_XY_R4( EmPmR  , myThid )
         _EXCH_XY_R4( Qnet   , myThid )
         _EXCH_XY_R4( Qsw    , myThid )
      ENDIF

#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GATHER_2D( global, local, myThid )
C     Gather elements of a 2-D array from all processes to process 0.
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     mythid - thread number for this instance of the routine.
C     global,local - working arrays used to transfer 2-D fields
      INTEGER mythid 
      Real*8  global(Nx,Ny)
      _RL     local(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

#ifdef COUPLED_UCLA
      COMMON /GlobalLo/ mpi_myXGlobalLo, mpi_myYGlobalLo
      INTEGER mpi_myXGlobalLo(nPx*nPy)
      INTEGER mpi_myYGlobalLo(nPx*nPy)

      _RL     temp(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER istatus(MPI_STATUS_SIZE), ierr
      INTEGER idest, itag, npe, ready_to_receive
      INTEGER iP, jP, iG,jG, i, j, bi, bj, lbuff

C--   Make everyone wait except for master thread.
      _BARRIER
      _BEGIN_MASTER( myThid )
      lbuff = (sNx+2*OLx)*nSx*(sNy+2*OLy)*nSy
      idest = 0
      itag  = 0
      ready_to_receive = 0

      IF( mpiMyId .EQ. 0 ) THEN

C--   Process 0 fills-in its local data
         npe = 0
         DO bj=1,nSy
            DO bi=1,nSx
               DO j=1,sNy
                  DO i=1,sNx
                     iP = (bi-1)*sNx+i
                     jP = (bj-1)*sNy+j
                     iG = mpi_myXGlobalLo(npe+1)-1+(bi-1)*sNx+i
                     jG = mpi_myYGlobalLo(npe+1)-1+(bj-1)*sNy+j
                     global(iG,jG) = local(i,j,bi,bj)
                  ENDDO
               ENDDO
            ENDDO
         ENDDO

C--   Process 0 polls and receives data from each process in turn
         DO npe = 1, numberOfProcs-1
            CALL MPI_SEND (ready_to_receive, 1, MPI_INTEGER,
     &           npe, itag, MPI_COMM_MODEL, ierr)
            CALL MPI_RECV (temp, lbuff, MPI_DOUBLE_PRECISION,
     &           npe, itag, MPI_COMM_MODEL, istatus, ierr)

C--   Process 0 gathers the local arrays into a global array.
            DO bj=1,nSy
               DO bi=1,nSx
                  DO j=1,sNy
                     DO i=1,sNx
                        iP = (bi-1)*sNx+i
                        jP = (bj-1)*sNy+j
                        iG = mpi_myXGlobalLo(npe+1)-1+(bi-1)*sNx+i
                        jG = mpi_myYGlobalLo(npe+1)-1+(bj-1)*sNy+j
                        global(iG,jG) = temp(i,j,bi,bj)
                     ENDDO
                  ENDDO
               ENDDO
            ENDDO
         ENDDO

      ELSE

C--   All proceses except 0 wait to be polled then send local array
         CALL MPI_RECV (ready_to_receive, 1, MPI_INTEGER,
     &        idest, itag, MPI_COMM_MODEL, istatus, ierr)
         CALL MPI_SEND (local, lbuff, MPI_DOUBLE_PRECISION,
     &        idest, itag, MPI_COMM_MODEL, ierr)

      ENDIF

      _END_MASTER( myThid )
      _BARRIER

#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE SCATTER_2D( global, local, myThid )
C     Scatter elements of a 2-D array from process 0 to all processes.
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     mythid - thread number for this instance of the routine.
C     global,local - working arrays used to transfer 2-D fields
      INTEGER mythid 
      Real*8  global(Nx,Ny)
      _RL     local(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

#ifdef COUPLED_UCLA
      COMMON /GlobalLo/ mpi_myXGlobalLo, mpi_myYGlobalLo
      INTEGER mpi_myXGlobalLo(nPx*nPy)
      INTEGER mpi_myYGlobalLo(nPx*nPy)

      _RL     temp(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER istatus(MPI_STATUS_SIZE), ierr
      INTEGER isource, itag, npe
      INTEGER iP, jP, iG,jG, i, j, bi, bj, lbuff

C--   Make everyone wait except for master thread.
      _BARRIER
      _BEGIN_MASTER( myThid )
      lbuff=(sNx+2*OLx)*nSx*(sNy+2*OLy)*nSy
      isource = 0
      itag = 0

      IF( mpiMyId .EQ. 0 ) THEN

C--   Process 0 fills-in its local data
         npe = 0
         DO bj=1,nSy
            DO bi=1,nSx
               DO j=1,sNy
                  DO i=1,sNx
                     iP = (bi-1)*sNx+i
                     jP = (bj-1)*sNy+j
                     iG = mpi_myXGlobalLo(npe+1)-1+(bi-1)*sNx+i
                     jG = mpi_myYGlobalLo(npe+1)-1+(bj-1)*sNy+j
                     local(i,j,bi,bj) = global(iG,jG)
                  ENDDO
               ENDDO
            ENDDO
         ENDDO

C--   Process 0 sends local arrays to all other processes
         DO npe = 1, numberOfProcs-1
            DO bj=1,nSy
               DO bi=1,nSx
                  DO j=1,sNy
                     DO i=1,sNx
                        iP = (bi-1)*sNx+i
                        jP = (bj-1)*sNy+j
                        iG = mpi_myXGlobalLo(npe+1)-1+(bi-1)*sNx+i
                        jG = mpi_myYGlobalLo(npe+1)-1+(bj-1)*sNy+j
                        temp(i,j,bi,bj) = global(iG,jG)
                     ENDDO
                  ENDDO
               ENDDO
            ENDDO
            CALL MPI_SEND (temp, lbuff, MPI_DOUBLE_PRECISION,
     &           npe, itag, MPI_COMM_MODEL, ierr)
         ENDDO

      ELSE

C--   All proceses except 0 receive local array from process 0
         CALL MPI_RECV (local, lbuff, MPI_DOUBLE_PRECISION,
     &        isource, itag, MPI_COMM_MODEL, istatus, ierr)

      ENDIF

      _END_MASTER( myThid )
      _BARRIER

C--   Fill in edges.
      _EXCH_XY_R8( local, myThid )

#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE BROADCAST_R8( work, myThid )
C     Broadcast RL scalar from process 0 to all processes.
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     mythid - thread number for this instance of the routine.
C     global,local - working variables
      INTEGER mythid 
      Real*8 work
#ifdef COUPLED_UCLA
      INTEGER istatus(MPI_STATUS_SIZE), ierr, msgid, npe

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )

C--   Process 0 sends variable to all other OGCM processes
      msgid = 0
      IF( mpiMyId .EQ. 0 ) THEN
         DO npe = 1, numberOfProcs-1
            CALL MPI_SEND (work, 1, MPI_DOUBLE_PRECISION,
     &           npe, msgid, MPI_COMM_MODEL, ierr)
         ENDDO

C--   All OGCM processes (except 0) receive variable from process 0
      ELSE
         CALL MPI_RECV (work, 1, MPI_DOUBLE_PRECISION,
     &        0, msgid, MPI_COMM_MODEL, istatus, ierr)
      ENDIF

      _END_MASTER( myThid )
      _BARRIER

#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE INIT_UCLA_COUPLER (myThid)
C     Initialize UCLA coupler
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

      INTEGER myThid
#ifdef COUPLED_UCLA
C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN

#ifndef COUPLED_DEBUG
         CALL COUPLE (.TRUE., Nx, Ny)
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE SEND_T_LONGITUDE (global, myThid)
C     Send temperature longitude scale to coupler.
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

C     mythid - thread number for this instance of the routine.
C     global - working array used to transfer 2-D fields
      INTEGER mythid 
      Real*8  global(Nx,Ny)

#ifdef COUPLED_UCLA
      INTEGER i, j
      Real*8  tmp(Nx)

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN

         do j=2,Ny
         do i=1,Nx
            if (global(i,1) .ne. global(i,j)) call abort ()
         enddo
         enddo
         do i=1,Nx
            tmp(i) = global(i,1)
#ifdef SHIFT_MASK
     &           - 1.0
#endif
         enddo

#ifndef COUPLED_DEBUG
         call set_t_longitude (tmp)
#endif

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif /* COUPLED_UCLA */
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE SEND_T_LATITUDE (global, myThid)
C     Send temperature latitude scale to coupler.
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

C     mythid - thread number for this instance of the routine.
C     global - working array used to transfer 2-D fields
      INTEGER mythid 
      Real*8  global(Nx,Ny)

#ifdef COUPLED_UCLA
      INTEGER i, j
      Real*8  tmp(Ny)

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

         do j=1,Ny
         do i=2,Nx
            if (global(1,j) .ne. global(i,j)) call abort ()
         enddo
         enddo
         do j=1,Ny
            tmp(j) = global(1,j)
         enddo

#ifndef COUPLED_DEBUG
         call set_t_latitude (tmp)
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      END


C************************************************************************
C************************************************************************

      SUBROUTINE SEND_U_LONGITUDE (global, myThid)
C     Send U longitude scale to coupler.
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

C     mythid - thread number for this instance of the routine.
C     global - working array used to transfer 2-D fields
      INTEGER mythid 
      Real*8  global(Nx,Ny)

#ifdef COUPLED_UCLA
      INTEGER i, j
      Real*8  tmp(Nx)

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN

         do j=2,Ny
         do i=1,Nx
            if (global(i,1) .ne. global(i,j)) call abort ()
         enddo
         enddo
         do i=1,Nx
            tmp(i) = global(i,1)
#ifdef SHIFT_MASK
     &           - 1.0
#endif
         enddo

#ifndef COUPLED_DEBUG
         call set_u_longitude (tmp)
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE SEND_V_LATITUDE (global, myThid)
C     Send V latitude scale to coupler.
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      INTEGER mythid 
      Real*8 global(Nx,Ny)

#ifdef COUPLED_UCLA
      INTEGER i, j
      Real*8  tmp(Ny)

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

         do j=1,Ny
         do i=2,Nx
            if (global(1,j) .ne. global(i,j)) call abort ()
         enddo
         enddo
         do j=1,Ny
            tmp(j) = global(1,j)
         enddo

#ifndef COUPLED_DEBUG
         call set_v_latitude (tmp)
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      END


C************************************************************************
C************************************************************************

      SUBROUTINE SEND_SST ( global, myThid )
C     Send SST array to coupler.
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      INTEGER mythid 
      Real*8  global(Nx,Ny)
#ifdef COUPLED_UCLA
C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN

#ifndef COUPLED_DEBUG
         CALL SSTINS (GLOBAL)
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE INIT_INTERPOLATION (myThid)
C     Initialize UCLA coupler interpolation routines
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

      INTEGER myThid
#ifdef COUPLED_UCLA
C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN

#ifndef COUPLED_DEBUG
         CALL SETSCL
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_COUPLING_DT (coupling_dt, myTime, myThid)
C     Get coupling period in s
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

      Real*8  coupling_dt
      _RL     myTime
      INTEGER mythid

#ifdef COUPLED_UCLA
C     tbegin    - initial AGCM reference time (hours)
C     time_norm - OGCM startTime offset relative to tbegin (hours)
      INTEGER year,         imonth,       dayomonth
      Real*8  gmt,          tbegin,       time0,         time_norm
      common/time_var/ year, imonth, dayomonth,
     *                 gmt, tbegin, time0, time_norm

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN

#ifndef COUPLED_DEBUG
         call initoc_net 
     *        (year,        imonth,      dayomonth,    gmt,
     *         coupling_dt, tbegin,      time0)
         time_norm = tbegin - myTime/3600.0
         coupling_dt = coupling_dt * 3600.0
#else
      coupling_dt = 14400
#endif COUPLED_DEBUG

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_ICEMASK( global, myThid )
C     Get atmospheric sea-ice mask (0 = land; 1 = sea ice; 2 = ocean).
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      Integer iglobal(Nx,Ny)
      Real*8  global (Nx,Ny)
      INTEGER mythid 
#ifdef COUPLED_UCLA
      INTEGER i, j

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

#ifndef COUPLED_DEBUG
         CALL imkext (iglobal)
#endif COUPLED_DEBUG

C--   Convert to Real*8
      DO j=1,Ny
         DO i=1,Nx
            global(i,j)=iglobal(i,j)
         ENDDO
      ENDDO

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_FU( global, myThid )
C     Get zonal surface wind stress, N/m^2 (>0 from East to West)
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      Real*8  global(Nx,Ny)
      INTEGER mythid 
#ifdef COUPLED_UCLA
      INTEGER i, j

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

#ifndef COUPLED_DEBUG
         CALL wsxext (global)
#endif COUPLED_DEBUG

C--   Convert from dynes/cm^2 to N/m^2
      DO j=1,Ny
         DO i=1,Nx
            global(i,j)=global(i,j)*0.1
         ENDDO
      ENDDO

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_FV( global, myThid )
C     Get meridional surface wind stress, N/m^2 (>0 from North to South)
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      Real*8  global(Nx,Ny)
      INTEGER mythid 

#ifdef COUPLED_UCLA
      INTEGER i, j

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

#ifndef COUPLED_DEBUG
         CALL wsyext (global)
#endif COUPLED_DEBUG

C--   Convert from dynes/cm^2 to N/m^2
      DO j=1,Ny
         DO i=1,Nx
            global(i,j)=global(i,j)*0.1
         ENDDO
      ENDDO

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_EMPMR( global, myThid )
C     Get Evaporation - Precipitation - Runoff, m/s (>0 for ocean salting)
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      Real*8 global(Nx,Ny)
      INTEGER mythid 

#ifdef COUPLED_UCLA
      INTEGER i, j

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

#ifndef COUPLED_DEBUG
         CALL pmeext (global)
#endif COUPLED_DEBUG

C--   Convert from mm/s, positive for ocean freshening
C     to m/s, positive for ocean salting
      DO j=1,Ny
         DO i=1,Nx
            global(i,j)=-global(i,j)*0.001
         ENDDO
      ENDDO

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_QNET( global, myThid )
C     Get surface heat flux, W/m^2
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      Real*8 global(Nx,Ny)
      INTEGER mythid 

#ifdef COUPLED_UCLA
      INTEGER i, j

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

#ifndef COUPLED_DEBUG
         CALL hfxext (global)
#endif COUPLED_DEBUG

C--   Convert to positive for ocean cooling
      DO j=1,Ny
         DO i=1,Nx
            global(i,j)=-global(i,j)
         ENDDO
      ENDDO

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE GET_QSW( global, myThid )
C     Get short-wave surface heat flux, W/m^2=kg/s^3 (>0 for ocean cooling)
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
C     global - working array used to transfer 2-D fields
C     mythid - thread number for this instance of the routine.
      Real*8 global(Nx,Ny)
      INTEGER mythid 

#ifdef COUPLED_UCLA
      INTEGER i, j

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF( mpiMyId .EQ. 0 ) THEN

#ifndef COUPLED_DEBUG
         CALL swrext (global)
#endif COUPLED_DEBUG

C--   Convert to positive for ocean cooling
      DO j=1,Ny
         DO i=1,Nx
            global(i,j)=-global(i,j)
         ENDDO
      ENDDO

      ENDIF
      _END_MASTER( myThid )
      _BARRIER
#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE UCLA_G2OEIU (terminate, myTime, mythid)
C     Initialize UCLA coupler
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

      LOGICAL terminate
      _RL     myTime
      INTEGER mythid 

#ifdef COUPLED_UCLA
      INTEGER irc
      Real*8  tmp_irc
      INTEGER year,         imonth,       dayomonth
      Real*8  gmt,          tbegin,       time0,         time_norm
      common/time_var/ year, imonth, dayomonth,
     *                 gmt, tbegin, time0, time_norm

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN
         irc = 1
#ifdef COUPLED_DEBUG
         IF( myTime .EQ. 36000.0 ) irc = -1
#else COUPLED_DEBUG
         CALL g2oeiu (irc, time_norm + myTime/3600.0)
#endif COUPLED_DEBUG
         tmp_irc = irc
      ENDIF
      _END_MASTER( myThid )
      _BARRIER
      CALL BROADCAST_R8( tmp_irc, mythid  )
      terminate = tmp_irc .lt. 0

#endif COUPLED_UCLA
      RETURN
      END


C************************************************************************
C************************************************************************

      SUBROUTINE UCLA_O2GEIU (myTime, myThid)
C     Initialize UCLA coupler
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"

      _RL     myTime
      INTEGER mythid

#ifdef COUPLED_UCLA
      INTEGER irc
      INTEGER year,         imonth,       dayomonth
      Real*8  gmt,          tbegin,       time0,         time_norm
      common/time_var/ year, imonth, dayomonth,
     *                 gmt, tbegin, time0, time_norm

C--   Make everyone wait except for master thread in master process.
      _BARRIER
      _BEGIN_MASTER( myThid )
      IF (mpiMyId .EQ. 0) THEN
         irc = 0
#ifndef COUPLED_DEBUG
         CALL o2geiu (irc, time_norm + myTime/3600.0 )
#endif COUPLED_DEBUG
      ENDIF
      _END_MASTER( myThid )
      _BARRIER

#endif COUPLED_UCLA
      RETURN
      END
