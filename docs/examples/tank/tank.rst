.. _sec_eg_tank:

A Rotating Tank in Cylindrical Coordinates
==========================================

\begin{center}
(in directory: {\it verification/rotating\_tank/})
\end{center}

\subsection{Overview}
%\label{www:tutorials}
                                                                          
This example configuration demonstrates using the MITgcm to simulate a
laboratory demonstration using a differentially heated rotating
annulus of water.  The simulation is configured for a laboratory scale
on a $3^{\circ}\times1\mathrm{cm}$ cyclindrical grid with twenty-nine
vertical levels of 0.5cm each.  This is a typical laboratory setup for
illustration principles of GFD, as well as for a laboratory data
assimilation project. The files for this experiment can be found in
the verification directory under rotating\_tank.
\\

example illustration from GFD lab here
\\



 

\subsection{Equations Solved}
%\label{www:tutorials}


\subsection{Discrete Numerical Configuration}
%\label{www:tutorials}

 The domain is discretised with a uniform cylindrical grid spacing in
the horizontal set to $\Delta a=1$~cm and $\Delta \phi=3^{\circ}$, so
that there are 120 grid cells in the azimuthal direction and
thirty-one grid cells in the radial, representing a tank 62cm in
diameter.  The bathymetry file sets the depth=0 in the nine lowest
radial rows to represent the central of the annulus.  Vertically the
model is configured with twenty-nine layers of uniform 0.5cm
thickness.
\\
something about heat flux

\subsection{Code Configuration}
%\label{www:tutorials}
\label{sec:eg-tank-code_config}

The model configuration for this experiment resides under the
directory {\it verification/rotatingi\_tank/}.  The experiment files
\begin{itemize}
\item {\it input/data}
\item {\it input/data.pkg}
\item {\it input/eedata},
\item {\it input/bathyPol.bin},
\item {\it input/thetaPol.bin},
\item {\it code/CPP\_EEOPTIONS.h}
\item {\it code/CPP\_OPTIONS.h},
\item {\it code/SIZE.h}.
\end{itemize}

contain the code customizations and parameter settings for this 
experiments. Below we describe the customizations
to these files associated with this experiment.

\subsubsection{File {\it input/data}}
%\label{www:tutorials}

This file, reproduced completely below, specifies the main parameters 
for the experiment. The parameters that are significant for this configuration
are

\begin{itemize}

\item Lines 9-10, \begin{verbatim} 
viscAh=5.0E-6, 
viscAz=5.0E-6,
\end{verbatim} 


These lines set the Laplacian friction coefficient in the horizontal
and vertical, respectively.  Note that they are several orders of
magnitude smaller than the other examples due to the small scale of
this example.

\item Lines 13-16, \begin{verbatim} 
 diffKhT=2.5E-6,
 diffKzT=2.5E-6,
 diffKhS=1.0E-6,
 diffKzS=1.0E-6,

\end{verbatim} 


These lines set horizontal and vertical diffusion coefficients for
temperature and salinity.  Similarly to the friction coefficients, the
values are a couple of orders of magnitude less than most
 configurations.


\item Line 17, \begin{verbatim}f0=0.5 , \end{verbatim} this line sets the 
coriolis term, and represents a tank spinning at about 2.4 rpm.

\item Lines 23 and 24
\begin{verbatim}
rigidLid=.TRUE.,
implicitFreeSurface=.FALSE.,
\end{verbatim}

These lines activate  the rigid lid formulation of the surface
pressure inverter and suppress the implicit free surface form
of the pressure inverter.

\item Line 40,
\begin{verbatim}
nIter=0,
\end{verbatim}
This line indicates that the experiment should start from $t=0$ and
implicitly suppresses searching for checkpoint files associated with
restarting an numerical integration from a previously saved state.
Instead, the file thetaPol.bin will be loaded to initialized the
temperature fields as indicated below, and other variables will be
initialized to their defaults.


\item Line 43,
\begin{verbatim}
deltaT=0.1,
\end{verbatim}
This line sets the integration timestep to $0.1s$.  This is an
unsually small value among the examples due to the small physical
scale of the experiment.  Using the ensemble Kalman filter to produce
input fields can necessitate even shorter timesteps.

