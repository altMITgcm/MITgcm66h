.. _chap_modelExamples:

MITgcm Example Experiments
**************************



The full MITgcm distribution comes with a set of pre-configured
numerical experiments.  Some of these example experiments are tests of
individual parts of the model code, but many are fully fledged
numerical simulations. Full tutorials exist for a few of the examples,
and are documented in sections :numref:`sec_eg_baro` -
:numref:`sec_eg_tank`. The other examples follow the same general
structure as the tutorial examples. However, they only include brief
instructions in a text file called {\it README}.  The examples are
located in subdirectories under the directory \texttt{verification}.
Each example is briefly described below.

Full list of model examples
===========================

\begin{enumerate}

\item \texttt{tutorial\_advection\_in\_gyre} - Test of various
  advection schemes in a single-layer double-gyre experiment.
  This experiment is described in detail in section
  \ref{sec:eg-adv-gyre}.

\item \texttt{tutorial\_baroclinic\_gyre} - Four layer, ocean double
  gyre. This experiment is described in detail in section
  \ref{sec:eg-fourlayer}.

\item \texttt{tutorial\_barotropic\_gyre} - Single layer, ocean double
  gyre (barotropic with free-surface).
  This experiment is described in detail in section \ref{sec:eg-baro}.

\item \texttt{tutorial\_cfc\_offline} - Offline form of the MITgcm to
  study advection of a passive tracer and CFCs.
  This experiment is described in detail in section \ref{sec:eg-offline-cfc}.

\item \texttt{tutorial\_deep\_convection} - Non-uniformly forced
  ocean convection in a doubly periodic box. This experiment is
  described in detail in section \ref{sec:eg-bconv}.

\item \texttt{tutorial\_dic\_adoffline} - Offline form of MITgcm
  dynamics coupled to the dissolved inorganic carbon biogeochemistry model;
  adjoint set-up.

\item \texttt{tutorial\_global\_oce\_biogeo} - Ocean model coupled to
  the dissolved inorganic carbon biogeochemistry model. This
  experiment is described in detail in section
  \ref{sec:eg-biogeochem_tutorial}.

\item \texttt{tutorial\_global\_oce\_in\_p} - Global ocean simulation in
  pressure coordinate (non-Boussinesq ocean model). Described in
  detail in section \ref{sec:eg-globalpressure}.

\item \texttt{tutorial\_global\_oce\_latlon} - 4x4 degree global ocean
  simulation with steady climatological forcing. This experiment is
  described in detail in section \ref{sec:eg-global}.

\item \texttt{tutorial\_global\_oce\_optim} - Global ocean state
  estimation at $4^\circ$ resolution.  This experiment is described in
  detail in section \ref{sec:eg-global_state_estimate}.

\item \texttt{tutorial\_held\_suarez\_cs} - 3D atmosphere dynamics
  using Held and Suarez (1994) forcing on cubed sphere grid.  This
  experiment is described in detail in section \ref{sec:eg-hs}.

\item \texttt{tutorial\_offline} - Offline form of the MITgcm to study
  advection of a passive tracer.  This experiment is described in
  detail in section \ref{sec:eg-offline}.

\item \texttt{tutorial\_plume\_on\_slope} - Gravity Plume on a
  continental slope.  This experiment is described in detail in
  section \ref{sec:eg-gravityplume}.

\item \texttt{tutorial\_tracer\_adjsens} - Simple passive tracer
  experiment. Includes derivative calculation. This experiment is
  described in detail in section \ref{sec:eg-simple-tracer-adjoint}.\\
  Also contains an additional set-up using Secon Order Moment (SOM) advection
  scheme ({\it input\_ad.som81/}).

\item \texttt{1D\_ocean\_ice\_column} - Oceanic column with seaice on top.

\item \texttt{adjustment.128x64x1} - Barotropic adjustment problem on
  latitude longitude grid with 128x64 grid points ($2.8^\circ$ resolution).

\item \texttt{adjustment.cs-32x32x1} - Barotropic adjustment problem on
  cube sphere grid with 32x32 points per face (roughly $2.8^\circ$
  resolution).\\
  Also contains a non-linear free-surface adjustment version ({\it input.nlfs/}).

