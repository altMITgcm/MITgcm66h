C $Header$

#include "CTRL_CPPOPTIONS.h"


      subroutine ctrl_unpack(
     I                        myiter,
     I                        mytime,
     I                        mythid
     &                      )

c     ==================================================================
c     SUBROUTINE ctrl_unpack
c     ==================================================================
c
c     o Unpack the control vector such that the land points are filled
c       in.
c
c     started: Christian Eckert eckert@mit.edu  10-Mar-2000
c
c     changed: Patrick Heimbach heimbach@mit.edu 06-Jun-2000
c              - Transferred some filename declarations
c                from here to namelist in ctrl_init
c
c              Patrick Heimbach heimbach@mit.edu 16-Jun-2000
c              - single file name convention with or without
c                ALLOW_ECCO_OPTIMIZATION
C
c              Armin Koehl akoehl@ucsd.edu 05-Dec-2000
c              - single processor reads global parameter file
c               and writes multiple xx* and adxx* files
c
c     ==================================================================
c     SUBROUTINE ctrl_unpack
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"

#include "cal.h"
#include "ecco.h"
#include "ctrl.h"
#include "cost.h"

#ifdef ALLOW_ECCO_OPTIMIZATION
#include "optim.h"
#endif

c     == routine arguments ==

      integer myiter
      _RL     mytime
      integer mythid

c     == local variables ==

#ifndef ALLOW_ECCO_OPTIMIZATION
      integer optimcycle
#endif

      integer i, j, k
      integer ii
      integer il
      integer irec
      integer ig,jg
      integer ivartype

      integer cbuffindex
      integer cunit

      character*(128) cfile
      character*( 80) weighttype

      logical first
      
      integer        filenvartype
      integer        filenvarlength
      character*(10) fileExpId
      integer        fileOptimCycle
      integer        filencbuffindex
      _RL            fileDummy
      integer        fileIg
      integer        fileJg
      integer        fileI
      integer        fileJ
      integer        filensx
      integer        filensy
      integer        filek
      integer        filenWetcTile(nr)
      integer        filenWetsTile(nr)
      integer        filenWetwTile(nr)
      integer        filencvarindex(maxcvars)
      integer        filencvarrecs(maxcvars)
      integer        filencvarxmax(maxcvars)
      integer        filencvarymax(maxcvars)
      integer        filencvarnrmax(maxcvars)
      character*( 1) filencvargrd(maxcvars)

      character*( 80)   fname_theta
      character*( 80) adfname_theta
      character*( 80)   fname_salt
      character*( 80) adfname_salt
      character*( 80)   fname_hflux
      character*( 80) adfname_hflux
      character*( 80)   fname_sflux
      character*( 80) adfname_sflux
      character*( 80)   fname_tauu
      character*( 80) adfname_tauu
      character*( 80)   fname_tauv
      character*( 80) adfname_tauv
      character*( 80)   fname_atemp
      character*( 80) adfname_atemp
      character*( 80)   fname_aqh
      character*( 80) adfname_aqh
      character*( 80)   fname_uwind
      character*( 80) adfname_uwind
      character*( 80)   fname_vwind
      character*( 80) adfname_vwind
      character*( 80)   fname_obcsn
      character*( 80) adfname_obcsn
      character*( 80)   fname_obcss
      character*( 80) adfname_obcss
      character*( 80)   fname_obcsw
      character*( 80) adfname_obcsw
      character*( 80)   fname_obcse
      character*( 80) adfname_obcse

c     == external ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

#ifndef ALLOW_ECCO_OPTIMIZATION
      optimcycle = 0
#endif

c--   Check if this is the first model time step.
      if ( mytime .lt. modelstart + 0.5*modelstep ) then
        first = .true.
      else
        first = .false.
      endif

      if ( first ) then

c--     Only the master thread will do I/O.
        _BEGIN_MASTER( mythid )

        jG = 1 + (myygloballo - 1)/sny
        iG = 1 + (myxgloballo - 1)/snx

