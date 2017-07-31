Overview
********

This document provides the reader with the information necessary to
carry out numerical experiments using MITgcm. It gives a comprehensive
description of the continuous equations on which the model is based, the
numerical algorithms the model employs and a description of the associated
program code. Along with the hydrodynamical kernel, physical and
biogeochemical parameterizations of key atmospheric and oceanic processes
are available. A number of examples illustrating the use of the model in
both process and general circulation studies of the atmosphere and ocean are
also presented.

Introduction
============

MITgcm has a number of novel aspects:

 - it can be used to study both atmospheric and oceanic phenomena; one hydrodynamical kernel is used to drive forward both atmospheric and oceanic models - see :numref:`onemodel`

  .. figure:: figs/onemodel.*
    :width: 70%
    :align: center
    :alt: One model for atmospheric and oceanic simulations
    :name: onemodel

    MITgcm has a single dynamical kernel that can drive forward either oceanic or atmospheric simulations.


 - it has a non-hydrostatic capability and so can be used to study both small-scale and large scale processes - see :numref:`all-scales`

  .. figure:: figs/scales.*
    :width: 70%
    :align: center
    :alt: MITgcm can simulate a wide range of scales
    :name: all-scales

    MITgcm has non-hydrostatic capabilities, allowing the model to address a wide range of phenomenon - from convection on the left, all the way through to global circulation patterns on the right.

 - finite volume techniques are employed yielding an intuitive discretization and support for the treatment of irregular geometries using orthogonal curvilinear grids and shaved cells - see :numref:`fvol`

  .. figure:: figs/fvol.*
    :width: 70%
    :align: center
    :alt: Finit volume techniques
    :name: fvol

    Finite volume techniques (bottom panel) are user, permitting a treatment of topography that rivals :math:`\sigma` (terrain following) coordinates.

 - tangent linear and adjoint counterparts are automatically maintained along with the forward model, permitting sensitivity and optimization studies.

 - the model is developed to perform efficiently on a wide variety of computational platforms.


Key publications reporting on and charting the development of the model are :cite:`hill:95,marshall:97a,marshall:97b,adcroft:97,mars-eta:98,adcroft:99,hill:99,maro-eta:99,adcroft:04a,adcroft:04b,marshall:04` (an overview on the model formulation can also be found in :cite:`adcroft:04c`):

Hill, C. and J. Marshall, (1995)
Application of a Parallel Navier-Stokes Model to Ocean Circulation in 
Parallel Computational Fluid Dynamics
In Proceedings of Parallel Computational Fluid Dynamics: Implementations 
and Results Using Parallel Computers, 545-552.
Elsevier Science B.V.: New York

Marshall, J., C. Hill, L. Perelman, and A. Adcroft, (1997)
Hydrostatic, quasi-hydrostatic, and nonhydrostatic ocean modeling
J. Geophysical Res., 102(C3), 5733-5752.

Marshall, J., A. Adcroft, C. Hill, L. Perelman, and C. Heisey, (1997)
A finite-volume, incompressible Navier Stokes model for studies of the ocean
on parallel computers,
J. Geophysical Res., 102(C3), 5753-5766.

Adcroft, A.J., Hill, C.N. and J. Marshall, (1997)
Representation of topography by shaved cells in a height coordinate ocean
model
Mon Wea Rev, vol 125, 2293-2315

Marshall, J., Jones, H. and C. Hill, (1998)
Efficient ocean modeling using non-hydrostatic algorithms
Journal of Marine Systems, 18, 115-134

Adcroft, A., Hill C. and J. Marshall: (1999)
A new treatment of the Coriolis terms in C-grid models at both high and low
resolutions,
Mon. Wea. Rev. Vol 127, pages 1928-1936

Hill, C, Adcroft,A., Jamous,D., and J. Marshall, (1999)
A Strategy for Terascale Climate Modeling.
In Proceedings of the Eighth ECMWF Workshop on the Use of Parallel Processors
in Meteorology, pages 406-425
World Scientific Publishing Co: UK

Marotzke, J, Giering,R., Zhang, K.Q., Stammer,D., Hill,C., and T.Lee, (1999)
Construction of the adjoint MIT ocean general circulation model and 
application to Atlantic heat transport variability
J. Geophysical Res., 104(C12), 29,529-29,547.


We begin by briefly showing some of the results of the model in action to
give a feel for the wide range of problems that can be addressed using it.


Illustrations of the model in action
====================================
MITgcm has been designed and used to model a wide range of phenomena,
from convection on the scale of meters in the ocean to the global pattern of
atmospheric winds - see :numref:`all-scales`. To give a flavor of the
kinds of problems the model has been used to study, we briefly describe some
of them here. A more detailed description of the underlying formulation,
numerical algorithm and implementation that lie behind these calculations is
given later. Indeed many of the illustrative examples shown below can be
easily reproduced: simply download the model (the minimum you need is a PC
running Linux, together with a FORTRAN\ 77 compiler) and follow the examples
described in detail in the documentation.


.. toctree::
   :maxdepth: 3

   global_atmos_hs.rst
   ocean_gyres.rst
   global_ocean_circ.rst
   cvct_mixing_topo.rst
   bound_forc_inter_waves.rst
   parm_sens.rst
   global_state_est.rst
   ocean_biogeo_cyc.rst
   sim_lab_exp.rst

 
