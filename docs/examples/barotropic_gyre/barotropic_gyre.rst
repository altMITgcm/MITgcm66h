.. _sec_eg_baro:

Barotropic Gyre MITgcm Example
==============================

\begin{center} 
(in directory: {\it verification/tutorial\_barotropic\_gyre/})
\end{center}

This example experiment demonstrates using the MITgcm to simulate
a Barotropic, wind-forced, ocean gyre circulation. The files for this
experiment can be found in the verification directory tutorial\_barotropic\_gyre.
The experiment is a numerical rendition of the gyre circulation problem similar
to the problems described analytically by Stommel in 1966 
\cite{Stommel66} and numerically in Holland et. al \cite{Holland75}.

In this experiment the model 
is configured to represent a rectangular enclosed box of fluid,
$1200 \times 1200 $~km in lateral extent. The fluid is $5$~km deep and is forced
by a constant in time zonal wind stress, $\tau_x$, that varies sinusoidally
in the ``north-south'' direction. Topologically the grid is Cartesian and 
the coriolis parameter $f$ is defined according to a mid-latitude beta-plane 
equation

  .. math:: f(y) = f_{0}+\beta y
     :label: eq_eg_baro_fcori


where $y$ is the distance along the ``north-south'' axis of the 
simulated domain. For this experiment $f_{0}$ is set to $10^{-4}s^{-1}$ in :eq:`eq_eg_baro_fcori` and $\beta = 10^{-11}s^{-1}m^{-1}$. 


The sinusoidal wind-stress variations are defined according to 

  .. math:: \tau_x(y) = \tau_{0}\sin(\pi \frac{y}{L_y})
     :label: eq_eg_baro_taux

 
where :math:`L_{y}` is the lateral domain extent (1200~km) and 
:math:`\tau_0` is set to :math:`0.1N m^{-2}`. 


:numref:`fig_eg_baro_simulation_config` summarizes the configuration simulated.


  .. figure:: barotropic_gyre/figs/simulation_config.*
      :width: 70%
      :align: center
      :alt: barotropic gyre configuration
      :name: fig_eg_baro_simulation_config

      Schematic of simulation domain and wind-stress forcing function for barotropic gyre numerical experiment. The domain is enclosed bu solid walls at $x=$~0,1200km and at $y=$~0,1200km.


Equations Solved
----------------

The model is configured in hydrostatic form. The implicit free surface form of the
pressure equation described in Marshall et. al \cite{marshall:97a} is
employed.
A horizontal Laplacian operator $\nabla_{h}^2$ provides viscous
dissipation. The wind-stress momentum input is added to the momentum equation
for the ``zonal flow'', $u$. Other terms in the model
are explicitly switched off for this experiment configuration (see section
\ref{sec:eg-baro-code_config} ), yielding an active set of equations solved 
in this configuration as follows 

\begin{eqnarray}
\label{eq:eg-baro-model_equations}
\frac{Du}{Dt} - fv +
              g\frac{\partial \eta}{\partial x} -
              A_{h}\nabla_{h}^2u
& = &
\frac{\tau_{x}}{\rho_{0}\Delta z}
\\
\frac{Dv}{Dt} + fu + g\frac{\partial \eta}{\partial y} -
              A_{h}\nabla_{h}^2v
& = &
0
\\
\frac{\partial \eta}{\partial t} + \nabla_{h}\cdot \vec{u}
&=&
0
\end{eqnarray}

\noindent where $u$ and $v$ and the $x$ and $y$ components of the
flow vector $\vec{u}$.
\\


\subsection{Discrete Numerical Configuration}
%\label{www:tutorials}

 The domain is discretised with 
a uniform grid spacing in the horizontal set to
 $\Delta x=\Delta y=20$~km, so 
that there are sixty grid cells in the $x$ and $y$ directions. Vertically the 
model is configured with a single layer with depth, $\Delta z$, of $5000$~m. 

\subsubsection{Numerical Stability Criteria}
%\label{www:tutorials}

