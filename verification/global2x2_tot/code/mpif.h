! IBM_PROLOG_BEGIN_TAG 
! This is an automatically generated prolog. 
!  
!  
!  
! Licensed Materials - Property of IBM 
!  
! (C) COPYRIGHT International Business Machines Corp. 1994,1999 
! All Rights Reserved 
!  
! US Government Users Restricted Rights - Use, duplication or 
! disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
!  
! IBM_PROLOG_END_TAG 
!  ***************************************************************************
!  @(#) 1.36 src/ppe/poe/include/signal/mpif.h, ppe.poe.mpi, ppe_rmoh, rmoht5du 00/06/12 10:10:37
!
!  Name: mpif.h
!
!  Description: 
!                 
!     NOTE:  This file contains information necessary for compiling
!            Fortran applications with the signals based MPI library.
!            (The signals based MPI library does not include any of MPI-2)   
!
!
!  ***************************************************************************

      integer MPI_VERSION,MPI_SUBVERSION
      parameter (MPI_VERSION=1,MPI_SUBVERSION=2)

      integer MPI_SUCCESS,MPI_ERR_BUFFER,MPI_ERR_COUNT,MPI_ERR_TYPE
      integer MPI_ERR_TAG,MPI_ERR_COMM,MPI_ERR_RANK,MPI_ERR_REQUEST
      integer MPI_ERR_ROOT,MPI_ERR_GROUP,MPI_ERR_OP,MPI_ERR_TOPOLOGY
      integer MPI_ERR_DIMS,MPI_ERR_ARG,MPI_ERR_UNKNOWN,MPI_ERR_TRUNCATE
      integer MPI_ERR_OTHER,MPI_ERR_INTERN,MPI_ERR_IN_STATUS
      integer MPI_PENDING,MPI_ERR_PENDING,MPI_ERR_NOT_SAME
      integer MPI_ERR_LASTCODE
      parameter (MPI_SUCCESS=0,MPI_ERR_BUFFER=50,MPI_ERR_COUNT=51)
      parameter (MPI_ERR_TYPE=52,MPI_ERR_TAG=53,MPI_ERR_COMM=54)
      parameter (MPI_ERR_RANK=55,MPI_ERR_REQUEST=56,MPI_ERR_ROOT=57)
      parameter (MPI_ERR_GROUP=58,MPI_ERR_OP=59,MPI_ERR_TOPOLOGY=60)
      parameter (MPI_ERR_DIMS=61,MPI_ERR_ARG=62,MPI_ERR_UNKNOWN=63)
      parameter (MPI_ERR_TRUNCATE=64,MPI_ERR_OTHER=65,MPI_ERR_INTERN=66)
      parameter (MPI_ERR_IN_STATUS=67,MPI_PENDING=68,MPI_ERR_PENDING=68)
      parameter (MPI_ERR_NOT_SAME=74,MPI_ERR_LASTCODE=250)
 
      integer MPI_PROC_NULL,MPI_ANY_SOURCE,MPI_ANY_TAG,MPI_UNDEFINED
      parameter (MPI_PROC_NULL=-3,MPI_ANY_SOURCE=-1)
      parameter (MPI_ANY_TAG=-1,MPI_UNDEFINED=-1)
 
      integer MPI_STATUS_SIZE,MPI_SOURCE,MPI_TAG,MPI_ERROR
      parameter (MPI_STATUS_SIZE=8,MPI_SOURCE=1,MPI_TAG=2,MPI_ERROR=3)
 
      integer MPI_ERRORS_ARE_FATAL,MPI_ERRORS_RETURN,MPE_ERRORS_WARN
      parameter (MPI_ERRORS_ARE_FATAL=0,MPI_ERRORS_RETURN=1)
      parameter (MPE_ERRORS_WARN=2)
 
      integer MPI_MAX_PROCESSOR_NAME,MPI_MAX_ERROR_STRING
      parameter (MPI_MAX_PROCESSOR_NAME=256,MPI_MAX_ERROR_STRING=128)
 
      integer MPI_BSEND_OVERHEAD
      parameter (MPI_BSEND_OVERHEAD=23)
 
      integer MPI_LB,MPI_UB,MPI_BYTE,MPI_PACKED
      parameter (MPI_LB=0,MPI_UB=1,MPI_BYTE=2,MPI_PACKED=3)
 
      integer MPI_CHAR,MPI_UNSIGNED_CHAR,MPI_SIGNED_CHAR,MPI_SHORT
      integer MPI_INT,MPI_LONG,MPI_UNSIGNED_SHORT,MPI_UNSIGNED
      integer MPI_UNSIGNED_LONG,MPI_FLOAT,MPI_DOUBLE,MPI_LONG_DOUBLE
      integer MPI_LONG_LONG_INT,MPI_LONG_LONG,MPI_UNSIGNED_LONG_LONG
      integer MPI_WCHAR
      parameter (MPI_CHAR=4,MPI_UNSIGNED_CHAR=5,MPI_SIGNED_CHAR=6)
      parameter (MPI_SHORT=7,MPI_INT=8,MPI_LONG=9)
      parameter (MPI_UNSIGNED_SHORT=10,MPI_UNSIGNED=11)
      parameter (MPI_UNSIGNED_LONG=12,MPI_FLOAT=13,MPI_DOUBLE=14)
      parameter (MPI_LONG_DOUBLE=15,MPI_LONG_LONG_INT=39)
      parameter (MPI_LONG_LONG=39,MPI_UNSIGNED_LONG_LONG=40)
      parameter (MPI_WCHAR=41)

 
      integer MPI_INTEGER1,MPI_INTEGER2,MPI_INTEGER4,MPI_INTEGER
      integer MPI_REAL4,MPI_REAL,MPI_REAL8,MPI_DOUBLE_PRECISION
      integer MPI_REAL16,MPI_COMPLEX8,MPI_COMPLEX,MPI_COMPLEX16
      integer MPI_DOUBLE_COMPLEX,MPI_COMPLEX32,MPI_LOGICAL1
      integer MPI_LOGICAL2,MPI_LOGICAL4,MPI_LOGICAL,MPI_CHARACTER
      parameter (MPI_INTEGER1=16,MPI_INTEGER2=17,MPI_INTEGER4=18)
      parameter (MPI_INTEGER=18,MPI_REAL4=19,MPI_REAL=19,MPI_REAL8=20)
      parameter (MPI_DOUBLE_PRECISION=20,MPI_REAL16=21,MPI_COMPLEX8=22)
      parameter (MPI_COMPLEX=22,MPI_COMPLEX16=23,MPI_DOUBLE_COMPLEX=23)
      parameter (MPI_COMPLEX32=24,MPI_LOGICAL1=25,MPI_LOGICAL2=26)
      parameter (MPI_LOGICAL4=27,MPI_LOGICAL=27,MPI_CHARACTER=28)
 
      integer MPI_2REAL,MPI_2DOUBLE_PRECISION,MPI_2INTEGER,MPI_2COMPLEX
      parameter (MPI_2REAL=35,MPI_2DOUBLE_PRECISION=36,MPI_2INTEGER=37)
      parameter (MPI_2COMPLEX=38)
 
      integer MPI_INTEGER8,MPI_LOGICAL8
      parameter (MPI_INTEGER8=42,MPI_LOGICAL8=43)

      integer MPI_COMM_WORLD,MPI_COMM_SELF
      parameter (MPI_COMM_WORLD=0,MPI_COMM_SELF=1)
 
      integer MPI_IDENT,MPI_CONGRUENT,MPI_SIMILAR,MPI_UNEQUAL
      parameter (MPI_IDENT=0,MPI_CONGRUENT=1,MPI_SIMILAR=2)
      parameter (MPI_UNEQUAL=3)
 
      integer MPI_TAG_UB,MPI_IO,MPI_HOST,MPI_WTIME_IS_GLOBAL
      parameter (MPI_TAG_UB=0,MPI_IO=1,MPI_HOST=2,MPI_WTIME_IS_GLOBAL=3)
 
      integer MPI_MAX,MPI_MIN,MPI_SUM,MPI_PROD,MPI_MAXLOC,MPI_MINLOC
      integer MPI_BAND,MPI_BOR,MPI_BXOR,MPI_LAND,MPI_LOR,MPI_LXOR,MAX_OP
      parameter (MPI_MAX=0,MPI_MIN=1,MPI_SUM=2,MPI_PROD=3,MPI_MAXLOC=4)
      parameter (MPI_MINLOC=5,MPI_BAND=6,MPI_BOR=7,MPI_BXOR=8)
      parameter (MPI_LAND=9,MPI_LOR=10,MPI_LXOR=11,MAX_OP=12)
 
      integer MPI_GROUP_NULL,MPI_COMM_NULL,MPI_DATATYPE_NULL
      integer MPI_REQUEST_NULL,MPI_OP_NULL,MPI_ERRHANDLER_NULL
      parameter(MPI_GROUP_NULL=-1,MPI_COMM_NULL=-1,MPI_DATATYPE_NULL=-1)
      parameter (MPI_REQUEST_NULL=-1,MPI_OP_NULL=-1)

      parameter (MPI_ERRHANDLER_NULL=-1) 
      integer MPI_GROUP_EMPTY
      parameter (MPI_GROUP_EMPTY=0)
 
      integer  MPI_GRAPH,MPI_CART
      parameter (MPI_GRAPH=0,MPI_CART=1)
 
      integer MPI_KEYVAL_INVALID
      parameter (MPI_KEYVAL_INVALID=-1)
 
      double precision MPI_WTICK,MPI_WTIME,PMPI_WTICK,PMPI_WTIME
      external MPI_WTICK,MPI_WTIME,PMPI_WTICK,PMPI_WTIME
 
      external MPI_NULL_COPY_FN,MPI_DUP_FN,MPI_NULL_DELETE_FN
      external MPI_BOTTOM

