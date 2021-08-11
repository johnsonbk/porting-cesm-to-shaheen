#########
Arm Forge
#########

Overview
========

`Arm Forge <https://developer.arm.com/tools-and-software/server-and-hpc/debug-and-profile/arm-forge>`_
is a suite of HPC development tools. It includes `Arm DDT <https://developer.arm.com/tools-and-software/server-and-hpc/debug-and-profile/arm-forge/arm-ddt>`_,
a graphical debugger that can be run from one to thousands of threads.

Recompiling
===========

In order for DDT to work optimally, CESM should be recompiled using two
different compiler flags, ``-g`` which produces debugging information in the
operating system's native object format and ``-O0`` which compiles without 
optimizations.

Recompiling on Shaheen
----------------------

Recompiling with the ``-g`` and ``-O0`` flags requires editing
``/lustre/project/k1421/cesm2_1_3/cime/config/cesm/machines/config_compilers.xml``.

Editing:

.. code-block::

   <FFLAGS>
      <append> -xCORE-AVX2 </append>
      <append DEBUG="FALSE"> -O2  </append>
   </FFLAGS>

to append this pair of flags when ``DEBUG="TRUE"``:

.. code-block::

   <FFLAGS>
      <append> -xCORE-AVX2 </append>
      <append DEBUG="FALSE"> -O2  </append>
      <append DEBUG="TRUE"> -O0 -g </append>
   </FFLAGS>

Recompiling requires logging onto cdl5 and turning on debugging before
building:

.. code-block::

   $ ssh cdl5
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts
   $ source activate py27
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.f09_f09_mg17.e002.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [ ... ]
   Creating Case directory /lustre/project/k1421/cases/FHIST.f09_f09_mg17.e002.n0003
   $ cd /lustre/project/k1421/cases/FHIST.f09_f09_mg17.e002.n0003
   $ ./xmlchange DEBUG=TRUE
   $ ./xmlquery DEBUG
     DEBUG: TRUE
   $ ./case.setup
   $ ./case.build

