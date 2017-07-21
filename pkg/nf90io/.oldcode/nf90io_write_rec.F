
#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
!ROUTINE: NF90IO_WRITE_REC.F
C
C     !DESCRIPTION:
C     *==========================================================*
C     | NF90IO_WRITE_REC                                         |
C     *==========================================================*
C     | 
C     | !!!! NOT IMPLIMENTED      !!! 
C     | 
C     | In an initial version of this package, this was called in|
C     | model/src/write_state.F
C     |  
C     | Dropped in favour of implimenting as an output for       |
C     | pkg/diagnostics. 
C     |
C     | Writes model state.  If it is the first record, then     |
C     | initialize the file and state variables.   Uses helper   |
C     | routines in NF90IO_UTIL and NF90IO_INIT_FILE.F           |
C     *==========================================================*
CEOP

      SUBROUTINE NF90IO_WRITE_REC ( iRec, myTime, myIter, myThid )
        use netcdf
        IMPLICIT NONE

#include "mpif.h"
#include "SIZE.h"
#include "EEPARAMS.h"
#include "NF90IO.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#ifdef ALLOW_NONHYDROSTATIC
#include "NH_VARS.h"
#endif

        INTEGER iRec
        _RL     myTime
        INTEGER myThid
        INTEGER myIter

        INTEGER mode_flag, ncid, err, i, j, k, t
        INTEGER bi, bj
        INTEGER i_dimid, j_dimid, k_dimid, dimids(4), varid
        INTEGER ig_dimid, jg_dimid, kl_dimid, ku_dimid, kp1_dimid
        INTEGER start(4), count(4), rec_dimid
        LOGICAL iAmDoingIO
        character*(MAX_LEN_MBUF) msgbuf
        _RL     a(sNx,sNy,Nr)
        _RL     is(sNx+10)
        _RL     js(sNy+10)
        _RL     ks(Nr+10)

        if (iRec.EQ.1) then
C          initialize this new file...
          CALL NF90IO_INIT_FILE(NF90ioFilename, myThid)
C     Define dynvars:
          err = nf90_open(NF90ioFilename, IOR(nf90_write, nf90_mpiio),
     $         ncid,
     $         comm = MPI_COMM_WORLD,   info = MPI_INFO_NULL)
          CALL nf90ERR(err, "Open nc file to write",myThid)
          err = nf90_redef(ncid)

