C $Header: /u/gcmpack/MITgcm/pkg/kl10/KL10.h,v 1.1 2014/07/30 03:28:05 jmc Exp $
C $Name: checkpoint66d $

#ifdef ALLOW_NF90IO

CBOP
C !ROUTINE: NF90IO.h

C !DESCRIPTION: \bv
C     /==========================================================\
C     | NF90IO.h                                                   |
C     | o Basic header for Netcdf/Fortran90/Parallel i/o           |
C     \==========================================================/

C-----------------------------------------------------------------------
C
C Constants that could be set in a data.nf90io
C
C     !!!! NOT IMPLIMENTED !!!! 
C     See pkg/diagnostics/diagnostics_nf90io_out.F
C
C     NF90ioFileName - name of the netcdf file to write
C     NF90ioAppend - whether to append to an existing file (default=False)
C
C-----------------------------------------------------------------------
C \ev
CEOP


      CHARACTER*(MAX_LEN_FNAM) NF90ioFilename
      LOGICAL   NF90ioAppend
C Variable to globally keep track of if we need to create the netcdf file.
      LOGICAL   NF90ioFileCreated, NF90ioisOn, NF90ioDump 

      COMMON /NF90IO_PARMS/
     &     NF90ioFilename,
     &     NF90ioAppend,
     &     NF90ioFileCreated,
     &     NF90ioisOn,
     &     NF90ioDump




#endif /* ALLOW_NF90IO */