#ifdef ALLOW_THETA0_CONTROL
        ivartype = 1
        call ctrl_set_fname(
     &       xx_theta_file, fname_theta, adfname_theta, mythid )
        call ctrl_set_globfld_xyz(
     &       adfname_theta, ivartype, mythid)
#endif /* ALLOW_THETA0_CONTROL */

#ifdef ALLOW_SALT0_CONTROL
        ivartype = 2
        call ctrl_set_fname(
     I       xx_salt_file, fname_salt, adfname_salt, mythid )
        call ctrl_set_globfld_xyz(
     &       adfname_salt, ivartype, mythid)
#endif

#ifdef ALLOW_HFLUX_CONTROL
        ivartype = 3
        call ctrl_set_fname(
     I       xx_hflux_file, fname_hflux, adfname_hflux, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_hflux, ivartype, mythid)
#endif

#ifdef ALLOW_SFLUX_CONTROL
        ivartype = 4
        call ctrl_set_fname(
     I       xx_sflux_file, fname_sflux, adfname_sflux, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_sflux, ivartype, mythid)
#endif

#ifdef ALLOW_USTRESS_CONTROL
        ivartype = 5
        call ctrl_set_fname(
     I       xx_tauu_file, fname_tauu, adfname_tauu, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_tauu, ivartype, mythid)
#endif

#ifdef ALLOW_VSTRESS_CONTROL
        ivartype = 6
        call ctrl_set_fname(
     I       xx_tauv_file, fname_tauv, adfname_tauv, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_tauv, ivartype, mythid)
#endif

#ifdef ALLOW_ATEMP_CONTROL
        ivartype = 7
        call ctrl_set_fname(
     I       xx_atemp_file, fname_atemp, adfname_atemp, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_atemp, ivartype, mythid)
#endif

#ifdef ALLOW_AQH_CONTROL
        ivartype = 8
        call ctrl_set_fname(
     I       xx_aqh_file, fname_aqh, adfname_aqh, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_aqh, ivartype, mythid)
#endif

#ifdef ALLOW_UWIND_CONTROL
        ivartype = 9
        call ctrl_set_fname(
     I       xx_uwind_file, fname_uwind, adfname_uwind, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_uwind, ivartype, mythid)
#endif

#ifdef ALLOW_VWIND_CONTROL
        ivartype = 10
        call ctrl_set_fname(
     I       xx_vwind_file, fname_vwind, adfname_vwind, mythid )
        call ctrl_set_globfld_xy(
     &       adfname_vwind, ivartype, mythid)
#endif

#ifdef ALLOW_OBCSN_CONTROL
        ivartype = 11
        call ctrl_set_fname(
     I       xx_obcsn_file, fname_obcsn, adfname_obcsn, mythid )
        call ctrl_set_globfld_xz(
     &       adfname_obcsn, ivartype, mythid)
#endif

#ifdef ALLOW_OBCSS_CONTROL
        ivartype = 12
        call ctrl_set_fname(
     I       xx_obcss_file, fname_obcss, adfname_obcss, mythid )
        call ctrl_set_globfld_xz(
     &       adfname_obcss, ivartype, mythid)
#endif

#ifdef ALLOW_OBCSW_CONTROL
        ivartype = 13
        call ctrl_set_fname(
     I       xx_obcsw_file, fname_obcsw, adfname_obcsw, mythid )
        call ctrl_set_globfld_yz(
     &       adfname_obcsw, ivartype, mythid)
#endif

#ifdef ALLOW_OBCSE_CONTROL
        ivartype = 14
        call ctrl_set_fname(
     I       xx_obcse_file, fname_obcse, adfname_obcse, mythid )
        call ctrl_set_globfld_yz(
     &       adfname_obcse, ivartype, mythid)
#endif

c *********************************************************************
c if NOT very first iteration of optimization
        if ( optimcycle .ne. 0 ) then
c *********************************************************************

          call mdsfindunit( cunit, mythid )

          write(cfile(1:128),'(4a,i4.4)')
     &      ctrlname(1:9),'_',expId(1:10),'.opt',
     &      optimcycle

          open( cunit, file   = cfile,
     &                 status = 'old',
     &                 form   = 'unformatted',
     &                 access  = 'sequential'   )

