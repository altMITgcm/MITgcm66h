
#include "COST_CPPOPTIONS.h"


      subroutine cost_init_barfiles( mythid )

c     ==================================================================
c     SUBROUTINE cost_init_barfiles
c     ==================================================================
c
c--   Initialise adjoint of monthly mean files calculated
c--   in cost_averagesfields (and their ad...).
c
c     started: heimbach@mit.edu 20-Mar-2002
c
c     ==================================================================
c     SUBROUTINE cost_cost_init_barfiles
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

#include "optim.h"
#include "cost.h"
#include "ctrl.h"
#include "ctrl_dummy.h"

c     == routine arguments ==

      integer mythid

#ifdef ALLOW_COST
c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax

      integer ilps, ils, ilt, irec

      character*(128) fnamepsbar
      character*(128) fnametbar
      character*(128) fnamesbar
      character*(128) fnameubar
      character*(128) fnamevbar
      character*(128) adfnamepsbar
      character*(128) adfnametbar
      character*(128) adfnamesbar
      character*(128) adfnameubar
      character*(128) adfnamevbar

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1
      jmax = sny
      imin = 1
      imax = snx

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i =  imin,imax
              tmpfld2d(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do k = 1,nr
            do j = jmin,jmax
              do i =  imin,imax
                tmpfld3d(i,j,k,bi,bj) = 0. _d 0
              enddo
            enddo
          enddo
        enddo
      enddo

#ifdef ALLOW_SSH_COST_CONTRIBUTION

c--   Save psbar on file.
      ilps=ilnblnk( psbarfile )
      write(fnamepsbar,'(2a,i10.10)') 
     &     psbarfile(1:ilps), '.', optimcycle
      write(adfnamepsbar,'(3a,i10.10)')
     &     yadmark, psbarfile(1:ilps), '.', optimcycle

      do irec = 1, ndaysrec
        call active_write_xy( fnamepsbar, tmpfld2d, irec,
     &                        optimcycle, mythid, xx_psbar_mean_dummy )
        call active_write_xy( adfnamepsbar, tmpfld2d, irec,
     &                         optimcycle,mythid, xx_psbar_mean_dummy )
      enddo

#endif /* ALLOW_SSH_COST_CONTRIBUTION */

#if (defined (ALLOW_THETA_COST_CONTRIBUTION) || \
     defined (ALLOW_SST_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDT_COST_CONTRIBUTION) || \
     defined (ALLOW_XBT_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))

c--   Save tbar on file.
      ilt=ilnblnk( tbarfile )
      write(fnametbar,'(2a,i10.10)') 
     &     tbarfile(1:ilt), '.', optimcycle
      write(adfnametbar,'(3a,i10.10)') 
     &     yadmark, tbarfile(1:ilt), '.', optimcycle

      do irec = 1,nmonsrec
        call active_write_xyz( fnametbar, tmpfld3d, nmonsrec,
     &                         optimcycle, mythid, xx_tbar_mean_dummy )
        call active_write_xyz( adfnametbar, tmpfld3d, nmonsrec, 
     &                         optimcycle, mythid, xx_tbar_mean_dummy )
      enddo

#endif

#if (defined (ALLOW_SALT_COST_CONTRIBUTION) || \
     defined (ALLOW_SSS_COST_CONTRIBUTION) || \
     defined (ALLOW_CTDS_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))

c--   Save sbar.
      ils=ilnblnk( sbarfile )
      write(fnamesbar,'(2a,i10.10)') 
     &     sbarfile(1:ils), '.', optimcycle
      write(adfnamesbar,'(3a,i10.10)') 
     &     yadmark, sbarfile(1:ils), '.', optimcycle

      do irec = 1,nmonsrec
        call active_write_xyz( fnamesbar, tmpfld3d, nmonsrec,
     &                         optimcycle, mythid, xx_sbar_mean_dummy)
        call active_write_xyz( adfnamesbar, tmpfld3d, nmonsrec,
     &                         optimcycle, mythid, xx_sbar_mean_dummy)
      enddo

#endif

#if (defined (ALLOW_DRIFTER_COST_CONTRIBUTION) || \
     defined (ALLOW_OBCS_COST_CONTRIBUTION))

c--   Save ubar and vbar.
      ils=ilnblnk( ubarfile )
      write(fnameubar,'(2a,i10.10)') 
     &     ubarfile(1:ils), '.', optimcycle
      write(fnamevbar,'(2a,i10.10)') 
     &     vbarfile(1:ils), '.', optimcycle
      write(adfnameubar,'(3a,i10.10)') 
     &     yadmark, ubarfile(1:ils), '.', optimcycle
      write(adfnamevbar,'(3a,i10.10)') 
     &     yadmark, vbarfile(1:ils), '.', optimcycle

        call active_write_xyz( fnameubar, ubar, 1,
     &                         optimcycle, mythid, xx_ubar_mean_dummy)
        call active_write_xyz( fnamevbar, vbar, 1,
     &                         optimcycle, mythid, xx_vbar_mean_dummy)
        call active_write_xyz( adfnameubar, ubar, 1,
     &                         optimcycle, mythid, xx_ubar_mean_dummy)
        call active_write_xyz( adfnamevbar, vbar, 1,
     &                         optimcycle, mythid, xx_vbar_mean_dummy)

#endif

#endif /* ALLOW_COST */

      return
      end

