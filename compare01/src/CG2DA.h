C $Id$
C     Common block used to hold 2d Laplace operator used in elliptic inversion 
C     code.
      COMMON /CG2DA/ aX, aY, aNorm2d
      REAL aX(0:Nx+1,0:Ny+1)
      REAL aY(0:Nx+1,0:Ny+1)
      REAL aNorm2d
