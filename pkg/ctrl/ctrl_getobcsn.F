
#include "CTRL_CPPOPTIONS.h"
#ifdef ALLOW_OBCS
# include "OBCS_OPTIONS.h"
#endif


      subroutine ctrl_getobcsn(
     I                             mytime,
     I                             myiter,
     I                             mythid
     &                           )

c     ==================================================================
c     SUBROUTINE ctrl_getobcsn
c     ==================================================================
c
c     o Get northern obc of the control vector and add it
c       to dyn. fields
c
c     started: heimbach@mit.edu, 29-Aug-2001
c
c     ==================================================================
c     SUBROUTINE ctrl_getobcsn
c     ==================================================================

      implicit none

#ifdef ALLOW_OBCSN_CONTROL

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"
#include "OBCS.h"

#include "ctrl.h"
#include "ctrl_dummy.h"
#include "optim.h"

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer ilobcsn
      integer iobcs
      integer jp1

      _RL     dummy
      _RL     obcsnfac
      logical obcsnfirst
      logical obcsnchanged
      integer obcsncount0
      integer obcsncount1

cgg      _RL maskxz   (1-olx:snx+olx,nr,nsx,nsy)

      logical doglobalread
      logical ladinit

      character*(80) fnameobcsn

#ifdef BALANCE_CONTROL_VOLFLUX
cgg(  Variables for balancing volume flux.
      _RL vbaro
      _RL vbarocount
#endif

c     == external functions ==

      integer  ilnblnk
      external ilnblnk


c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1-oly
      jmax = sny+oly
      imin = 1-olx
      imax = snx+olx
      jp1  = 0

#ifdef BALANCE_CONTROL_VOLFLUX
cgg(  Initialize variables for balancing volume flux.
      vbaro = 0.d0
      vbarocount = 0.d0
cgg)
#endif

c--   Now, read the control vector.
      doglobalread = .false.
      ladinit      = .false.

      if (optimcycle .ge. 0) then
        ilobcsn=ilnblnk( xx_obcsn_file )
        write(fnameobcsn(1:80),'(2a,i10.10)') 
     &       xx_obcsn_file(1:ilobcsn), '.', optimcycle
      else
        print*
        print*,' ctrl_getobcsn: optimcycle not set correctly.'
        print*,' ... stopped in ctrl_getobcsn.'
      endif

c--   Get the counters, flags, and the interpolation factor.
      call ctrl_GetRec( 'xx_obcsn',
     O                   obcsnfac, obcsnfirst, obcsnchanged,
     O                   obcsncount0,obcsncount1,
     I                   mytime, myiter, mythid )

      do iobcs = 1,nobcs
cgg   Reading the mask seems to take a lot of time. Replace with maskS, maskW, etc.       
cgg        call active_read_xz( 'maskobcsn', maskxz, 
cgg     &                         iobcs,
cgg     &                         doglobalread, ladinit, 0,
cgg     &                         mythid, dummy )

        if ( obcsnfirst ) then
          call active_read_xz( fnameobcsn, tmpfldxz, 
     &                         (obcsncount0-1)*nobcs+iobcs,
     &                         doglobalread, ladinit, optimcycle,
     &                         mythid, xx_obcsn_dummy )

#ifdef BALANCE_CONTROL_VOLFLUX
          if ( optimcycle .gt. 0) then           
            if (iobcs .eq. 4) then
cgg         Make sure that the xx velocity field has a balanced net volume flux.
cgg         Find the barotropic flow normal to the boundary.
cgg         For the north, this is the v velocity, iobcs = 4.
cgg         This is done on a columnwise basis here.
              do bj = jtlo,jthi
                do bi = itlo, ithi
                  do i = imin,imax
                    j = OB_Jn(I,bi,bj)
                    vbaro = 0.d0
                    vbarocount = 0.d0
                    do k = 1,nr
cgg    If cells are not full, this should be modified with hFac.
                      vbaro = tmpfldxz(i,k,bi,bj)*maskS(i,j+jp1,k,bi,bj)
     &                      * delZ(k) + vbaro 
                      vbarocount = maskS(i,j+jp1,k,bi,bj)
     &                           * delZ(k) +vbarocount
                    enddo
                    if (vbarocount .eq. 0.) then
                      vbaro = 0.
                    else
                      vbaro = vbaro / vbarocount
                    endif
                    do k = 1,nr
                      tmpfldxz(i,k,bi,bj) = tmpfldxz(i,k,bi,bj) - vbaro
                    enddo
                  enddo
                enddo
              enddo
            endif
          endif
#endif
#ifdef BALANCE_CONTROL_VOLFLUX_GLOBAL 
cgg      Use the barotropic adjustment previously calculated
cgg      in ctrl_obcsvol to volumetrically balance the control
cgg      velocities in a global sense. 
         if (optimcycle .gt. 0) then
            if ( iobcs .eq. 4) then
              do bj = jtlo,jthi
                do bi = itlo, ithi
                  do k = 1,Nr
                    do i = imin,imax
                      j = OB_Jn(I,bi,bj)
                      tmpfldxz(i,k,bi,bj) = tmpfldxz(i,k,bi,bj) 
     &                   + shiftvel(1) *maskS(i,j+jp1,k,bi,bj)
                    enddo
                  enddo
                enddo
              enddo
            endif
          endif
#endif
          do bj = jtlo,jthi
            do bi = itlo,ithi
              do k = 1,nr
                do i = imin,imax 
                  xx_obcsn1(i,k,bi,bj,iobcs)  = tmpfldxz (i,k,bi,bj)
                enddo
              enddo
            enddo
          enddo
        endif

        if ( (obcsnfirst) .or. (obcsnchanged)) then
          
          do bj = jtlo,jthi
            do bi = itlo,ithi
              do k = 1,nr
                do i = imin,imax
                  tmpfldxz(i,k,bi,bj) = xx_obcsn1(i,k,bi,bj,iobcs)
                enddo
              enddo
            enddo
          enddo

          call exf_swapffields_xz( tmpfldxz2, tmpfldxz, mythid)

          do bj = jtlo,jthi
            do bi = itlo,ithi
              do k = 1,nr
                do i = imin,imax
                    xx_obcsn0(i,k,bi,bj,iobcs) = tmpfldxz2(i,k,bi,bj)        
                enddo
              enddo
            enddo
          enddo

          call active_read_xz( fnameobcsn, tmpfldxz, 
     &                         (obcsncount1-1)*nobcs+iobcs,
     &                         doglobalread, ladinit, optimcycle,
     &                         mythid, xx_obcsn_dummy )

#ifdef BALANCE_CONTROL_VOLFLUX
          if (optimcycle .gt. 0) then
            if (iobcs .eq. 4) then
cgg(        Make sure that the xx velocity field has a balanced net volume flux.
cgg         Find the barotropic flow normal to the boundary.
cgg         For the north, this is the v velocity, iobcs = 4.
              do bj = jtlo,jthi
                do bi = itlo, ithi
                  do i = imin,imax

cgg( Balance volume flux columnwise.
                    j = OB_Jn(I,bi,bj)
                    vbaro = 0.d0
                    vbarocount = 0.d0
                    do k = 1,nr
cgg(   If cells are not full, this should be modified with hFac.
                      vbaro = tmpfldxz(i,k,bi,bj)
     &                      * delZ(k) + vbaro 
                      vbarocount = maskS(i,j+jp1,k,bi,bj) 
     &                           * delZ(k)+ vbarocount
                    enddo
                    if (vbarocount .eq. 0.) then
                      vbaro = 0.
                    else
                      vbaro = vbaro / vbarocount
                    endif
                    do k = 1,nr
                      tmpfldxz(i,k,bi,bj) = tmpfldxz(i,k,bi,bj) - vbaro
                    enddo
                  enddo
                enddo
              enddo
            endif
          endif
cgg)
#endif
#ifdef BALANCE_CONTROL_VOLFLUX_GLOBAL 
          if (optimcycle .gt. 0) then
            if ( iobcs .eq. 4) then
              do bj = jtlo,jthi
                do bi = itlo, ithi
                  do k = 1,Nr
                    do i = imin,imax
                      j = OB_Jn(I,bi,bj)
                      tmpfldxz(i,k,bi,bj) = tmpfldxz(i,k,bi,bj) 
     &                   + shiftvel(2) *maskS(i,j+jp1,k,bi,bj)
                    enddo
                  enddo
                enddo
              enddo
            endif
          endif
#endif
          do bj = jtlo,jthi
            do bi = itlo,ithi
              do k = 1,nr
                do i = imin,imax
                  xx_obcsn1 (i,k,bi,bj,iobcs) = tmpfldxz (i,k,bi,bj)
                 enddo
              enddo
            enddo
          enddo

        endif

c--     Add control to model variable.
        do bj = jtlo,jthi
           do bi = itlo,ithi
c--        Calculate mask for tracer cells (0 => land, 1 => water).
              do k = 1,nr
                 do i = 1,snx
                    j = OB_Jn(I,bi,bj)
                    if (iobcs .EQ. 1) then
                       OBNt(i,k,bi,bj) = OBNt (i,k,bi,bj)
     &                 + obcsnfac            *xx_obcsn0(i,k,bi,bj,iobcs)
     &                 + (1. _d 0 - obcsnfac)*xx_obcsn1(i,k,bi,bj,iobcs)
                       OBNt(i,k,bi,bj) = OBNt(i,k,bi,bj)
     &                         *maskS(i,j+jp1,k,bi,bj)
cgg     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 2) then
                       OBNs(i,k,bi,bj) = OBNs (i,k,bi,bj)
     &                 + obcsnfac            *xx_obcsn0(i,k,bi,bj,iobcs)
     &                 + (1. _d 0 - obcsnfac)*xx_obcsn1(i,k,bi,bj,iobcs)
                       OBNs(i,k,bi,bj) = OBNs(i,k,bi,bj)
     &                         *maskS(i,j+jp1,k,bi,bj)
cgg     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 3) then
                       OBNu(i,k,bi,bj) = OBNu (i,k,bi,bj)
     &                 + obcsnfac            *xx_obcsn0(i,k,bi,bj,iobcs)
     &                 + (1. _d 0 - obcsnfac)*xx_obcsn1(i,k,bi,bj,iobcs)
                       OBNu(i,k,bi,bj) = OBNu(i,k,bi,bj)
     &                         *maskW(i,j,k,bi,bj)
cgg     &                      *maskxz(i,k,bi,bj)
                    else if (iobcs .EQ. 4) then
                       OBNv(i,k,bi,bj) = OBNv (i,k,bi,bj)
     &                 + obcsnfac            *xx_obcsn0(i,k,bi,bj,iobcs)
     &                 + (1. _d 0 - obcsnfac)*xx_obcsn1(i,k,bi,bj,iobcs)
                       OBNv(i,k,bi,bj) = OBNv(i,k,bi,bj)
     &                         *maskS(i,j+jp1,k,bi,bj)
cgg     &                      *maskxz(i,k,bi,bj)
                    endif
                 enddo
              enddo
           enddo
        enddo

C--   End over iobcs loop
      enddo
      
#else /* ALLOW_OBCSN_CONTROL undefined */

c     == routine arguments ==

      _RL     mytime
      integer myiter
      integer mythid

c--   CPP flag ALLOW_OBCSN_CONTROL undefined.

#endif /* ALLOW_OBCSN_CONTROL */

      end