\item \texttt{advect\_cs} - Two-dimensional passive advection test on
  cube sphere grid (32x32 grid points per face, roughly $2.8^\circ$ resolution)

\item \texttt{advect\_xy} - Two-dimensional (horizontal plane) passive
  advection test on Cartesian grid.\\
  Also contains an additional set-up using Adams-Bashforth 3 ({\it input.ab3\_c4/}).

\item \texttt{advect\_xz} - Two-dimensional (vertical plane) passive
  advection test on Cartesian grid.\\
  Also contains an additional set-up using non-linear free-surface
   with divergent barotropic flow and implicit vertical advection ({\it input.nlfs/}).

\item \texttt{aim.5l\_Equatorial\_Channel} -
  5-levels Intermediate Atmospheric physics,
  3D Equatorial Channel configuration.

\item \texttt{aim.5l\_LatLon} - 5-levels Intermediate Atmospheric physics,
  Global configuration, on latitude longitude grid with 128x64x5 grid
  points ($2.8^\circ$ resolution).

\item \texttt{aim.5l\_cs} - 5-levels Intermediate Atmospheric physics,
  Global configuration on cube sphere grid
  (32x32 grid points per face, roughly $2.8^\circ$).\\
  Also contains an additional set-up with a slab-ocean and thermodynamic
  sea-ice ({\it input.thSI/}).

\item \texttt{bottom\_ctrl\_5x5} - Adjoint test using the bottom
  topography as the control parameter.

\item \texttt{cfc\_example} - Global ocean with online computation and
  advection of CFC11 and CFC12.

\item \texttt{cheapAML\_box} - Example using cheap atmospheric mixed layer
   (cheapAML) package.

\item \texttt{cpl\_aim+ocn} - Coupled Ocean - Atmosphere realistic
  configuration on cubed-sphere cs32 horizontal grid,
  using Intermediate Atmospheric physics ({\it pkg/aim\_v23})
  thermodynamic seaice ({\it pkg/thsice}) and land packages.
  on cubed-sphere cs32 in a realistic configuration.

\item \texttt{cpl\_atm2d+ocn} - Coupled Ocean - Atmosphere realistic
  configuration using 2-D Atmospheric Model ({\it pkg/atm2d}).

\item \texttt{deep\_anelastic} - Convection simulation on a giant planet:
  relax both the Boussinesq approximation (anelastic) and the thin atmosphere
  approximation (deep atmosphere).

\item \texttt{dome} - Idealized 3D test of a density-driven bottom current.

\item \texttt{exp2} - Old version of the global ocean experiment (no GM,
      no partial-cells).\\
  Also contains an additional set-up with rigid-lid ({\it input.rigidLid/}).

\item \texttt{exp4} - Flow over a Gaussian bump in open-water or
  channel with open boundaries.\\
  Also contains an additional set-up using non-linear free-surface ({\it input.nlfs/}).

\item \texttt{fizhi-cs-32x32x40} - Global atmospheric simulation with
  realistic topography, 40 vertical levels, a cubed sphere grid and
  the full atmospheric physics package.

\item \texttt{fizhi-cs-aqualev20} - Global atmospheric simulation on an
  aqua planet with full atmospheric physics. Run is perpetual march
  with an analytical SST distribution.  This is the configuration for
  the APE (Aqua Planet Experiment) participation experiment.

\item \texttt{fizhi-gridalt-hs} - Global atmospheric simulation
  Held-Suarez (1994) forcing, with the physical forcing and the
  dynamical forcing running on different vertical grids.

\item \texttt{flt\_example} - Example of using float package.

\item \texttt{front\_relax} - Relaxation of an ocean thermal front
  (test for Gent/McWilliams scheme). 2D (y-z).\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item using the Boundary-Value Problem method
          (Ferrari et al., 2010) ({\it input.bvp/}).
   \item with Mixed-Layer Eddy parameterization
          (Ferrari \& McWilliams, 2007) ({\it input.mxl/}).
  \end{enumerate}

