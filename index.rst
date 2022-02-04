.. CESM Porting Documentation documentation master file, created by
   sphinx-quickstart on Fri Oct 30 17:26:59 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Porting CESM to Shaheen Documentation
=====================================

This documents our attempt to port the `Community Earth System Model
(CESM) <https://www.cesm.ucar.edu/>`_ to `Shaheen II
<https://www.hpc.kaust.edu.sa/>`_
which is a Cray XC40 at `King Abdullah University of Science and Technology
<https://www.kaust.edu.sa/en>`_.

The purpose of porting CESM is to test data assimilation algorithms using
1000-member ensembles of the `Community Atmosphere Model (CAM)
<https://www.cesm.ucar.edu/models/cesm2/atmosphere/>`_.

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Shaheen
   
   /shaheen/environment
   /shaheen/slurm
   /shaheen/filesystem

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Aftermath

   /aftermath/compiling

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: DART

   /dart/compiling
   /dart/configuration-notes
   /dart/generating-the-initial-ensemble
   /dart/sampling-error-table
   /dart/recovering-from-failed-assimilation
   /dart/nco

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Diagnostics

   /diagnostics/obs-diag

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: CESM

   /cesm/grid-and-compset
   /cesm/libraries
   /cesm/list-of-attempts
   /cesm/cime-comp-mod
   /cesm/config-machines
   /cesm/cpus-per-task
   /cesm/scientifically-supported-configuration
   /cesm/run-type

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: CIME

   /cime/troubleshooting
   /cime/libxml

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Performance

   /performance/load-balancing-tool
   /performance/case-timing-data
   /performance/file-striping
   /performance/darshan
   /performance/intel-vtune
   /performance/arm-forge

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Port Validation

   /port-validation/ensemble-consistency-tests
   /port-validation/regression-tests

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: NERSC Cori

   /cori/environment

.. toctree::
   :maxdepth: 2
   :hidden:

   /README