The Laplacian dissipation coefficient, $A_{h}$, is set to $400 m s^{-1}$.
This value is chosen to yield a Munk layer width \cite{adcroft:95},

\begin{eqnarray}
\label{eq:eg-baro-munk_layer}
M_{w} = \pi ( \frac { A_{h} }{ \beta } )^{\frac{1}{3}}
\end{eqnarray}

\noindent  of $\approx 100$km. This is greater than the model
resolution $\Delta x$, ensuring that the frictional boundary
layer is well resolved.
\\

\noindent The model is stepped forward with a 
time step $\delta t=1200$secs. With this time step the stability 
parameter to the horizontal Laplacian friction \cite{adcroft:95}



\begin{eqnarray}
\label{eq:eg-baro-laplacian_stability}
S_{l} = 4 \frac{A_{h} \delta t}{{\Delta x}^2}
\end{eqnarray}

\noindent evaluates to 0.012, which is well below the 0.3 upper limit
for stability. 
\\

\noindent The numerical stability for inertial oscillations  
\cite{adcroft:95} 

\begin{eqnarray}
\label{eq:eg-baro-inertial_stability}
S_{i} = f^{2} {\delta t}^2
\end{eqnarray}

\noindent evaluates to $0.0144$, which is well below the $0.5$ upper 
limit for stability.
\\

\noindent The advective CFL \cite{adcroft:95} for an extreme maximum 
horizontal flow speed of $ | \vec{u} | = 2 ms^{-1}$

\begin{eqnarray}
\label{eq:eg-baro-cfl_stability}
S_{a} = \frac{| \vec{u} | \delta t}{ \Delta x}
\end{eqnarray}

\noindent evaluates to 0.12. This is approaching the stability limit
of 0.5 and limits $\delta t$ to $1200s$.


.. _sec_eg_baro_code_config:

Code Configuration
------------------


The model configuration for this experiment resides under the 
directory :code:`verification/tutorial_barotropic_gyre/`.

The experiment files 
 - :code:`input/data`
 - :code:`input/data.pkg`
 - :code:`input/eedata`
 - :code:`input/windx.sin_y`
 - :code:`input/topog.box`
 - :code:`code/CPP_EEOPTIONS.h`
 - :code:`code/CPP_OPTIONS.h`
 - :code:`code/SIZE.h`

contain the code customizations and parameter settings for this 
experiments. Below we describe the customizations
to these files associated with this experiment.

\subsubsection{File {\it input/data}}
%\label{www:tutorials}

This file, reproduced completely below, specifies the main parameters 
for the experiment. The parameters that are significant for this configuration
are

\begin{itemize}

\item Line 7, \begin{verbatim} viscAh=4.E2, \end{verbatim} this line sets
the Laplacian friction coefficient to $400 m^2s^{-1}$
\item Line 10, \begin{verbatim} beta=1.E-11, \end{verbatim} this line sets
$\beta$ (the gradient of the coriolis parameter, $f$) to $10^{-11} s^{-1}m^{-1}$

\item Lines 15 and 16
\begin{verbatim}
rigidLid=.FALSE.,
implicitFreeSurface=.TRUE.,
\end{verbatim}
these lines suppress the rigid lid formulation of the surface
pressure inverter and activate the implicit free surface form
of the pressure inverter.

\item Line 27,
\begin{verbatim}
startTime=0,
\end{verbatim}
this line indicates that the experiment should start from $t=0$
and implicitly suppresses searching for checkpoint files associated
with restarting an numerical integration from a previously saved state.

\item Line 29,
\begin{verbatim}
endTime=12000,
\end{verbatim}
this line indicates that the experiment should start finish at $t=12000s$.
A restart file will be written at this time that will enable the
simulation to be continued from this point.

\item Line 30,
\begin{verbatim}
deltaTmom=1200,
\end{verbatim}
This line sets the momentum equation timestep to $1200s$.

\item Line 39,
\begin{verbatim}
usingCartesianGrid=.TRUE.,
\end{verbatim}
This line requests that the simulation be performed in a 
Cartesian coordinate system.

