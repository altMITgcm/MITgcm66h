.. _pkg_obcs:

OBCS: Open boundary conditions for regional modeling
----------------------------------------------------

Authors: 
Alistair Adcroft, Patrick Heimbach, Samar Katiwala, Martin Losch


.. _pkg_obcs_intro:

Introduction
++++++++++++

The OBCS-package is fundamental to regional ocean modelling with the
MITgcm, but there are so many details to be considered in
regional ocean modelling that this package cannot accomodate all
imaginable and possible options. Therefore, for a regional simulation
with very particular details, it is recommended to familiarize oneself
not only with the compile- and runtime-options of this package, but
also with the code itself. In many cases it will be necessary to adapt
the obcs-code (in particular \code{S/R OBCS\_CALC}) to the application
in question; in these cases the obcs-package (together with the
rbcs-package, section \ref{sec:pkg:rbcs}) is a very
useful infrastructure for implementing special regional models.

.. _pkg_obcs_config_compiling:

OBCS configuration and compiling
++++++++++++++++++++++++++++++++

As with all MITgcm packages, OBCS can be turned on or off 
at compile time

 - using the :code:`packages.conf` file by adding :code:`obcs` to it,
 - or using :code:`genmake2` adding :code:`-enable=obcs` or :code:`-disable=obcs` switches
 - *Required packages and CPP options:*

   - Two alternatives are available for prescribing open boundary values, which differ in the way how OB's are treated in time:

     - A simple time-management (e.g. constant in time, or cyclic with fixed fequency) is provided through S/R :code:`obcs_external_fields_load`.
     - More sophisticated 'real-time' (i.e. calendar time) management is available through :code:`obcs_prescribe_read`.
   - The latter case requires packages :code:`cal` and :code:`exf` to be enabled.




(see also Section \ref{sec:buildingCode}).

Parts of the OBCS code can be enabled or disabled at compile time
via CPP preprocessor flags. These options are set in
`OBCS\_OPTIONS.h`. :numref:`pkg_obcs_cpp_opts` summarizes these options.


.. tabularcolumns:: |l|l|

.. _pkg_obcs_cpp_opts:

.. csv-table:: OBCS CPP options

  **CPP option**        ,  **Description**
  `ALLOW_OBCS_NORTH`    ,    enable Northern OB 
  `ALLOW_OBCS_SOUTH`    ,    enable Southern OB
   ALLOW_OBCS_EAST      ,    enable Eastern OB 
   ALLOW_OBCS_WEST      ,    enable Western OB

   ALLOW_OBCS_PRESCRIBE ,   enable code for prescribing OB's
   ALLOW\_OBCS\_SPONGE  ,   enable sponge layer code
   ALLOW\_OBCS\_BALANCE ,  enable code for balancing transports through OB's
   ALLOW\_ORLANSKI      ,  enable Orlanski radiation conditions at OB's
   ALLOW\_OBCS\_STEVENS , enable Stevens (1990) boundary conditions at OB's 
                        ,  (currently only implemented for eastern and 
                        , western boundaries and NOT for ptracers)




.. _pkg_obcs_runtime:

Run-time parameters
+++++++++++++++++++


