C $Header$
C $Name$

C 
C CPP flags controlling which code in included in the files that
C will be compiled.
C

C o Include/exclude code for C-D grid method of integrating the 
C   coriolis terms
#define  INCLUDE_CD_CODE

C o Include/exclude temperature forcing code
#define  INCLUDE_T_FORCING_CODE

C o Include/exclude momentum forcing code
#define INCLUDE_MOMENTUM_FORCING_CODE

C o Include/exclude momentum eqn metric terms code
#define INCLUDE_MOMENTUM_METRIC_TERM_CODE

C o Include/exclude phi_hyd calculation code
#define INCLUDE_PHIHYD_CALCULATION_CODE

C o Include/exclude call to S/R CONVECT
#undef  INCLUDE_CONVECT_CALL

C o Include/exclude call to S/R CALC_DIFFUSIVITY
#define INCLUDE_CALC_DIFFUSIVITY_CALL

C o Allow nonHydrostatic code
#undef  ALLOW_NONHYDROSTATIC

C o Use "natural" boundary conditions for salinity
C   instead of the "virtual salt flux"
#undef  USE_NATURAL_BCS

C o Use "Exact Convervation" of fluid in Free-Surface formulation
C   so that d/dt(eta) is exactly equal to - Div.Transport
#undef  EXACT_CONSERV

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that surface thickness (hFactors) vary with time
#undef NONLIN_FRSURF

C o Use "OLD" UV discretisation near boundaries (*not* recommended)
C   Note - only works with  #undef NO_SLIP_LATERAL  in calc_mom_rhs.F
C          because the old code did not have no-slip BCs
#undef  OLD_ADV_BCS

C o Use "OLD" UV geometry on sphere (definately *NOT* recommended)
C   Note - only works with  #undef NO_SLIP_LATERAL  in calc_mom_rhs.F
C          because the old code did not have no-slip BCs
#undef  OLD_UV_GEOMETRY

C o Execution environment support options
#include "CPP_EEOPTIONS.h"

C o Include/exclude the external forcing package. To use this package,
C   you have to include the calendar tool as well. KPP can be switched
C   on or off. The implementation automatically takes care of this.
#define INCLUDE_EXTERNAL_FORCING_PACKAGE
#ifdef INCLUDE_EXTERNAL_FORCING_PACKAGE
# include "ECCO_CPPOPTIONS.h"
#endif

C o Include/exclude code specific to the ECCO/SEALION version.
#undef INCLUDE_ECCO_PACKAGE
#ifdef INCLUDE_ECCO_PACKAGE
#include "ECCO_CPPOPTIONS.h"
#endif

