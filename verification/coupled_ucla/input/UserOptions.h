
/*--------------------------------------------------------------------
 * The options specified in the following #if clause are used by the
 * Makefiles to build the designated executable program.
 *--------------------------------------------------------------------*/

/* Flat directory for debugging */
#define FLAT_DIR  ${HOME}/cvsworkdir/flat

/* Define location of esm_input file */
#define ESM_INPUT_FILE "/u/menemenl/menemenl/camel_7.2p/bin/esm_input"

/* Choose package options.
 *
 * NOTE: IF NEW PACKAGE OPTIONS ARE ADDED BELOW, A NEW ENTRY IN CONFIG.H 
 * MUST BE ADDED TO DEFINE CERTAIN MACROS UNIQUE TO THAT PACKAGE, SUCH
 * AS OBJECT LIBRARY NAMES REQUIRED FOR LINKING. */

#define  ESM_Package  1		/* Current options: 	0 = no package
							1 = esm		*/

#define  AGCM_Package  1	/* Current options: 	0 = no package
							1 = llnl		
							2 = proxy	*/

#define  OGCM_Package  0	/* Current options: 	0 = no package
							1 = llnl_mom		
							2 = proxy	*/

#define  FE_Package    0	/* Current options: 	0 = no package
							1 = FE		*/

#define  OD_Package    2	/* Current options: 	0 = no package
                                                        1 = OD (MOM version)
							2 = OD (POP version)*/

#define  CD_Package    0	/* Current options: 	0 = no package
							1 = CD		*/

  /* Select llnl_mom preprocessing options */
#ifdef MAKING_MAKEFILE
  opt1 = -Ddiskless -Dcongrad9pt -Dtiming -Dskipland 
  opt2 = -Dsurflux1 -Drigidlid -Dislands -Dconstvmix -Dconsthmix
  opt3 = -Dcyclic
  opt4 = -Dfourfil 
  llnl_mom_options = $(opt1) $(opt2) $(opt3) $(opt4)
#endif


#define  ACTM_Package  0	/* Current options: 	0 = no package
							1 = impact		*/

#define  LSM_Package  0		/* Current options: 	0 = no package
							1 = bats		*/

#define  OBGCM_Package  0	/* Current options: 	0 = no package
							1 = 		*/

#define  SEAICE_Package  0	/* Current options: 	0 = no package
							1 = 		*/

#define  T_ECO_Package  0	/* Current options: 	0 = no package
							1 = 		*/

/*---------------------------------------------------------------------
 * The macros set in this next clause are used in the source files to
 * set architecture, memory, and message passing options.
 *---------------------------------------------------------------------*/

/* Choose architecture for current machine. */
#define ARCH_OPTION ARCH_ARCH_SGI_O2 /* Current ARCH_OPTION choices:
						ARCH_SUN4
						ARCH_DEC 
						ARCH_CRAY
						ARCH_BBN
						ARCH_CM5
						ARCH_RIOS
						ARCH_INTEL
						ARCH_SP1  
						ARCH_T3E  
						ARCH_SGI_O2 	*/

/* Choose memory management macro for current machine. */
#define MEM_OPTION MEM_SUN4  	/* Current MEM_OPTION choices:
						MEM_SUN4
						MEM_CRAY
						MEM_BBN1
						MEM_BBN2
						MEM_PMMLIB 
						MEM_CM5  
						MEM_RIOS 
						MEM_INTEL       */

/* Choose message passing macro for current machine. */
#define MSG_OPTION MSG_MPI      	/*Current MSG_OPTION choices:
						MSG_NONE
						MSG_LMPS
						MSG_PVM
						MSG_PVM3
						MSG_CMMD
						MSG_DELTA
						MSG_PARAGON
						MSG_EXPRESS
						MSG_P4     
						MSG_MPI    
						MSG_IBM	*/

/* Other options.  0 = disabled   1 = enabled */
#define MEM_ERRCHECK 0
#define MSG_ERRCHECK 0
#define MSG_IDCONVERT 0
#define MSG_STATS 0

#define Debug_Option 0 
#define Optimization_Option 1

#define CODENAME '$(PROGS)\0'