C     Get the dimension ids we will need.  Could do this with globals
C     but this is just as easy.   
          err = nf90_inq_dimid(ncid, 'i', i_dimid)
          CALL nf90ERR(err, "inq i_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'i_g', ig_dimid)
          CALL nf90ERR(err, "inq i_g_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'j', j_dimid)
          CALL nf90ERR(err, "inq j_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'j_g', jg_dimid)
          CALL nf90ERR(err, "inq j_g_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'k', k_dimid)
          CALL nf90ERR(err, "inq k_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'k_u', ku_dimid)
          CALL nf90ERR(err, "inq k_u_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'k_l', kl_dimid)
          CALL nf90ERR(err, "inq k_l_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'k_p1', kp1_dimid)
          CALL nf90ERR(err, "inq k_p1_dimid",myThid)
          err = nf90_inq_dimid(ncid, 'record', rec_dimid)
          CALL nf90ERR(err, "inq record_dimid",myThid)

          dimids =  (/  i_dimid, j_dimid, k_dimid, rec_dimid /)
          err = nf90_def_var(ncid, "Theta", NF90_DOUBLE, dimids, varid)
          CALL nf90ERR(err, "Adding Theta variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_potential_temperature")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Potential Temperature")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "degree_Celcius")
          CALL nf90ERR(err,"Setting attributes",myThid)

          err = nf90_def_var(ncid, "Salt", NF90_DOUBLE, dimids, varid)
          CALL nf90ERR(err, "Adding Salt variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_salinity")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Salinity")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "psu")
          CALL nf90ERR(err,"Setting attributes",myThid)

          err = nf90_def_var(ncid, "PH", NF90_DOUBLE, dimids, varid)
          CALL nf90ERR(err, "Adding PH variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_dynamic_pressure")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Hydrostatic Pressure Pot.(p/rho) Anomaly")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "m2 s-2")
          err = nf90_put_att(ncid, varid, 
     $         "coordinate",
     $         "XC YC Z")
          CALL nf90ERR(err,"Setting attributes",myThid)

          dimids =  (/  ig_dimid, j_dimid, k_dimid, rec_dimid /)
          err = nf90_def_var(ncid, "U", NF90_DOUBLE, dimids, varid)
          CALL nf90ERR(err, "Adding U variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_x_velocity")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Zonal Component of Velocity")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "m s-1")
          CALL nf90ERR(err,"Setting attributes",myThid)

          dimids =  (/  i_dimid, jg_dimid, k_dimid, rec_dimid /)
          err = nf90_def_var(ncid, "V", NF90_DOUBLE, dimids, varid)
          CALL nf90ERR(err, "Adding V variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_y_velocity")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Meridional Component of Velocity")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "m s-1")
          CALL nf90ERR(err,"Setting attributes",myThid)

          dimids =  (/  i_dimid, j_dimid, kl_dimid, rec_dimid /)
          err = nf90_def_var(ncid, "W", NF90_DOUBLE, dimids, varid)
          CALL nf90ERR(err, "Adding W variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_z_velocity")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Vertica Component of Velocity")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "m s-1")
          CALL nf90ERR(err,"Setting attributes",myThid)

          dimids(1:3) =  (/  i_dimid, j_dimid, rec_dimid /)
          err = nf90_def_var(ncid, "Eta", NF90_DOUBLE, dimids(1:3),
     $         varid)
          CALL nf90ERR(err, "Adding Eta variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "ETAN")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Surface Height Anomaly")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "m")
          CALL nf90ERR(err,"Setting attributes",myThid)

          dimids(1:3) =  (/  i_dimid, j_dimid, rec_dimid /)
          err = nf90_def_var(ncid, "PHL", NF90_DOUBLE, dimids(1:3),
     $         varid)
          CALL nf90ERR(err, "Adding PHL variable",myThid)
          err = nf90_put_att(ncid, varid,
     $         "standard_name", 
     $         "sea_water_dynamic_pressure_at_sea_floor")
          err = nf90_put_att(ncid, varid, 
     $         "long_name",
     $         "Bottom Pressure Pot.(p/rho) Anomaly")
          err = nf90_put_att(ncid, varid, 
     $         "units",
     $         "m2 s-2")
          CALL nf90ERR(err,"Setting attributes",myThid)

#ifdef ALLOW_NONHYDROSTATIC
          IF (nonHydroStatic) THEN
             dimids =  (/  i_dimid, j_dimid, k_dimid, rec_dimid /)
             err = nf90_def_var(ncid, "PNH", NF90_DOUBLE, dimids, varid)
             CALL nf90ERR(err, "Adding PNH variable",myThid)
             err = nf90_put_att(ncid, varid,
     $            "standard_name", 
     $            "sea_water_nonhydrostatic_dynamic_pressure")
             err = nf90_put_att(ncid, varid, 
     $            "long_name",
     $            "Non-Hydrostatic Pressure Pot.(p/rho) Anomaly")
             err = nf90_put_att(ncid, varid, 
     $            "units",
     $            "m2 s-2")
             CALL nf90ERR(err,"Setting attributes",myThid)
          ENDIF
#endif /* ALLOW_NONHYDROSTATIC */


          err = nf90_enddef(ncid)
          err = nf90_close(ncid)
          CALL nf90ERR(err, "Closing netcdf file",myThid)          
        endif
C       /endif the first record.
C
C       Now write the data
C
        err = nf90_open(NF90ioFilename, IOR(nf90_write, nf90_mpiio),
     $       ncid, comm=MPI_COMM_WORLD, info=MPI_INFO_NULL)
        CALL nf90ERR(err, "Open nc file to write",myThid)

C update the record
        err = nf90_inq_varid(ncid, "record", varid)
        CALL nf90ERR(err, "Get the record varid",myThid)
        err = nf90_var_par_access(ncid, varid, nf90_collective)
        err = nf90_put_var(ncid, varid, (/ iRec /), start = (/ iRec /),
     $       count = (/ 1 /) )
        CALL nf90ERR(err, "Write iRec to the record variable",myThid)
        
        err = nf90_inq_varid(ncid, "time", varid)
        CALL nf90ERR(err, "Get the time varid",myThid)
        err = nf90_var_par_access(ncid, varid, nf90_collective)
        err = nf90_put_var(ncid, varid, (/ myTime /), start = (/ iRec /)
     $       ,count = (/ 1 /) )
        CALL nf90ERR(err, "Write time variable",myThid)
        
        err = nf90_inq_varid(ncid, "iter", varid)
        CALL nf90ERR(err, "Get the iter varid",myThid)
        err = nf90_var_par_access(ncid, varid, nf90_collective)
        err = nf90_put_var(ncid, varid, (/ myIter /), start = (/ iRec /)
     $       ,count = (/ 1 /) )
        CALL nf90ERR(err, "Write iter variable",myThid)
                
C start 3-D  variables....
C TODO: There are some other variables and logic that should 
C       be copied from write_state.F
        CALL NF90IO_FILL_3D(ncid, "Eta", etaN, iRec, myThid)
        CALL NF90IO_FILL_3D(ncid, "PHL", phiHydLow, iRec, myThid)
        CALL NF90IO_FILL_4D(ncid, "Theta", theta, iRec, myThid)
        CALL NF90IO_FILL_4D(ncid, "U", Uvel, iRec, myThid)
        CALL NF90IO_FILL_4D(ncid, "V", Vvel, iRec, myThid)
        CALL NF90IO_FILL_4D(ncid, "W", Wvel, iRec, myThid)
        CALL NF90IO_FILL_4D(ncid, "PH", totPhiHyd, iRec, myThid)
        CALL NF90IO_FILL_4D(ncid, "Salt", salt, iRec, myThid)

#ifdef ALLOW_NONHYDROSTATIC
          IF (nonHydroStatic) THEN
             CALL NF90IO_FILL_4D(ncid, "PNH", phi_nh, iRec, myThid)
          ENDIF
#endif /* ALLOW_NONHYDROSTATIC */

        err = nf90_close(ncid)
        CALL nf90ERR(err, "Closing netcdf file",myThid)

      RETURN
      END