\item Line 56,
\begin{verbatim}
usingCylindricalGrid=.TRUE.,
\end{verbatim}
This line requests that the simulation be performed in a 
cylindrical coordinate system.

\item Line 57,
\begin{verbatim}
dXspacing=3,
\end{verbatim}
This line sets the azimuthal grid spacing between each $x$-coordinate line
in the discrete grid. The syntax indicates that the discrete grid
should be comprised of $120$ grid lines each separated by $3^{\circ}$.
                                                                               

\item Line 58,
\begin{verbatim}
dYspacing=0.01,
\end{verbatim}

This line sets the radial cylindrical grid spacing between each
$a$-coordinate line in the discrete grid to $1cm$.

\item Line 59,
\begin{verbatim}
delZ=29*0.005,
\end{verbatim}

This line sets the vertical grid spacing between each of 29
z-coordinate lines in the discrete grid to $0.005m$ ($5$~mm).

\item Line 64,
\begin{verbatim}
bathyFile='bathyPol.bin',
\end{verbatim}
This line specifies the name of the file from which the domain
``bathymetry'' (tank depth) is read. This file is a two-dimensional 
($a,\phi$) map of
depths. This file is assumed to contain 64-bit binary numbers 
giving the depth of the model at each grid cell, ordered with the $\phi$ 
coordinate varying fastest. The points are ordered from low coordinate
to high coordinate for both axes.  The units and orientation of the
depths in this file are the same as used in the MITgcm code. In this
experiment, a depth of $0m$ indicates an area outside of the tank
and a depth
f $-0.145m$ indicates the tank itself. 

\item Line 65,
\begin{verbatim}
hydrogThetaFile='thetaPol.bin',
\end{verbatim}
This line specifies the name of the file from which the initial values 
of temperature
are read. This file is a three-dimensional
($x,y,z$) map and is enumerated and formatted in the same manner as the 
bathymetry file. 

\item Lines 66 and 67
\begin{verbatim}
 tCylIn  = 0
 tCylOut  = 20
\end{verbatim}
These line specify the temperatures in degrees Celsius of the interior
and exterior walls of the tank -- typically taken to be icewater on
the inside and room temperature on the outside.


\end{itemize}

\noindent Other lines in the file {\it input/data} are standard values
that are described in the MITgcm Getting Started and MITgcm Parameters
notes.

\begin{small}
\input{s_examples/rotating_tank/input/data}
\end{small}

\subsubsection{File {\it input/data.pkg}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.

\subsubsection{File {\it input/eedata}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.

\subsubsection{File {\it input/thetaPol.bin}}
%\label{www:tutorials}

The {\it input/thetaPol.bin} file specifies a three-dimensional ($x,y,z$) 
map of initial values of $\theta$ in degrees Celsius.  This particular 
experiment is set to random values x around 20C to provide initial 
perturbations.

\subsubsection{File {\it input/bathyPol.bin}}
%\label{www:tutorials}


The {\it input/bathyPol.bin} file specifies a two-dimensional ($x,y$) 
map of depth values. For this experiment values are either
$0m$ or {\bf -delZ}m, corresponding respectively to outside or inside of
the tank. The file contains a raw binary stream of data that is enumerated
in the same way as standard MITgcm two-dimensional, horizontal arrays.

\subsubsection{File {\it code/SIZE.h}}
%\label{www:tutorials}

Two lines are customized in this file for the current experiment

\begin{itemize}

\item Line 39, 
\begin{verbatim} sNx=120, \end{verbatim} this line sets
the lateral domain extent in grid points for the
axis aligned with the x-coordinate.

\item Line 40, 
\begin{verbatim} sNy=31, \end{verbatim} this line sets
the lateral domain extent in grid points for the
axis aligned with the y-coordinate.

\end{itemize}

\begin{small}
\input{s_examples/rotating_tank/code/SIZE.h}
\end{small}

\subsubsection{File {\it code/CPP\_OPTIONS.h}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.


\subsubsection{File {\it code/CPP\_EEOPTIONS.h}}
%\label{www:tutorials}

This file uses standard default values and does not contain
customizations for this experiment.