c--       Header information.
          read(cunit) filenvartype
          read(cunit) filenvarlength
          read(cunit) fileExpId
          read(cunit) fileOptimCycle
          read(cunit) fileDummy
          read(cunit) fileIg
          read(cunit) fileJg
          read(cunit) filensx
          read(cunit) filensy
          read(cunit) (filenWetcTile(k),   k=1,nr)
          read(cunit) (filenWetsTile(k),   k=1,nr)
          read(cunit) (filenWetwTile(k),   k=1,nr)
          read(cunit) (filencvarindex(i), i=1,maxcvars)
          read(cunit) (filencvarrecs(i),  i=1,maxcvars)
          read(cunit) (filencvarxmax(i),  i=1,maxcvars)
          read(cunit) (filencvarymax(i),  i=1,maxcvars)
          read(cunit) (filencvarnrmax(i), i=1,maxcvars)
          read(cunit) (filencvargrd(i),   i=1,maxcvars)
          read(cunit)

c         Check file header info.
c
          if ( filenvarlength .NE. nvarlength ) then
             print *, 'WARNING: wrong nvarlength ',
     &            filenvarlength, nvarlength
             STOP 'in S/R ctrl_unpack'
          else if ( filensx .NE. nsx .OR. filensy .NE. nsy ) then
             print *, 'WARNING: wrong nsx or nsy ',
     &            filensx, nsx, filensy, nsy
             STOP 'in S/R ctrl_unpack'
          endif
          do k = 1, nr
             if ( filenWetcTile(k) .NE. nWetcTile(1,1,k) .OR.
     &            filenWetsTile(k) .NE. nWetsTile(1,1,k) .OR.
     &            filenWetwTile(k) .NE. nWetwTile(1,1,k) ) then
                print *, 'WARNING: wrong nWet?Tile for k = ', k
                STOP
             endif
          end do

c----------------------------------------------------------------------

#ifdef ALLOW_THETA0_CONTROL
          ivartype = 1
          call ctrl_set_unpack_xyz(
     &         cunit, ivartype, fname_theta, "hFacC",
     &         wtheta, nwetctile, mythid)
#endif

#ifdef ALLOW_SALT0_CONTROL
          ivartype = 2
          call ctrl_set_unpack_xyz(
     &         cunit, ivartype, fname_salt, "hFacC",
     &         wsalt, nwetctile, mythid)
#endif

#ifdef ALLOW_HFLUX_CONTROL
          ivartype    = 3
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "whflux"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_hflux, "hFacC", weighttype,
     &         nwetctile, mythid)
#endif

#ifdef ALLOW_SFLUX_CONTROL
          ivartype = 4
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wsflux"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_sflux, "hFacC", weighttype,
     &         nwetctile, mythid)
#endif

#ifdef ALLOW_USTRESS_CONTROL
          ivartype = 5
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wtauu"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_tauu, "maskW", weighttype,
     &         nwetwtile, mythid)
#endif

#ifdef ALLOW_VSTRESS_CONTROL
          ivartype = 6
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wtauv"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_tauv, "maskS", weighttype,
     &         nwetstile, mythid)
#endif

#ifdef ALLOW_ATEMP_CONTROL
          ivartype    = 7
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "watemp"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_atemp, "hFacC", weighttype,
     &         nwetctile, mythid)
#endif

#ifdef ALLOW_AQH_CONTROL
          ivartype    = 8
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "waqh"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_aqh, "hFacC", weighttype,
     &         nwetctile, mythid)
#endif

#ifdef ALLOW_UWIND_CONTROL
          ivartype    = 9
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wuwind"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_uwind, "maskW", weighttype,
     &         nwetctile, mythid)
#endif

#ifdef ALLOW_VWIND_CONTROL
          ivartype    = 10
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wvwind"
          call ctrl_set_unpack_xy(
     &         cunit, ivartype, fname_vwind, "maskS", weighttype,
     &         nwetctile, mythid)
