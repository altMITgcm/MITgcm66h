C $Header$
C $Name$

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: INI_TR1
C     !INTERFACE:
      SUBROUTINE INI_TR1( myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE INI_TR1                                        
C     | o Set initial tracer 1 distribution.                      
C     *==========================================================*
C     | Passive tracers 1-N can be initialised so as to dye fluid.                                                
C     | This routine is hardcoded for OCMIP CFC-11 experiment.
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#ifdef ALLOW_PASSIVE_TRACER
#include "TR1.h"
#endif

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid -  Number of this instance of INI_TR1
      INTEGER myThid

#ifdef ALLOW_PASSIVE_TRACER

C     !LOCAL VARIABLES:
C     == Local variables ==
C     iC, jC - Center of domain
C     iD, jD - Disitance from domain center.
C     rad    - Radius of initial patch
C     rD     - Radial displacement of point I,J
C     iG, jG - Global coordinate index
C     bi,bj  - Loop counters
C     I,J,K
      INTEGER iC, jC, iD, jD
      INTEGER iG, jG
      INTEGER bi, bj
      INTEGER I, J, K, localWarnings
      _RL     rad, rD
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      _BARRIER

C--   Initialise tracer to inline.
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         DO J=1,sNy
          DO I=1,sNx
            tr1(I,J,K,bi,bj) = 0. _d 0
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO
C     Set initial tendency terms
      localWarnings=0
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         DO J=1,sNy
          DO I=1,sNx
           gtr1   (I,J,K,bi,bj) = 0. _d 0
           gtr1NM1(I,J,K,bi,bj) = 0. _d 0
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO
C
      _EXCH_XYZ_R8(tr1 , myThid )
      _EXCH_XYZ_R8(gtr1 , myThid )
      _EXCH_XYZ_R8(gtr1NM1 , myThid )

      CALL PLOT_FIELD_XYZRL( tr1, 'Initial TR1' , 
     &                       Nr, 1, myThid )

C--   Input file names
      FiceFile = 'FICE'
      XkwFile  = 'XKW'
      PatmFile = 'PATM'

C--   Compute numbers need to determine pCFC
      CALL read_cfcatm
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
          IF     ( yC(I,J,bi,bj) .GE.  10. ) THEN
           pCFCw1(I,J,bi,bj) = 1.
           pCFCw2(I,J,bi,bj) = 0.
          ELSEIF ( yC(I,J,bi,bj) .LE. -10. ) THEN
           pCFCw1(I,J,bi,bj) = 0.
           pCFCw2(I,J,bi,bj) = 1.
          ELSE
           pCFCw1(I,J,bi,bj) = ( yC(I,J,bi,bj) + 10. ) / 20.
           pCFCw2(I,J,bi,bj) = ( 10. - yC(I,J,bi,bj) ) / 20.
          ENDIF
         ENDDO
        ENDDO
       ENDDO
      ENDDO
      _EXCH_XY_R8(pCFCw1 , myThid )
      _EXCH_XY_R8(pCFCw2 , myThid )

#endif /*  ALLOW_PASSIVE_TRACER */

      RETURN
      END

C====================================================================

c_ ---------------------------------------------------------------------
c_ RCS lines preceded by "c_ "
c_ ---------------------------------------------------------------------
c_
c_ $Source$
c_ $Revision$
c_ $Date$   ;  $State$
c_ $Author$ ;  $Locker$
c_
c_ ---------------------------------------------------------------------
c_ $Log$
c_ Revision 1.1.2.1  2005/08/25 16:22:17  dimitri
c_ adding ecco1x1 verification/global_with_CFC11 experiment
c_
c_ Revision 1.1.2.1  2003/05/03 04:27:34  dimitri
c_ Branched off release1_p15
c_ Modified pkg/exf/exf_clim_param.h, exf_clim_readparms.F,
c_    exf_set_climsss.F, and exf_set_climsst.F to add new_interp
c_    capability to SST and SSS
c_ Added verification/global_with_CFC11/code50yr and input50yr
c_
c_ Revision 1.1.2.1  2003/05/01 18:18:29  dimitri
c_ release1_p15
c_ o Added CFC-11 diagnostics, see
c_   verification/global_with_CFC11/README
c_
c_ Revision 1.2  1998/07/20 15:33:32  jomce
c_ Used new data set from Walker et al. (sent by J. Bullister 17/7/1998)
c_ from mid 1931 to mid 1997.  Format of cfc1112.atm has changed.  This
c_ file modified accordingly, and old atm record moved to old/cfc1112.atm.old
c_
c_ Revision 1.1  1998/07/07 15:22:00  orr
c_ Initial revision
c_
c_ ---------------------------------------------------------------------
c_
      SUBROUTINE read_cfcatm

C     --------------------------------------------------------------------
C     Reads temporal history of atmospheric CFC-11 and CFC-12 (both in pptv)
C
C     year         = year of measurement (mid-year)
C     p11(year,nt) = pcfc11  in northern (1) and southern (2) hemisphere 
C     p12(year,nt) = pcfc12  in northern (1) and southern (2) hemisphere 
C     --------------------------------------------------------------------

c      Jean-Claude Dutay, LSCE/CEA-CNRS, Saclay, France, 10 May 1998
c      - modfied by J. Orr (9 June 1998)

      IMPLICIT NONE 
#include "SIZE.h"
#include "EEPARAMS.h"
#include "TR1.h"

      INTEGER i, n, iu
      PARAMETER (iu=10)

      CHARACTER*80 filen
C
C     OPEN FILE
C     ---------
      filen='cfc1112.atm'
      OPEN(UNIT=iu,FILE=filen,STATUS='old')
c
c     Skip over 1st six descriptor lines
c     ----------------------------------
      DO i=1,6
        READ(iu,99)
      END do    

C
C     READ FILE
C     ---------
      DO n = nyrbeg, nyrend
        READ(iu,*)
     +      CFCyear(n), CFCp11(n,1), CFCp12(n,1)
     +     ,            CFCp11(n,2), CFCp12(n,2)
        WRITE(6,100)
     +      CFCyear(n), CFCp11(n,1), CFCp12(n,1)
     +     ,            CFCp11(n,2), CFCp12(n,2)
      END DO 

 99   FORMAT(1x)
 100  FORMAT(f7.2, 4f8.2)

      RETURN
      END 
