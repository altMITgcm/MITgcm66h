C     nsolve      - number of interior points of one tile
C     ninterf     - number of local owned interface values
C     nrhs        - number of interface values per tile (owned and neighbour owned)
C     ntiles      - overall number of tiles
C     kdsolve     - number of off diagonals in band matrix

      integer    nsolve
      parameter( nsolve = (sNx-1) * (sNy-1) )

      integer    ninterf
      parameter( ninterf = 1 + (sNx-1) + (sNy-1) )

      integer    nrhs
      parameter( nrhs = 2*((sNx-1)+(sNy-1)) )

      integer    ntiles
      parameter( ntiles = nPx*nPy*nSx*nSy )

      integer    kdsolve
      parameter( kdsolve = sNy-1 )

      double precision solve_band(kdsolve+1,2:sNy,2:sNx,nSx,nSy)
      _RL    ss(ninterf*nSx*nSy,nPx*nPy,ninterf*nSx*nSy)
      integer ipiv(nsolve)
      logical use_cg2d

      common /csolve_r/  solve_band, ss
      common /csolve_i/  ipiv, use_cg2d