#endif

#ifdef ALLOW_OBCSN_CONTROL
          ivartype    = 11
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wobcsn"
          call ctrl_set_unpack_xz(
     &         cunit, ivartype, fname_obcsn, "maskobcsn",
     &         wobcsn, nwetobcsn, mythid)
#endif

#ifdef ALLOW_OBCSS_CONTROL
          ivartype    = 12
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wobcss"
          call ctrl_set_unpack_xz(
     &         cunit, ivartype, fname_obcss, "maskobcss",
     &         wobcss, nwetobcss, mythid)
#endif

#ifdef ALLOW_OBCSW_CONTROL
          ivartype    = 13
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wobcsw"
          call ctrl_set_unpack_yz(
     &         cunit, ivartype, fname_obcsw, "maskobcsw",
     &         wobcsw, nwetobcsw, mythid)
#endif

#ifdef ALLOW_OBCSE_CONTROL
          ivartype    = 14
          write(weighttype(1:80),'(80a)') ' '
          write(weighttype(1:80),'(a)') "wobcse"
          call ctrl_set_unpack_yz(
     &         cunit, ivartype, fname_obcse, "maskobcse",
     &         wobcse, nwetobcse, mythid)
#endif

         close ( cunit )

c *********************************************************************
c if very first iteration of optimization
        else
c *********************************************************************

c--       Write zeroes to file.

#ifdef ALLOW_THETA0_CONTROL
           ivartype = 1
           call ctrl_set_globfld_xyz( 
     I          fname_theta, ivartype, mythid )
#endif
           
#ifdef ALLOW_SALT0_CONTROL
           ivartype = 2
           call ctrl_set_globfld_xyz( 
     I          fname_salt, ivartype, mythid )
#endif

#ifdef ALLOW_HFLUX_CONTROL
           ivartype = 3
           call ctrl_set_globfld_xy( 
     I          fname_hflux, ivartype, mythid )
#endif

#ifdef ALLOW_SFLUX_CONTROL
           ivartype = 4
           call ctrl_set_globfld_xy( 
     I          fname_sflux, ivartype, mythid )
#endif

#ifdef ALLOW_USTRESS_CONTROL
           ivartype = 5
           call ctrl_set_globfld_xy( 
     I          fname_tauu, ivartype, mythid )
#endif

#ifdef ALLOW_VSTRESS_CONTROL
           ivartype = 6
           call ctrl_set_globfld_xy( 
     I          fname_tauv, ivartype, mythid )
#endif

#ifdef ALLOW_ATEMP_CONTROL
           ivartype = 7
           call ctrl_set_globfld_xy( 
     I          fname_atemp, ivartype, mythid )
#endif

#ifdef ALLOW_AQH_CONTROL
           ivartype = 8
           call ctrl_set_globfld_xy( 
     I          fname_aqh, ivartype, mythid )
#endif

#ifdef ALLOW_UWIND_CONTROL
           ivartype = 9
           call ctrl_set_globfld_xy( 
     I          fname_uwind, ivartype, mythid )
#endif

#ifdef ALLOW_VWIND_CONTROL
           ivartype = 10
           call ctrl_set_globfld_xy( 
     I          fname_vwind, ivartype, mythid )
#endif

#ifdef ALLOW_OBCSN_CONTROL
           ivartype = 11
           call ctrl_set_globfld_xz( 
     I          fname_obcsn, ivartype, mythid )
#endif

#ifdef ALLOW_OBCSS_CONTROL
           ivartype = 12
           call ctrl_set_globfld_xz( 
     I          fname_obcss, ivartype, mythid )
#endif

#ifdef ALLOW_OBCSW_CONTROL
           ivartype = 13
           call ctrl_set_globfld_yz( 
     I          fname_obcsw, ivartype, mythid )
#endif

#ifdef ALLOW_OBCSE_CONTROL
           ivartype = 14
           call ctrl_set_globfld_yz( 
     I          fname_obcse, ivartype, mythid )
#endif

        endif

        _END_MASTER( mythid )

      endif

      return
      end