\item \texttt{global\_ocean.90x40x15} - Global ocean simulation at 4x4
  degree resolution. Similar to tutorial\_global\_oce\_latlon, but using
  $z^*$ coordinates with quasi-non-hydrostatic and non-hydrostatic metric terms.
  This experiment also illustrate the use of SBO package.
  Also contains additional set-ups:
  \begin{enumerate}
   \item using down-slope package ({\it pkg/down\_slope}) ({\it input.dwnslp/})
   \item an Open-AD adjoint set-up ({\it code\_oad/, input\_oad/}).
   \item four TAF adjoint set-ups ({\it code\_ad/}):
   \begin{enumerate}
     \item standard experiment ({\it input\_ad/}).
     \item with bottom drag as a control ({\it input\_ad.bottomdrag/}).
     \item with kappa GM as a control ({\it input\_ad.kapgm/}).
     \item with kappa Redi as a control ({\it input\_ad.kapredi/}).
   \end{enumerate}
  \end{enumerate}

\item \texttt{global\_ocean.cs32x15} - Global ocean experiment on the
  cubed sphere grid.\\
  Also contains additional forward set-ups:
  \begin{enumerate}
   \item non-hydrostatic with biharmonic viscosity ({\it input.viscA4/})
   \item using thermodynamic sea ice and bulk force ({\it input.thsice/})
   \item using thermodynamic ({\it pkg/thsice}) dynamic ({\it pkg/seaice}) sea-ice
         and {\it exf} package ({\it input.icedyn/})
   \item using thermodynamic - dynamic ({\it pkg/seaice}) sea-ice
         with {\it exf} package ({\it input.seaice/})
  \end{enumerate}
  and few additional adjoint set-ups ({\it code\_ad/}):
  \begin{enumerate}
   \item standard experiment without sea-ice ({\it input\_ad/}).
   \item using thermodynamic - dynamic sea-ice ({\it input\_ad.seaice/})
   \item same as above without adjoint sea-ice dynamics ({\it input\_ad.seaice\_dynmix/})
   \item using thermodynamic sea-ice from {\it thsice} package ({\it input\_ad.thsice/})
  \end{enumerate}

\item \texttt{global\_ocean\_ebm} - Global ocean experiment on a lat-lon
  grid coupled to an atmospheric energy balance model. Similar to
  global\_ocean.90x40x15 experiment.\\
  Also contains an adjoint set-up ({\it code\_ad/, input\_ad/}).

\item \texttt{global\_with\_exf} - Global ocean experiment on a lat-lon
  grid using the {\it exf} package. Similar to tutorial\_global\_oce\_latlon
  experiment.\\
  Also contains a secondary set-up with yearly {\it exf} fields ({\it input\_ad.yearly/}).

\item \texttt{halfpipe\_streamice} - Example using package "streamice".\\
  Also contains adjoint set-ups using TAF ({\it code\_ad/, input\_ad/})
   and using Open-AD ({\it code\_oad/, input\_oad/}).

\item \texttt{hs94.128x64x5} - 3D atmosphere dynamics on lat-lon grid,
  using Held and Suarez '94 forcing.

\item \texttt{hs94.1x64x5} - Zonal averaged atmosphere dynamics
  using Held and Suarez '94 forcing.\\
  Also contains adjoint set-ups using TAF ({\it code\_ad/, input\_ad/})
   and using Open-AD ({\it code\_oad/, input\_oad/}).

\item \texttt{hs94.cs-32x32x5} - 3D atmosphere dynamics using Held and
  Suarez (1994) forcing on the cubed sphere, similar to tutorial\_held\_suarez\_cs
  experiment but using linear free-surface and only 5 levels.\\
  Also contains an additional set-up with Implicit Internal gravity waves
  treatment and Adams-Bashforth 3 ({\it input.impIGW/}).

\item \texttt{ideal\_2D\_oce} - Idealized 2D global ocean simulation on
  an aqua planet.

\item \texttt{internal\_wave} - Ocean internal wave forced by open
  boundary conditions.\\
  Also contains an additional set-up using {\it pkg/kl10} (see section
   \ref{sec:pkg:kl10}, Klymak and Legg, 2010) ({\it input.kl10/}).

\item \texttt{inverted\_barometer} - Simple test of ocean response to
  atmospheric pressure loading.

