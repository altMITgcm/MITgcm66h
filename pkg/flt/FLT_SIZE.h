C $Header$
C $Name$

C     ==================================================================
C     HEADER FLT_SIZE
C     ==================================================================

C== Size ==

C     max_npart_tile :: maximum number of floats on a tile
C                       normally npart_tile < max_npart, but could be the same
C                       for safety
C     max_npart_exch :: maximum number of floats on a tile that can be
C                       exchanged at one time
C                       normally max_npart_exch < max_npart_tile,
C                       but could be the same for safety
C
      INTEGER max_npart_tile, max_npart_exch
      PARAMETER (max_npart_tile = 300)
      PARAMETER (max_npart_exch =  50)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
