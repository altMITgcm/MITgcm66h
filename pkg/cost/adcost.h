
c     ==================================================================
c     HEADER ADCOST
c     ==================================================================
c
c     o Header for model-data comparison; adjoint part.
c
c     The individual cost function contributions are multiplied by
c     factors mult_"var" which allow to switch off these contributions
c     without removing them in the adjoint code. This is useful for
c     doing tests with the adjoint and perhaps useful in assimilation
c     experiments where individual contributions are successively
c     switched on. For future applications it would be better to place
c     the initialisation of the multipliers somewhere else, for example
c     in a namelist, which is read in at the start of the model.
c
c     started: Christian Eckert eckert@mit.edu  06-Apr-2000
c
c     changed: Christian Eckert eckert@mit.edu
c              heimbach@mit.edu:
c              only first entry "adfc" retained.
c
c     ==================================================================
c     HEADER ADCOST
c     ==================================================================

      common /adcost_r/
     &                  adfc
      _RL  adfc

c     ==================================================================
c     END OF HEADER ADCOST
c     ==================================================================

