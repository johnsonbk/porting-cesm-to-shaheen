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