\item \texttt{isomip} - ISOMIP like set-up including ice-shelf cavities
  ({\it pkg/shelfice}).\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item with "htd" ({\it input.htd/})
          but only Martin knows what "htd" stands for.
   \item using package {\it icefront} ({\it input.icefront})
  \end{enumerate}
  and also adjoint set-ups using TAF ({\it code\_ad/, input\_ad/, input\_ad.htd/})
  or using Open-AD ({\it code\_oad/, input\_oad/}).

\item \texttt{lab\_sea} - Regional Labrador Sea simulation on a lat-lon
  grid using the sea ice package.\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item using the simple "free-drift" assumption for seaice ({\it input.fd/})
   \item using EVP dynamics (instead of LSR solver) and Hibler \& Bryan (1987)
         sea-ice ocean stress ({\it input.hb87/})
   \item using package {\it salt\_plume} ({\it input.salt\_plume/})
  \end{enumerate}
  and also 3 adjoint set-ups ({\it code\_ad/, input\_ad/, input\_ad.noseaicedyn/,
   input\_ad.noseaice/}).

\item \texttt{matrix\_example} - Test of experimental method to
  accelerated convergence towards equilibrium.

\item \texttt{MLAdjust} - Simple tests for different viscosity formulations.\\
  Also contains additional set-ups (see: {\it verification/MLAdjust/README}):
  \begin{enumerate}
   \item ({\it input.A4FlxF/})
   \item ({\it input.AhFlxF/})
   \item ({\it input.AhVrDv/})
   \item ({\it input.AhStTn/})
  \end{enumerate}

\item \texttt{natl\_box} - Eastern subtropical North Atlantic with KPP
  scheme; 1 month integration

\item \texttt{obcs\_ctrl} - Adjoint test using Open-Boundary conditions
  as control parameters.

\item \texttt{offline\_exf\_seaice} - Seaice on top of oceanic surface layer
  in an idealized channel. Forcing is computed by bulk-formulae ({\it pkg/exf})
  with temperature relaxation to prescribed SST (offline ocean).\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item sea-ice dynamics-only using JFNK solver
         and {\it pkg/thsice} advection ({\it input.dyn\_jfnk/})
   \item sea-ice dynamics-only using LSR solver
         and {\it pkg/seaice} advection ({\it input.dyn\_lsr/})
   \item sea-ice thermodynamics-only using {\it pkg/seaice} ({\it input.thermo/})
   \item sea-ice thermodynamics-only using {\it pkg/thsice} ({\it input.thsice/})
  \end{enumerate}
  and also 2 adjoint set-ups ({\it code\_ad/, input\_ad/, input\_ad.thsice/}).

\item \texttt{OpenAD} - Simple Adjoint experiment (used also to test
  Open-AD compiler)

\item \texttt{rotating\_tank} - Rotating tank simulation in cylindrical
  coordinates.  This experiment is described in detail in section
  \ref{sec:eg-tank}.

\item \texttt{seaice\_itd} - Seaice example using Ice Thickness Distribution (ITD).\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item ({\it input.thermo/})
   \item ({\it input.lipscomb07/})
  \end{enumerate}

\item \texttt{seaice\_obcs} - Similar to "lab\_sea" ({\it input.salt\_plume/})
  experiment with only a fraction of the domain and open-boundary conditions
  derived from "lab\_sea" experiment.\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item ({\it input.seaiceSponge/})
   \item ({\it input.tides/})
  \end{enumerate}

\item \texttt{short\_surf\_wave} - Short surface wave adjusment
   (non-hydrostatic) in homogeneous 2-D vertical section (x-z).

\item \texttt{so\_box\_biogeo} - Open-boundary Southern ocean box around
 Drake passage, using same model parameters and forcing as experiment
  "tutorial\_global\_oce\_biogeo" from which initial conditions
 and OB conditions have been extracted.

\item \texttt{solid-body.cs-32x32x1} - Solid body rotation test for cube
  sphere grid.

\item \texttt{tidal\_basin\_2d} - 2-D vertical section (x-z) with tidal forcing
 (untested)

