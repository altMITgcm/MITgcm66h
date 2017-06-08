.. _packagesI:

Physical Parameterizations - Packages I
***************************************


In this chapter and in the following chapter, the MITgcm 'packages' are
described. While you can carry out many experiments with MITgcm by starting
from case studies in section \ref{sec:modelExamples}, configuring
a brand new experiment or making major changes to an experimental configuration
requires some knowledge of the *packages*
that make up the full MITgcm code. Packages are used in MITgcm to
help organize and layer various code building blocks that are assembled
and selected to perform a specific experiment. Each of the specific experiments
described in section \ref{sec:modelExamples} uses a particular combination
of packages.

:numref:`package_organigramme` shows the full set of packages that
are available. As shown in the figure packages are classified into different
groupings that layer on top of each other. The top layer packages are
generally specialized to specific simulation types. In this layer there are
packages that deal with biogeochemical processes, ocean interior
and boundary layer processes, atmospheric processes, sea-ice, coupled
simulations and state estimation.
Below this layer are a set of general purpose
numerical and computational packages. The general purpose numerical packages
provide code for kernel numerical alogorithms
that apply to
many different simulation types. Similarly, the general purpose computational
packages implement non-numerical alogorithms that provide parallelism,
I/O and time-keeping functions that are used in many different scenarios.

  .. figure:: figs/mitgcm_package_organisation.*
    :width: 70%
    :align: center
    :alt: One model for atmospheric and oceanic simulations
    :name: package_organigramme

    Hierarchy of code layers that are assembled to make up an MITgcm simulation. Conceptually (and in terms of code organization) MITgcm consists of several layers. At the base is a layer of core software that provides a basic numerical and computational foundation for MITgcm simulations. This layer is shown marked *Foundation Code* at the bottom of the figure and corresponds to code in the italicised subdirectories on the figure. This layer is not organized into packages. All code above the foundation layer is organized as packages.  Much of the code in MITgcm is contained in packages which serve as a useful way of organizing and layering the different levels of functionality that make up the full MITgcm software distribution. The figure shows the different packages in MITgcm as boxes containing bold face upper case names.  Directly above the foundation layer are two layers of general purpose infrastructure software that consist of computational and numerical packages.  These general purpose packages can be applied to both online and offline simulations and are used in many different physical simulation types.  Above these layers are more specialized packages.


The following sections describe the packages shown in
figure \ref{fig:package_organigramme}. Section \ref{sec:pkg:using}
describes the general procedure for using any package in MITgcm.
Following that sections \ref{sec:pkg:gad}-\ref{sec:pkg:monitor}
layout the algorithms implemented in specific packages
and describe how to use the individual packages. A brief synopsis of the
function of each package is given in table \ref{tab:package_summary_tab}.
Organizationally package code is assigned a
separate subdirectory in the MITgcm code distribution
(within the source code directory \texttt{pkg}).
The name of this subdirectory is used as the package name in
table \ref{tab:package_summary_tab}.

%% In this chapter the schemes for parameterizing processes that are not
%% represented explicitly in MITgcm are described.  Some of these
%% processes are sub-grid scale (SGS) phenomena, other processes, such as
%% open-boundaries, are external to the simulation.

\begin{table}
\caption{~}
\label{tab:package_summary_tab}.
\end{table}

% Overview
\newpage
\input{s_phys_pkgs/text/packages.tex}

Packages Related to Hydrodynamical Kernel
=========================================

\input{s_phys_pkgs/text/generic_advdiff.tex}

\newpage
\input{s_phys_pkgs/text/shap_filt.tex}

\newpage
\input{s_phys_pkgs/text/zonal_filt.tex}

\newpage
\input{s_phys_pkgs/text/exch2.tex}

\newpage
\input{s_phys_pkgs/text/gridalt.tex}

% Some Mention of Packages that are part of the main model document
\newpage

General purpose numerical infrastructure packages
=================================================

.. include:: obcs.rst


\newpage
\input{s_phys_pkgs/text/rbcs.tex}

\newpage
\input{s_phys_pkgs/text/ptracers.tex}

% Ocean Packages
\newpage

Ocean Packages
==============

\input{s_phys_pkgs/text/gmredi.tex}

\newpage
\input{s_phys_pkgs/text/kpp.tex}

\newpage
\input{s_phys_pkgs/text/ggl90.tex}

\newpage
\input{s_phys_pkgs/text/opps.tex}

\newpage
\input{s_phys_pkgs/text/kl10.tex}

\newpage
\input{s_phys_pkgs/text/bulk_force.tex}

\newpage
\input{s_phys_pkgs/text/exf.tex}

\newpage
\input{s_phys_pkgs/text/cal.tex}

\newpage
\section{Atmosphere Packages}
\input{s_phys_pkgs/text/aim.tex}

\newpage
\input{s_phys_pkgs/text/land.tex}

\newpage
\input{s_phys_pkgs/text/fizhi.tex}

\newpage
\section{Sea Ice Packages}
\input{s_phys_pkgs/text/thsice.tex}

\newpage
\input{s_phys_pkgs/text/seaice.tex}

\newpage
\input{s_phys_pkgs/text/shelfice.tex}

\newpage
\input{s_phys_pkgs/text/streamice.tex}

\newpage
\section{Packages Related to Coupled Model}
\input{s_phys_pkgs/text/aim_compon_interf.tex}

\newpage
\input{s_phys_pkgs/text/atm_ocn_coupler.tex}

\newpage
\input{s_phys_pkgs/text/component_communications.tex}

\newpage
\section{Biogeochemistry Packages}
\input{s_phys_pkgs/text/gchem.tex}

\newpage
\input{s_phys_pkgs/text/dic.tex}
