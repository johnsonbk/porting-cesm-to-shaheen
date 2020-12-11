################
Regression Tests
################

Building cprnc
==============

In order for the regression tests to work, the ``cprnc`` tool (which is a 
truncation of the phrase "compare NetCDF") must be built.

.. code-block:: bash

  $ cd /lustre/project/k1421/cesm2_1_relsd_m5.6/cime/tools/cprnc
  $ CIMEROOT=../.. ../configure --macros-format=Makefile --mpilib=mpi-serial
  $ CIMEROOT=../.. source ./.env_mach_specific.sh && make

Edit config_machines.xml
========================

Now we set the path to cprnc within config_machines.xml:

.. code-block:: bash

   $ cd /lustre/project/k1421/CESM/cime/config/cesm/machines
   $ vim config_machines.xml
   <CCSM_CPRNC>/lustre/project/k1421/CESM/cime/tools/cprnc</CCSM_CPRNC>

Run the tests
=============

.. code-block:: bash

   $ cd /lustre/project/k1421/CESM/cime/scripts/tests
   $ ./scripts_regression_tests.py

It is unclear what constitutes a good result in a regression test. In this post
by `Zoe Gillett on the DiscussCESM bulletin boards <https://bb.cgd.ucar.edu/cesm/threads/failed-scripts-regression-tests-for-cesm2-on-new-machine.5290/>`_ a lot of the regression tests fail and
Jim Edwards responds that, "If you are satisfied with the integrity of the
experiments you want to run I think you can call this a good result."

