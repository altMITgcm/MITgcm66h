C $Id$
C     Values of previous time derivatives used in Adams Bashforth
C     timestepping.
      COMMON /OldG/ guNM1, gvNM1, gtNM1, gsNM1
      REAL guNM1 (_I3(nz,nx,ny))
      REAL gvNM1 (_I3(nz,nx,ny))
      REAL gtNM1 (_I3(nz,nx,ny))
      REAL gsNM1 (_I3(nz,nx,ny))