\item \texttt{vermix} - Simple test in a small domain (3 columns) for
  ocean vertical mixing schemes. The standard set-up ({\it input/}) uses
  KPP scheme \cite[]{lar-eta:94}.\\
  Also contains additional set-ups:
  \begin{enumerate}
   \item with Double Diffusion scheme from KPP ({\it input.dd/})
   \item with \cite{gas-eta:90} ({\it pkg/ggl90}) scheme ({\it input.ggl90/})
   \item with \cite{Mellor:Yamada1982} level 2. ({\it pkg/my82}) scheme ({\it input.my82/})
   \item with \cite{pal-rom:97} ({\it pkg/opps}) scheme ({\it input.opps/})
   \item with \cite{Pacanowski:Philander1981} ({\it pkg/pp81}) scheme ({\it input.pp81/})
  \end{enumerate}

\end{enumerate}

\subsection{Directory structure of model examples}

Each example directory has the following subdirectories:

\begin{itemize}
\item \texttt{code}: contains the code particular to the example. At a
  minimum, this directory includes the following files:

  \begin{itemize}
  \item \texttt{code/packages.conf}: declares the list of packages or
    package groups to be used.  If not included, the default version
    is located in \texttt{pkg/pkg\_default}.  Package groups are
    simply convenient collections of commonly used packages which are
    defined in \texttt{pkg/pkg\_default}.  Some packages may require
    other packages or may require their absence (that is, they are
    incompatible) and these package dependencies are listed in
    \texttt{pkg/pkg\_depend}.

  \item \texttt{code/CPP\_EEOPTIONS.h}: declares CPP keys relative to
    the ``execution environment'' part of the code. The default
    version is located in \texttt{eesupp/inc}.

  \item \texttt{code/CPP\_OPTIONS.h}: declares CPP keys relative to
    the ``numerical model'' part of the code. The default version is
    located in \texttt{model/inc}.

  \item \texttt{code/SIZE.h}: declares size of underlying
    computational grid.  The default version is located in
    \texttt{model/inc}.
  \end{itemize}

  In addition, other include files and subroutines might be present in
  \texttt{code} depending on the particular experiment. See Section 2
  for more details.

\item \texttt{input}: contains the input data files required to run
  the example. At a minimum, the \texttt{input} directory contains the
  following files:

  \begin{itemize}
  \item \texttt{input/data}: this file, written as a namelist,
    specifies the main parameters for the experiment.

  \item \texttt{input/data.pkg}: contains parameters relative to the
    packages used in the experiment.

  \item \texttt{input/eedata}: this file contains ``execution
    environment'' data. At present, this consists of a specification
    of the number of threads to use in $X$ and $Y$ under multi-threaded
    execution.
  \end{itemize}

  In addition, you will also find in this directory the forcing and
  topography files as well as the files describing the initial state
  of the experiment.  This varies from experiment to experiment. See
  the verification directories refered to in this chapter for more details.

\item \texttt{results}: this directory contains the output file
  \texttt{output.txt} produced by the simulation example. This file is
  useful for comparison with your own output when you run the
  experiment.

\item \texttt{build}: this directory is initially empty and is used
  to compile and load the model, and to generate the executable.

\item \texttt{run}: this directory is initially empty and is used
  to run the executable.

\end{itemize}

Once you have chosen the example you want to run, you are ready to
compile the code.



.. include:: barotropic_gyre/barotropic_gyre.rst

\input{s_examples/baroclinic_gyre/fourlayer.tex}

\input{s_examples/advection_in_gyre/adv_gyre.tex}

\input{s_examples/global_oce_latlon/climatalogical_ogcm.tex}

\input{s_examples/global_oce_in_p/ogcm_in_pressure.tex}

\input{s_examples/held_suarez_cs/held_suarez_cs.tex}

\input{s_examples/deep_convection/convection.tex}

\input{s_examples/plume_on_slope/plume_on_slope.tex}

\input{s_examples/global_oce_biogeo/biogeochem.tex}

\input{s_examples/global_oce_optim/global_oce_estimation.tex}

\input{s_examples/tracer_adjsens/doc_ad_examples.tex}

\input{s_examples/cfc_offline/offline_tutorial.tex}


.. include:: tank/tank.rst