Run-time parameters are set in files 
:code:`data.pkg`, :code:`data.obcs`, and :code:`data.exf
if 'real-time' prescription is requested 
(i.e. package :code:`exf` enabled).
These parameter files are read in S/R
:code:`packages_readparms.F`, :code:`obcs_readparms.F`, and
:code:`exf_readparms.F`, respectively.
Run-time parameters may be broken into 3 categories:
 #. switching on/off the package at runtime,
 #. OBCS package flags and parameters,
 #. additional timing flags in :code:`data.exf`, if selected.


Enabling the package
####################

The OBCS package is switched on at runtime by setting
:code:`useOBCS = .TRUE.` in :code:`data.pkg`.

Package flags and parameters
############################

:numref:`pkg_obcs_runtime_flags` summarizes the
runtime flags that are set in :code:`data.obcs`, and
their default values.


.. tabularcolumns:: |l|c|l|

.. _pkg_obcs_runtime_flags:

.. csv-table:: OBCS CPP options

  **Flag/parameter** , **default** , **Description**
  *basic flags & parameters* (OBCS\_PARM01) , ,
  OB\_Jnorth        , 0           , Nx-vector of J-indices (w.r.t. Ny) of Northern OB at each I-position (w.r.t. Nx) 
  OB\_Jsouth        , 0           , Nx-vector of J-indices (w.r.t. Ny) of Southern OB at each I-position (w.r.t. Nx)
  OB\_Ieast         ,  0          , Ny-vector of I-indices (w.r.t. Nx) of Eastern OB at each J-position (w.r.t. Ny)
  OB\_Iwest         ,  0          , Ny-vector of I-indices (w.r.t. Nx) of Western OB at each J-position (w.r.t. Ny)
  useOBCSprescribe  , :code:`.FALSE.` , 
  useOBCSsponge     , :code:`.FALSE.` , 
        useOBCSbalance & \code{.FALSE.} & 
           ~ \\
           OBCS\_balanceFacN/S/E/W & 1 & factor(s) determining the details
           of the balaning code \\
        useOrlanskiNorth/South/EastWest & \code{.FALSE.} & 
           turn on Orlanski boundary conditions for individual boundary\\
        useStevensNorth/South/EastWest & \code{.FALSE.} & 
           turn on Stevens boundary conditions for individual boundary\\
        OB\textbf{X}\textbf{y}File & ~ & 
           file name of OB field \\
        ~ & ~ & 
           \textbf{X}: \textbf{N}(orth), \textbf{S}(outh), 
                       \textbf{E}(ast), \textbf{W}(est) \\
        ~ & ~ & 
           \textbf{y}: \textbf{t}(emperature), \textbf{s}(salinity), 
           \textbf{u}(-velocity), \textbf{v}(-velocity), \\
        ~ & ~ & 
           \textbf{w}(-velocity), \textbf{eta}(sea surface height)\\
        ~ & ~ & 
           \textbf{a}(sea ice area), \textbf{h}(sea ice thickness),
           \textbf{sn}(snow thickness), \textbf{sl}(sea ice salinity)\\
      \hline
      \multicolumn{3}{|c|}{\textit{Orlanski parameters} (OBCS\_PARM02) } \\
      \hline
        cvelTimeScale & 2000 sec & 
           averaging period for phase speed \\
        CMAX & 0.45 m/s & 
           maximum allowable phase speed-CFL for AB-II \\
        CFIX & 0.8 m/s & 
           fixed boundary phase speed \\
        useFixedCEast & \code{.FALSE.} & 
           ~ \\
        useFixedCWest & \code{.FALSE.} & 
           ~ \\
      \hline
      \multicolumn{3}{|c|}{\textit{Sponge-layer parameters} (OBCS\_PARM03)} \\
      \hline
        spongeThickness & 0 & 
           sponge layer thickness (in \# grid points) \\
        Urelaxobcsinner & 0 sec & 
           relaxation time scale at the 
           innermost sponge layer point of a meridional OB \\
        Vrelaxobcsinner & 0 sec & 
           relaxation time scale at the 
           innermost sponge layer point of a zonal OB \\
        Urelaxobcsbound & 0 sec & 
           relaxation time scale at the 
           outermost sponge layer point of a meridional OB \\
        Vrelaxobcsbound & 0 sec & 
           relaxation time scale at the 
           outermost sponge layer point of a zonal OB \\
      \hline
      \multicolumn{3}{|c|}{\textit{Stevens parameters} (OBCS\_PARM04) } \\
      \hline
        T/SrelaxStevens & 0~sec & relaxation time scale for
           temperature/salinity \\
        useStevensPhaseVel & \code{.TRUE.} & \\
        useStevensAdvection & \code{.TRUE.} & \\
         \hline
      \hline
    \end{tabular}
  }
  \caption{pkg OBCS run-time parameters}
  \label{tab:pkg:obcs:runtime_flags}
\end{table}



%----------------------------------------------------------------------

\subsubsection{Defining open boundary positions
\label{sec:pkg:obcs:defining}}

There are four open boundaries (OBs), a 
Northern, Southern, Eastern, and Western.
All OB locations are specified by their absolute
meridional (Northern/Southern) or zonal (Eastern/Western) indices.
Thus, for each zonal position $i=1,\ldots,N_x$ a meridional index
$j$ specifies the Northern/Southern OB position,
and for each meridional position $j=1,\ldots,N_y$, a zonal index
$i$ specifies the Eastern/Western OB position.
For Northern/Southern OB this defines an $N_x$-dimensional
``row'' array $\tt OB\_Jnorth(Nx)$ / $\tt OB\_Jsouth(Nx)$,
and an $N_y$-dimenisonal 
``column'' array $\tt OB\_Ieast(Ny)$ / $\tt OB\_Iwest(Ny)$.
Positions determined in this way allows Northern/Southern
OBs to be at variable $j$ (or $y$) positions, and Eastern/Western
OBs at variable $i$ (or $x$) positions.
Here, indices refer to tracer points on the C-grid.
A zero (0) element in $\tt OB\_I\ldots$, $\tt OB\_J\ldots$
means there is no corresponding OB in that column/row.
For a Northern/Southern OB, the OB V point is to the South/North.
For an Eastern/Western OB, the OB U point is to the West/East.
For example,
\begin{tabbing}
  \code{OB\_Jnorth(3)=34} \=  means that:  \= \\
  \> \code{T(3,34)} \> is a an OB point  \\
  \> \code{U(3,34)} \> is a an OB point \\
  \> \code{V(3,34)} \> is a an OB point \\
  \code{OB\_Jsouth(3)=1} \> means that: \\
  \> \code{T(3,1)} \> is a an OB point \\
  \> \code{U(3,1)} \> is a an OB point \\ 
  \> \code{V(3,2)} \> is a an OB point \\
  \code{OB\_Ieast(10)=69} \>  means that:  \>  \\
  \> \code{T(69,10)} \> is a an OB point \\
  \> \code{U(69,10)} \> is a an OB point \\
  \> \code{V(69,10)} \> is a an OB point \\
  \code{OB\_Iwest(10)=1} \>  means that:  \>  \\
  \> \code{T(1,10)} \> is a an OB point \\
  \> \code{U(2,10)} \> is a an OB point \\
  \> \code{V(1,10)} \> is a an OB point
\end{tabbing}
For convenience, negative values for \code{Jnorth}/\code{Ieast} refer to
points relative to the Northern/Eastern edges of the model
eg. $\tt OB\_Jnorth(3)=-1$  means that the point $\tt (3,Ny)$ 
is a northern OB.

\noindent\textbf{Simple examples:} For a model grid with $ N_{x}\times
N_{y} = 120\times144$ horizontal grid points with four open boundaries
along the four egdes of the domain, the simplest way of specifying the
boundary points in \code{data.obcs} is:
\begin{verbatim}
  OB_Ieast = 144*-1,
# or OB_Ieast = 144*120,
  OB_Iwest = 144*1,
  OB_Jnorth = 120*-1,
# or OB_Jnorth = 120*144,
  OB_Jsouth = 120*1,
\end{verbatim}
If only the first $50$ grid points of the southern boundary are
boundary points: 
\begin{verbatim}
  OB_Jsouth(1:50) = 50*1,
\end{verbatim}

\noindent
\textsf{Add special comments for case \#define NONLIN\_FRSURF,
see obcs\_ini\_fixed.F}

%----------------------------------------------------------------------

.. _pkg_obcs_equations

Equations and key routines
--------------------------

\paragraph{OBCS\_READPARMS:} ~ \\
Set OB positions through arrays
{\tt OB\_Jnorth(Nx), OB\_Jsouth(Nx), OB\_Ieast(Ny), OB\_Iwest(Ny)},
and runtime flags (see Table \ref{tab:pkg:obcs:runtime_flags}).


\paragraph{OBCS\_CALC:} ~ \\
%
Top-level routine for filling values to be applied at OB for 
$T,S,U,V,\eta$ into corresponding 
``slice'' arrays $(x,z)$, $(y,z)$ for each OB:
$\tt OB[N/S/E/W][t/s/u/v]$; e.g. for salinity array at
Southern OB, array name is $\tt OBSt$.
Values filled are either
%
\begin{itemize}
%
\item
constant vertical $T,S$ profiles as specified in file
{\tt data} ({\tt tRef(Nr), sRef(Nr)}) with zero velocities $U,V$,
%
\item
$T,S,U,V$ values determined via Orlanski radiation conditions
(see below),
%
\item
prescribed time-constant or time-varying fields (see below).
%
\item 
use prescribed boundary fields to compute Stevens boundary conditions.
\end{itemize}

\paragraph{ORLANSKI:} ~ \\
%
Orlanski radiation conditions \citep{orl:76}, examples can be found in
\code{verification/dome} and
\code{verification/tutorial\_plume\_on\_slope}
(\ref{sec:eg-gravityplume}).

\paragraph{OBCS\_PRESCRIBE\_READ:} ~ \\
%
When \code{useOBCSprescribe = .TRUE.} the model tries to read
temperature, salinity, u- and v-velocities from files specified in the
runtime parameters \code{OB[N/S/E/W][t/s/u/v]File}. These files are
the usual IEEE, big-endian files with dimensions of a section along an
open boundary:
\begin{itemize}
\item For North/South boundary files the dimensions are
  $(N_x\times N_r\times\mbox{time levels})$, for East/West boundary
  files the dimensions are $(N_y\times N_r\times\mbox{time levels})$.
\item If a non-linear free surface is used
  (\ref{sec:nonlinear-freesurface}), additional files
  \code{OB[N/S/E/W]etaFile} for the sea surface height $\eta$ with
  dimension $(N_{x/y}\times\mbox{time levels})$ may be specified.
\item If non-hydrostatic dynamics are used
  (\ref{sec:non-hydrostatic}), additional files
  \code{OB[N/S/E/W]wFile} for the vertical velocity $w$ with
  dimensions $(N_{x/y}\times N_r\times\mbox{time levels})$ can be
  specified.
\item If \code{useSEAICE=.TRUE.} then additional files
  \code{OB[N/S/E/W][a,h,sl,sn,uice,vice]} for sea ice area, thickness
  (\code{HEFF}), seaice salinity, snow and ice velocities
  $(N_{x/y}\times\mbox{time levels})$ can be specified.
\end{itemize}
As in \code{S/R external\_fields\_load} or the \code{exf}-package, the
code reads two time levels for each variable, e.g.\ \code{OBNu0} and
\code{OBNu1}, and interpolates linearly between these time levels to
obtain the value \code{OBNu} at the current model time (step). When the
\code{exf}-package is used, the time levels are controlled for each
boundary separately in the same way as the \code{exf}-fields in
\code{data.exf}, namelist \code{EXF\_NML\_OBCS}. The runtime flags
follow the above naming conventions, e.g. for the western boundary the
corresponding flags are \code{OBCWstartdate1/2} and
\code{OBCWperiod}. Sea-ice boundary values are controlled separately
with \code{siobWstartdate1/2} and \code{siobWperiod}.  When the
\code{exf}-package is not used, the time levels are controlled by the
runtime flags \code{externForcingPeriod} and \code{externForcingCycle}
in \code{data}, see \code{verification/exp4} for an example.

\paragraph{OBCS\_CALC\_STEVENS:} ~ \\
(THE IMPLEMENTATION OF THESE BOUNDARY CONDITIONS IS NOT
COMPLETE. PASSIVE TRACERS, SEA ICE AND NON-LINEAR FREE SURFACE ARE NOT
SUPPORTED PROPERLY.) \\ 
The boundary conditions following \citet{stevens:90} require the
vertically averaged normal velocity (originally specified as a stream
function along the open boundary) $\bar{u}_{ob}$ and the tracer fields
$\chi_{ob}$ (note: passive tracers are currently not implemented and
the code stops when package \code{ptracers} is used together with this
option). Currently, the code vertically averages the normal velocity
as specified in \code{OB[E,W]u} or \code{OB[N,S]v}. From these
prescribed values the code computes the boundary values for the next
timestep $n+1$ as follows (as an example, we use the notation for an
eastern or western boundary):
\begin{itemize}
\item $u^{n+1}(y,z) = \bar{u}_{ob}(y) + (u')^{n}(y,z)$, where
  $(u')^{n}$ is the deviation from the vertically averaged velocity at
  timestep $n$ on the boundary. $(u')^{n}$ is computed in the previous
  time step $n$ from the intermediate velocity $u^*$ prior to the
  correction step (see section \ref{sec:time_stepping}, e.g.,
  eq.\,(\ref{eq:ustar-backward-free-surface})).
  % and~(\ref{eq:vstar-backward-free-surface})). 
  (This velocity is not
  available at the beginning of the next time step $n+1$, when
  S/R~OBCS\_CALC/OBCS\_CALC\_STEVENS are called, therefore it needs to
  be saved in S/R~DYNAMICS by calling S/R~OBCS\_SAVE\_UV\_N and also
  stored in a separate restart files
  \verb+pickup_stevens[N/S/E/W].${iteration}.data+)
%  Define CPP-flag OBCS\_STEVENS\_USE\_INTERIOR\_VELOCITY to use the
%  velocity one grid point inward from the boundary. 
\item If $u^{n+1}$ is directed into the model domain, the boudary
  value for tracer $\chi$ is restored to the prescribed values:
  \[\chi^{n+1} =   \chi^{n} + \frac{\Delta{t}}{\tau_\chi} (\chi_{ob} -
  \chi^{n}),\] where $\tau_\chi$ is the relaxation time
  scale \texttt{T/SrelaxStevens}. The new $\chi^{n+1}$ is then subject
  to the advection by $u^{n+1}$.
\item If $u^{n+1}$ is directed out of the model domain, the tracer
  $\chi^{n+1}$ on the boundary at timestep $n+1$ is estimated from
  advection out of the domain with $u^{n+1}+c$, where $c$ is
  a phase velocity estimated as
  $\frac{1}{2}\frac{\partial\chi}{\partial{t}}/\frac{\partial\chi}{\partial{x}}$. The
  numerical scheme is (as an example for an eastern boundary):
  \[\chi_{i_{b},j,k}^{n+1} =   \chi_{i_{b},j,k}^{n} + \Delta{t} 
  (u^{n+1}+c)_{i_{b},j,k}\frac{\chi_{i_{b},j,k}^{n}
    - \chi_{i_{b}-1,j,k}^{n}}{\Delta{x}_{i_{b},j}^{C}}\mbox{, if }u_{i_{b},j,k}^{n+1}>0,
  \] where $i_{b}$ is the boundary index.\\
  For test purposes, the phase velocity contribution or the entire
  advection can be turned off by setting the corresponding parameters
  \texttt{useStevensPhaseVel} and \texttt{useStevensAdvection} to
  \texttt{.FALSE.}.
\end{itemize} 
See \citet{stevens:90} for details. With this boundary condition
specifying the exact net transport across the open boundary is simple,
so that balancing the flow with (S/R~OBCS\_BALANCE\_FLOW, see next
paragraph) is usually not necessary.

\paragraph{OBCS\_BALANCE\_FLOW:} ~ \\
%
When turned on (\code{ALLOW\_OBCS\_BALANCE}
defined in \code{OBCS\_OPTIONS.h} and \code{useOBCSbalance=.true.} in
\code{data.obcs/OBCS\_PARM01}), this routine balances the net flow
across the open boundaries. By default the net flow across the
boundaries is computed and all normal velocities on boundaries are
adjusted to obtain zero net inflow.

This behavior can be controlled with the runtime flags
\code{OBCS\_balanceFacN/S/E/W}. The values of these flags determine
how the net inflow is redistributed as small correction velocities
between the individual sections. A value ``\code{-1}'' balances an
individual boundary, values $>0$ determine the relative size of the
correction. For example, the values
\begin{tabbing}
 \code{OBCS\_balanceFacE}\code{ = 1.,} \\
 \code{OBCS\_balanceFacW}\code{ = -1.,} \\
 \code{OBCS\_balanceFacN}\code{ = 2.,} \\
 \code{OBCS\_balanceFacS}\code{ = 0.,}
\end{tabbing}
make the model
\begin{itemize}
\item correct Western \code{OBWu} by substracting a uniform velocity to
ensure zero net transport through the Western open boundary;
\item correct Eastern and Northern normal flow, with the Northern
  velocity correction two times larger than the Eastern correction, but
  \emph{not} the Southern normal flow, to ensure that the total inflow through
  East, Northern, and Southern open boundary is balanced.
\end{itemize}

The old method of balancing the net flow for all sections individually
can be recovered by setting all flags to -1. Then the normal
velocities across each of the four boundaries are modified separately,
so that the net volume transport across \emph{each} boundary is
zero. For example, for the western boundary at $i=i_{b}$, the modified
velocity is:
\[
u(y,z) - \int_{\mbox{western boundary}}u\,dy\,dz \approx OBNu(j,k) - \sum_{j,k}
OBNu(j,k) h_{w}(i_{b},j,k)\Delta{y_G(i_{b},j)}\Delta{z(k)}.
\]
This also ensures a net total inflow of zero through all boundaries,
but this combination of flags is \emph{not} useful if you want to
simulate, say, a sector of the Southern Ocean with a strong ACC
entering through the western and leaving through the eastern boundary,
because the value of ``\code{-1}'' for these flags will make sure that
the strong inflow is removed. Clearly, gobal balancing with
\code{OBCS\_balanceFacE/W/N/S} $\ge0$ is the preferred method.

\paragraph{OBCS\_APPLY\_*:} ~ \\
~

\paragraph{OBCS\_SPONGE:} ~ \\
%
The sponge layer code (turned on with \code{ALLOW\_OBCS\_SPONGE} and
\code{useOBCSsponge}) adds a relaxation term to the right-hand-side of
the momentum and tracer equations. The variables are relaxed towards
the boundary values with a relaxation time scale that increases
linearly with distance from the boundary
\[
G_{\chi}^{\mbox{(sponge)}} = 
- \frac{\chi - [( L - \delta{L} ) \chi_{BC} + \delta{L}\chi]/L}
{[(L-\delta{L})\tau_{b}+\delta{L}\tau_{i}]/L} 
= - \frac{\chi - [( 1 - l ) \chi_{BC} + l\chi]}
{[(1-l)\tau_{b}+l\tau_{i}]}
\]
where $\chi$ is the model variable (U/V/T/S) in the interior,
$\chi_{BC}$ the boundary value, $L$ the thickness of the sponge layer
(runtime parameter \code{spongeThickness} in number of grid points),
$\delta{L}\in[0,L]$ ($\frac{\delta{L}}{L}=l\in[0,1]$) the distance from the boundary (also in grid points), and
$\tau_{b}$ (runtime parameters \code{Urelaxobcsbound} and
\code{Vrelaxobcsbound}) and $\tau_{i}$ (runtime parameters
\code{Urelaxobcsinner} and \code{Vrelaxobcsinner}) the relaxation time
scales on the boundary and at the interior termination of the sponge
layer. The parameters \code{Urelaxobcsbound/inner} set the relaxation
time scales for the Eastern and Western boundaries,
\code{Vrelaxobcsbound/inner} for the Northern and Southern boundaries.

\paragraph{OB's with nonlinear free surface} ~ \\
%
~


%----------------------------------------------------------------------

\subsubsection{Flow chart
\label{sec:pkg:obcs:flowchart}}


{\footnotesize
\begin{verbatim}

C     !CALLING SEQUENCE:
c ...

\end{verbatim}
}

%----------------------------------------------------------------------

\subsubsection{OBCS diagnostics
\label{sec:pkg:obcs:diagnostics}}

Diagnostics output is available via the diagnostics package
(see Section \ref{sec:pkg:diagnostics}).
Available output fields are summarized in 
Table \ref{tab:pkg:obcs:diagnostics}.

\begin{table}[!ht]
\centering
\label{tab:pkg:obcs:diagnostics}
{\footnotesize
\begin{verbatim}
------------------------------------------------------
 <-Name->|Levs|grid|<--  Units   -->|<- Tile (max=80c)
------------------------------------------------------

\end{verbatim}
}
\caption{~}
\end{table}

%----------------------------------------------------------------------

\subsubsection{Reference experiments}
In the directory \code{verifcation}, the following experiments use
\code{obcs}: 
\begin{itemize}
\item \code{exp4}: box with 4 open boundaries, simulating flow over a
  Gaussian bump based on \citet{adcroft:97}, also tests
  Stevens-boundary conditions;
\item \code{dome}: based on the project ``Dynamics of Overflow Mixing
  and Entrainment''
  (\url{http://www.rsmas.miami.edu/personal/tamay/DOME/dome.html}), uses
  Orlanski-BCs;
\item \code{internal\_wave}: uses a heavily modified \code{S/R~OBCS\_CALC}
\item \code{seaice\_obcs}: simple example who to use the sea-ice
  related code, based on \code{lab\_sea};
\item \code{tutorial\_plume\_on\_slope}: uses Orlanski-BCs, see also
  section~\ref{sec:eg-gravityplume}.
\end{itemize}



%----------------------------------------------------------------------

\subsubsection{References}

\subsubsection{Experiments and tutorials that use obcs}
\label{sec:pkg:obcs:experiments}

\begin{itemize}
\item \code{tutorial\_plume\_on\_slope} (section~\ref{sec:eg-gravityplume})
\end{itemize}


%%% Local Variables: 
%%% mode: latex
%%% TeX-master: "../../manual"
%%% End: 
