C $Header$
C $Name$
C
CBOP
C    !ROUTINE: TR1.h
C    !INTERFACE:
C    include TR1.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TR1.h                                                     
C     | o Tracer 1 prognostic state.                              
C     *==========================================================*
C     | The value and two levels of time tendency are held for    
C     | each prognostic variable.                                 
C     | This file is hardcoded for OCMIP CFC-11 experiment.
C     *==========================================================*
C     \ev
CEOP
C
C     TR1     :: tracer concentration (tr per unit volume).
C     GTR1    :: tracer concentration (TR1 per second).
C     GTR1NM1 :: tracer concentration (TR1 per second).

      COMMON /TR1_R/ tr1, gTr1, gTr1NM1
      _RL  tr1     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  gTr1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  gTr1NM1 (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)

      COMMON /TR1_S/ fice, fice0, fice1,
     &                xkw,  xkw0,  xkw1,
     &               patm, patm0, patm1
      _RS  fice    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  fice0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  fice1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  xkw     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  xkw0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  xkw1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  patm    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  patm0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RS  patm1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /TR1_C/           FiceFile, XkwFile, PatmFile
      CHARACTER*(MAX_LEN_FNAM) FiceFile, XkwFile, PatmFile

      INTEGER nyrbeg, nyrend, nt
      PARAMETER (nyrbeg=1930, nyrend=2001, nt=2)
      COMMON /TR1_CFC/ CFCyear, CFCp11, CFCp12, pCFCw1, pCFCw2
      _RL  CFCyear(nyrbeg:nyrend)
      _RL  CFCp11(nyrbeg:nyrend,nt), CFCp12(nyrbeg:nyrend,nt)
      _RL  pCFCw1  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  pCFCw2  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