\item Line 41,
\begin{verbatim}
delX=60*20E3,
\end{verbatim}
This line sets the horizontal grid spacing between each x-coordinate line
in the discrete grid. The syntax indicates that the discrete grid
should be comprise of $60$ grid lines each separated by $20 \times 10^{3}m$
($20$~km).

\item Line 42,
\begin{verbatim}
delY=60*20E3,
\end{verbatim}
This line sets the horizontal grid spacing between each y-coordinate line
in the discrete grid to $20 \times 10^{3}m$ ($20$~km).

\item Line 43,
\begin{verbatim}
delZ=5000,
\end{verbatim}
This line sets the vertical grid spacing between each z-coordinate line
in the discrete grid to $5000m$ ($5$~km).

\item Line 46,
\begin{verbatim}
bathyFile='topog.box'
\end{verbatim}
This line specifies the name of the file from which the domain
bathymetry is read. This file is a two-dimensional ($x,y$) map of
depths. This file is assumed to contain 64-bit binary numbers 
giving the depth of the model at each grid cell, ordered with the x 
coordinate varying fastest. The points are ordered from low coordinate
to high coordinate for both axes. The units and orientation of the
depths in this file are the same as used in the MITgcm code. In this
experiment, a depth of $0m$ indicates a solid wall and a depth
of $-5000m$ indicates open ocean. The matlab program
{\it input/gendata.m} shows an example of how to generate a
bathymetry file.


\item Line 49,
\begin{verbatim}
zonalWindFile='windx.sin_y'
\end{verbatim}
This line specifies the name of the file from which the x-direction
surface wind stress is read. This file is also a two-dimensional
($x,y$) map and is enumerated and formatted in the same manner as the 
bathymetry file. The matlab program {\it input/gendata.m} includes example 
code to generate a valid {\bf zonalWindFile} file.  

\end{itemize}

\noindent other lines in the file {\it input/data} are standard values
that are described in the MITgcm Getting Started and MITgcm Parameters
notes.

.. literalinclude:: ../../verification/tutorial_barotropic_gyre/input/data

\begin{small}
\input{s_examples/barotropic_gyre/input/data}
\end{small}

\subsubsection{File {\it input/data.pkg}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.

\subsubsection{File {\it input/eedata}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.

\subsubsection{File {\it input/windx.sin\_y}}
%\label{www:tutorials}

The {\it input/windx.sin\_y} file specifies a two-dimensional ($x,y$) 
map of wind stress ,$\tau_{x}$, values. The units used are $Nm^{-2}$.
Although $\tau_{x}$ is only a function of $y$n in this experiment
this file must still define a complete two-dimensional map in order
to be compatible with the standard code for loading forcing fields 
in MITgcm. The included matlab program {\it input/gendata.m} gives a complete
code for creating the {\it input/windx.sin\_y} file.

\subsubsection{File {\it input/topog.box}}
%\label{www:tutorials}


The {\it input/topog.box} file specifies a two-dimensional ($x,y$) 
map of depth values. For this experiment values are either
$0m$ or {\bf -delZ}m, corresponding respectively to a wall or to deep
ocean. The file contains a raw binary stream of data that is enumerated
in the same way as standard MITgcm two-dimensional, horizontal arrays.
The included matlab program {\it input/gendata.m} gives a complete
code for creating the {\it input/topog.box} file.

\subsubsection{File {\it code/SIZE.h}}
%\label{www:tutorials}

Two lines are customized in this file for the current experiment

\begin{itemize}

\item Line 39, 
\begin{verbatim} sNx=60, \end{verbatim} this line sets
the lateral domain extent in grid points for the
axis aligned with the x-coordinate.

\item Line 40, 
\begin{verbatim} sNy=60, \end{verbatim} this line sets
the lateral domain extent in grid points for the
axis aligned with the y-coordinate.

\end{itemize}

\begin{small}
\input{s_examples/barotropic_gyre/code/SIZE.h}
\end{small}

\subsubsection{File {\it code/CPP\_OPTIONS.h}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.


\subsubsection{File {\it code/CPP\_EEOPTIONS.h}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.


