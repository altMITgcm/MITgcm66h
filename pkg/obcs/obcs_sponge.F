
#include "OBCS_OPTIONS.h"

CStartOfInterface
      SUBROUTINE OBCS_SPONGE_U(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myCurrentTime,myThid)
C     /==========================================================\
C     | S/R OBCS_SPONGE_U                                        |
C     | o Contains problem specific forcing for zonal velocity.  |
C     |==========================================================|
C     | Adds terms to gU for forcing by external sources         |
C     | e.g. wind stress, bottom friction etc..................  |
C     \==========================================================/
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "FFIELDS.h"
#ifdef ALLOW_OBCS
# include "OBCS.h"
# ifdef ALLOW_CALENDAR
#  include "cal.h"
# endif
#endif

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myCurrentTime
      INTEGER myThid
CEndOfInterface

C     == Local variables ==
C     Loop counters
      INTEGER I, J, Isl, Jsl
      _RL urelax, lambda_obcs_u
#ifndef ALLOW_CALENDAR
      INTEGER secondsperday
      PARAMETER (secondsperday=86400)
#endif

#if (defined (ALLOW_OBCS) && defined (ALLOW_OBCS_SPONGE))

      IF (useOBCSsponge) THEN

C Northern Open Boundary
#ifdef ALLOW_OBCS_NORTH
      DO i=iMin,iMax
       IF ((OB_Jn(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Jn(i,bi,bj)-jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN 
          urelax=( 
     &      float(spongeThickness-jsl)*OBNu(i,kLev,bi,bj)
     &    + float(jsl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u = ( 
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl-1)*Vrelaxobcsinner)/ float(spongeThickness-1)

          IF (lambda_obcs_u.ne.0.) THEN 
           lambda_obcs_u = 1. _d 0 /(lambda_obcs_u * secondsperday)
          ELSE 
           lambda_obcs_u = 0. _d 0
          ENDIF 
        
          gU(i,j,kLev,bi,bj) =  gU(i,j,kLev,bi,bj)
     &    - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &    * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF
 
        ENDDO
       ENDIF
      ENDDO
#endif

C Southern Open Boundary
#ifdef ALLOW_OBCS_SOUTH
      DO i=iMin,iMax
       IF ((OB_Js(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Js(i,bi,bj)+jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN         
          urelax=( 
     &      float(spongeThickness-jsl)*OBSu(i,kLev,bi,bj)
     &    + float(jsl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u = ( 
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl-1)*Vrelaxobcsinner)/ float(spongeThickness-1)

          if (lambda_obcs_u.ne.0.) then
            lambda_obcs_u = 1. _d 0 /(lambda_obcs_u * secondsperday)
          else
            lambda_obcs_u = 0. _d 0
          endif

         gU(i,j,kLev,bi,bj) = gU(i,j,kLev,bi,bj)
     &   - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &   * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Eastern Open Boundary 
#ifdef ALLOW_OBCS_EAST
      DO j=jMin,jMax
       IF ((OB_Ie(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Ie(j,bi,bj)-isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN 
          urelax=( 
     &      float(spongeThickness-isl)*OBEu(j,kLev,bi,bj)
     &    + float(isl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u = ( 
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl-1)*Urelaxobcsinner)/ float(spongeThickness-1)

          if (lambda_obcs_u.ne.0.) then
            lambda_obcs_u = 1. _d 0 /(lambda_obcs_u * secondsperday)
          else
            lambda_obcs_u = 0. _d 0
          endif

          gU(i,j,kLev,bi,bj) = gU(i,j,kLev,bi,bj)
     &    - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &    * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Western Open Boundary
#ifdef ALLOW_OBCS_WEST
      DO j=jMin,jMax
       IF ((OB_Iw(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Iw(j,bi,bj)+isl+1

         IF ((i.ge.imin).and.(i.le.imax)) THEN 
          urelax=( 
     &      float(spongeThickness-isl)*OBWu(j,kLev,bi,bj)
     &    + float(isl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u= ( 
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl-1)*Urelaxobcsinner)/ float(spongeThickness-1)

          if (lambda_obcs_u.ne.0.) then
            lambda_obcs_u = 1. _d 0 /(lambda_obcs_u * secondsperday)
          else
            lambda_obcs_u = 0. _d 0
          endif

          gU(i,j,kLev,bi,bj) =  gU(i,j,kLev,bi,bj)
     &    - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &    * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

      ENDIF

#endif

      RETURN
      END

CStartOfInterface
      SUBROUTINE OBCS_SPONGE_V(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myCurrentTime,myThid)
C     /==========================================================\
C     | S/R OBCS_SPONGE_V                                        |
C     | o Contains problem specific forcing for merid velocity.  |
C     |==========================================================|
C     | Adds terms to gV for forcing by external sources         |
C     | e.g. wind stress, bottom friction etc..................  |
C     \==========================================================/
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "FFIELDS.h"
#ifdef ALLOW_OBCS
# include "OBCS.h"
# ifdef ALLOW_CALENDAR
#  include "cal.h"
# endif
#endif

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myCurrentTime
      INTEGER myThid
CEndOfInterface
C     == Local variables ==
C     Loop counters
      INTEGER I, J, Isl, Jsl
      _RL vrelax,lambda_obcs_v
#ifndef ALLOW_CALENDAR
      INTEGER secondsperday
      PARAMETER (secondsperday=86400)
#endif

#if (defined (ALLOW_OBCS) && defined (ALLOW_OBCS_SPONGE))

      IF (useOBCSsponge) THEN

C Northern Open Boundary
#ifdef ALLOW_OBCS_NORTH
      DO i=iMin,iMax
       IF ((OB_Jn(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Jn(i,bi,bj)-jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN 
          vrelax=( 
     &      float(spongeThickness-jsl)*OBNv(i,kLev,bi,bj)
     &    + float(jsl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = ( 
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl-1)*Vrelaxobcsinner)/ float(spongeThickness-1)

          IF (lambda_obcs_v.ne.0.) THEN
            lambda_obcs_v = 1. _d 0 /(lambda_obcs_v * secondsperday)
          ELSE
            lambda_obcs_v = 0. _d 0
          ENDIF

          gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &    - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &    * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Southern Open Boundary
#ifdef ALLOW_OBCS_SOUTH
      DO i=iMin,iMax
       IF ((OB_Js(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Js(i,bi,bj)+jsl+1

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN  
          vrelax=( 
     &      float(spongeThickness-jsl)*OBSv(i,kLev,bi,bj)
     &    + float(jsl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = ( 
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl-1)*Vrelaxobcsinner)/ float(spongeThickness-1)

          if (lambda_obcs_v.ne.0.) then
            lambda_obcs_v = 1. _d 0 /(lambda_obcs_v * secondsperday)
          else
            lambda_obcs_v = 0. _d 0
          endif

          gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &    - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &    * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Eastern Open Boundary 
#ifdef ALLOW_OBCS_EAST
      DO j=jMin,jMax
       IF ((OB_Ie(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Ie(j,bi,bj)-isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN 
          vrelax=( 
     &      float(spongeThickness-isl)*OBEv(j,kLev,bi,bj)
     &    + float(isl-1)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = ( 
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl-1)*Urelaxobcsinner)/ float(spongeThickness-1)

          if (lambda_obcs_v.ne.0.) then
            lambda_obcs_v = 1. _d 0 /(lambda_obcs_v * secondsperday)
          else
            lambda_obcs_v = 0. _d 0
          endif

          gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &    - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &    * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Western Open Boundary
#ifdef ALLOW_OBCS_WEST
      DO j=jMin,jMax
       IF ((OB_Iw(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Iw(j,bi,bj)+isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN 

          vrelax=( 
     &      float(spongeThickness-isl)*OBWv(j,kLev,bi,bj)
     &    + float(isl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)
 
          lambda_obcs_v = ( 
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl-1)*Urelaxobcsinner)/ float(spongeThickness-1)

          if (lambda_obcs_v.ne.0.) then
            lambda_obcs_v = 1. _d 0 /(lambda_obcs_v * secondsperday)
          else
            lambda_obcs_v = 0. _d 0
          endif

         gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &   - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &   * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif
      
      ENDIF

#endif

      RETURN
      END
