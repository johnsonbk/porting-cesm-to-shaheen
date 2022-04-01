################
Recompiling CESM
################

.. important::

   The 25 January 2022 maintenance session on Shaheen caused significant
   problems for creating new CESM cases. This page documents the steps needed
   to get a working version of CESM that includes the porting modifications for
   Shaheen.

First failed attempt: recursively copy cesm2_1_3 to scratch
===========================================================

.. code-block::

   cd /lustre/project/k1421
   cp -R cesm2_1_3 /lustre/scratch/x_johnsobk
   cd /lustre/scratch/x_johnsobk/cesm2_1_3/cime/scripts
   ./create_newcase --case /lustre/scratch/x_johnsobk/cases/FHIST.cesm2_1_3.f09_f09_mg17.e001.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   cd /lustre/scratch/x_johnsobk/cases/FHIST.cesm2_1_3.f09_f09_mg17.e001.n0003
   ./case.setup
   ./case.build

This attempt fails, with issues similar to what is discussed in this `ROMS
thread <https://www.myroms.org/forum/viewtopic.php?t=5763>`_.

Downloading a clean copy of CESM
================================

.. code-block::

   cd /lustre/scratch/x_johnsobk
   git clone https://github.com/ESCOMP/CESM.git CESM
   cd /lustre/scratch/x_johnsobk/CESM
   git checkout release-cesm2.1.3
   /lustre/scratch/x_johnsobk/CESM/cime/config/cesm/machines
   
   mv config_batch.xml config_batch_old.xml
   mv config_compilers.xml config_compilers_old.xml
   mv config_machines.xml config_machines_old.xml
   
   cp /lustre/scratch/x_johnsobk/cesm2_1_3/cime/config/cesm/machines/config_machines.xml ./
   cp /lustre/scratch/x_johnsobk/cesm2_1_3/cime/config/cesm/machines/config_compilers.xml ./
   cp /lustre/scratch/x_johnsobk/cesm2_1_3/cime/config/cesm/machines/config_batch.xml ./
   
First attempt
-------------

.. code-block::

   cd /lustre/scratch/x_johnsobk/CESM/cime/scripts
   ./create_newcase --case /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e001.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00

   cd /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e001.n0003
   ./case.setup

.. error::

   /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e001.n0003♡ ./case.setup
   ERROR: Command: '/usr/bin/xmllint --noout --schema /lustre/scratch/x_johnsobk/CESM/cime/config/xml_schemas/config_compilers_v2.xsd /lustre/scratch/x_johnsobk/CESM/cime/config/cesm/machines/config_compilers.xml' failed with error '/lustre/scratch/x_johnsobk/CESM/cime/config/cesm/machines/config_compilers.xml:78: element INCLDIR: Schemas validity error : Element 'INCLDIR': This element is not expected.

Second attempt
--------------

Change the ``config_compilers`` xml schema with an older copy.

.. code-block::

   cd /lustre/scratch/x_johnsobk/CESM/cime/config/xml_schemas/
   mv config_compilers_v2.xsd config_compilers_v2_old.xsd
   cp /lustre/project/k1421/cesm2_1_3/cime/config/xml_schemas/config_compilers_v2.xsd ./

Rebuild the case.

.. code-block::

   cd /lustre/scratch/x_johnsobk/CESM/cime/scripts
   ./create_newcase --case /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e001.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00

   cd /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e001.n0003
   ./case.setup
   ./case.build

.. error::

   cat /lustre/scratch/x_johnsobk/FHIST.CESM.f09_f09_mg17.e001.n0003/bld/cesm.bldlog.220204-072500

Third attempt
-------------

Trying to build with pio2.

.. code-block::

   cd /lustre/scratch/x_johnsobk/CESM/cime/scripts
   ./create_newcase --case /lustre/scratch/x_johnsobk/cases/FHIST.CESM.PIO2.f09_f09_mg17.e002.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   ./case.setup
   ./xmlchange PIO_VERSION=2
   ./case.build
   /usr/bin/ld: /lustre/scratch/x_johnsobk/CESM/cime/src/externals/pio2/src/clib/pio_darray_int.c:1212: undefined reference to `nc_get_vara_float'

.. error::

   ERROR: BUILD FAIL: buildexe failed, cat /lustre/scratch/x_johnsobk/FHIST.CESM.PIO2.f09_f09_mg17.e002.n0003/bld/cesm.bldlog.220205-041905

Fourth attempt
--------------

Trying to change the parallel netcdf library that CESM compiles with, from
``parallel_netcdf`` to ``netcdf-hdf5parallel``.

Editing ``config_machines.xml``:

.. code-block:: xml

   <!-- <command name="load">cray-parallel-netcdf/1.12.1.4</command> -->
   <!-- BKJ 2022-02-07 PIO issues attempt -->
   <command name="load">cray-netcdf-hdf5parallel/4.7.4.4</command>
   [...]
   <!-- BKJ 2022-02-07 PIO issues attempt -->
   <!-- <env name="PNETCDF_PATH">/opt/cray/pe/parallel-netcdf/1.12.1.4/INTEL/19.1</env> -->
   <env name="PNETCDF_PATH">/opt/cray/pe/netcdf-hdf5parallel/4.7.4.4/INTEL/19.1/</env>

Attempting to build with these libraries:

.. code-block::

   cd /lustre/scratch/x_johnsobk/CESM/cime/config/cesm/machines
   xmllint --noout --schema /lustre/scratch/x_johnsobk/CESM/cime/config/xml_schemas/config_machines.xsd ./config_machines.xml
   ./config_machines.xml validates
   source activate py27
   cd /lustre/scratch/x_johnsobk/CESM/cime/scripts
   ./create_newcase --case /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e002.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   cd /lustre/scratch/x_johnsobk/cases/FHIST.CESM.f09_f09_mg17.e002.n0003
   ./case.setup
   ./case.build

Many different attempts all ended with variations of this error:

.. error::

   CMake Error at /sw/xc40cle7up03/cmake/3.22.1/sles15gcc7.5.0/share/cmake-3.22/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
   Could NOT find PnetCDF_Fortran (missing: PnetCDF_Fortran_LIBRARY
   PnetCDF_Fortran_INCLUDE_DIR)

Eight attempt
-------------

Attempt to return to the original ``parallel-netcdf`` library.

Editing ``config_machines.xml``:

.. code-block::

   <command name="load">cray-parallel-netcdf/1.12.1.4</command>
   [...]
   <env name="PNETCDF_PATH">/opt/cray/pe/parallel-netcdf/1.12.1.4/INTEL/19.1</env>

Edit the Makefile to add another linker flag.

.. code-block::

   vim /lustre/scratch/x_johnsobk/CESM/cime/scripts/Tools/Makefile

.. code-block::

   SLIBS += -L$(LIB_PNETCDF) -lpnetcdf_intel -lpnetcdf   

.. error::

   ERROR: BUILD FAIL: buildexe failed, cat /lustre/scratch/x_johnsobk/FHIST.CESM.f09_f09_mg17.e006.n0003/bld/cesm.bldlog.220208-080053

