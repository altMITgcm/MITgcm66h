C $Header$
C $Name$

C     ==========================================================
C     | BLING_CTRL.h
C     | o Control of Biological Carbon Variables
C     ==========================================================

      integer    bling_n_control
      parameter( bling_n_control = 2 )
      COMMON /BLING_XX_R/ xx_bling
      _RL               xx_bling(bling_n_control)

