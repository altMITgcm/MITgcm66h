
      subroutine optim_writedata(
     I                       nn,
     I                       dfile,
     I                       lheaderonly,
     I                       ff,
     I                       vv
     &                     ) 

c     ==================================================================
c     SUBROUTINE optim_writedata
c     ==================================================================
c
c     o Writes the latest update of the control vector to file(s). These
c       files can then be used by the MITgcmUV state estimation setup
c       for the next forward/adjoint simluation.
c
c     started: Christian Eckert eckert@mit.edu 12-Apr-2000
c
c     changed:  Patrick Heimbach heimbach@mit.edu 19-Jun-2000
c               - finished, revised and debugged
c
c     ==================================================================
c     SUBROUTINE optim_writedata
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

#include "ecco.h"
#include "ctrl.h"
#include "optim.h"
#include "minimization.h"

c     == routine arguments ==

      integer nn
      _RL     ff
      _RL     vv(nn)

      character*(9) dfile
      logical lheaderonly

c     == local variables ==

      integer i,j,k
      integer ii
      integer bi,bj
      integer biG,bjG
      integer nopt
      integer icvcomp
      integer icvoffset
      integer icvrec
      integer icvar
      integer funit
      integer cbuffindex

      _RL     cbuff( sNx*nSx*nPx*sNy*nSy*nPy )

      character*(128) fname

c     == end of interface ==

c--   I/O unit to use.
      funit = 20

c--   Next optimization cycle.
      nopt = optimcycle + 1

      if ( dfile .eq. ctrlname ) then
        print*
        print*,' OPTIM_WRITEDATA: Writing new control vector to file(s)'
        print*,'             for optimization cycle: ',nopt
        print*
      else
        print*
        print*,' OPTIM_WRITEDATA: subroutine called by a false *dfile*'
        print*,'             argument. *dfile* = ',dfile
        print*
        stop   '  ...  stopped in OPTIM_WRITEDATA.'
      endif

      bjG = 1 + (myygloballo - 1)/sny
      biG = 1 + (myxgloballo - 1)/snx

c--         Generate file name and open the file.
      write(fname(1:128),'(4a,i4.4)')
     &     dfile,'_',expId(1:10),'.opt', nopt
      open( funit, file   = fname,
     &     status = 'new',
     &     form   = 'unformatted',
     &     access = 'sequential'   )

cph(
         print *, 'pathei: nvartype ', nvartype
         print *, 'pathei: nvarlength ', nvarlength
         print *, 'pathei: expId ', expId
         print *, 'pathei: nopt ', nopt
         print *, 'pathei: ff ', ff
         print *, 'pathei: iG ', biG
         print *, 'pathei: jG ', bjG
         print *, 'pathei: nsx ', nsx
         print *, 'pathei: nsy ', nsy
         
         print *, 'pathei: nWetcTile ', 
     &        (((nWetcTile(i,j,k), i=1,nsx), j=1,nsy), k=1,nr)
         print *, 'pathei: nWetsTile ', 
     &        (((nWetsTile(i,j,k), i=1,nsx), j=1,nsy), k=1,nr)
         print *, 'pathei: nWetwTile ', 
     &        (((nWetwTile(i,j,k), i=1,nsx), j=1,nsy), k=1,nr)
         print *, 'pathei: ncvarindex ', 
     &        (ncvarindex(i), i=1,maxcvars)
         print *, 'pathei: ncvarrecs ', 
     &        (ncvarrecs(i),  i=1,maxcvars)
         print *, 'pathei: ncvarxmax ', 
     &        (ncvarxmax(i),  i=1,maxcvars)
         print *, 'pathei: ncvarymax ', 
     &        (ncvarymax(i),  i=1,maxcvars)
         print *, 'pathei: ncvarnrmax ', 
     &        (ncvarnrmax(i), i=1,maxcvars)
         print *, 'pathei: ncvargrd ', 
     &        (ncvargrd(i),   i=1,maxcvars)
cph)

c--   Write the header.
      write( funit ) nvartype
      write( funit ) nvarlength
      write( funit ) expId
      write( funit ) optimcycle
      write( funit ) ff
      write( funit ) big
      write( funit ) bjg
      write( funit ) nsx
      write( funit ) nsy
      write( funit ) (((nWetcTile(i,j,k), i=1,nsx), j=1,nsy),
     &     k=1,nr)
      write( funit ) (((nWetsTile(i,j,k), i=1,nsx), j=1,nsy),
     &     k=1,nr)
      write( funit ) (((nWetwTile(i,j,k), i=1,nsx), j=1,nsy),
     &     k=1,nr)
      write( funit ) (ncvarindex(i), i=1,maxcvars)
      write( funit ) (ncvarrecs(i),  i=1,maxcvars)
      write( funit ) (ncvarxmax(i),  i=1,maxcvars)
      write( funit ) (ncvarymax(i),  i=1,maxcvars)
      write( funit ) (ncvarnrmax(i), i=1,maxcvars)
      write( funit ) (ncvargrd(i),   i=1,maxcvars)
      write( funit )

c--         Write the data.
      icvoffset = 0
      do icvar = 1,maxcvars
         if ( ncvarindex(icvar) .ne. -1 ) then
            do icvrec = 1,ncvarrecs(icvar)
cph(
               print *,'in owd: icvar, icvrec, ncvarrecs, ncvarindex',
     &              icvar, icvrec, ncvarrecs(icvar), ncvarindex(icvar)
cph)
               do bj = 1,nsy
                  do bi = 1,nsx
                     write( funit ) ncvarindex(icvar)
                     write( funit ) bj
                     write( funit ) bi
                     do k = 1,ncvarnrmax(icvar)
                        cbuffindex = 0
                        if (ncvargrd(icvar) .eq. 'c') then
                           cbuffindex = nwetctile(bi,bj,k)
                        else if (ncvargrd(icvar) .eq. 's') then
                           cbuffindex = nwetstile(bi,bj,k)
                        else if (ncvargrd(icvar) .eq. 'w') then
                           cbuffindex = nwetwtile(bi,bj,k)
                        endif
                        if (cbuffindex .gt. 0) then
                           do icvcomp = 1,cbuffindex
                              cbuff(icvcomp) = vv(icvoffset + icvcomp)
                           enddo
                           write( funit ) cbuffindex
                           write( funit ) k
                           write( funit ) (cbuff(ii), ii=1,cbuffindex)
                           icvoffset = icvoffset + cbuffindex
                        endif
                     enddo
                  enddo
               enddo
            enddo
         endif
      enddo

      close( funit )
cph(
      print *,'in owd: icvoffset', icvoffset
cph)

      return
      end

