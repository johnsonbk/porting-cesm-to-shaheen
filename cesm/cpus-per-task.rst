#############
cpus-per-task
#############

Overview
========

One of the ongoing issues is trying to understand how to handle the ambiguity 
with respect to how a CPU is defined. The Crays have 2 sockets and each
processor occupying the socket has 16 cores, but invoking
``scontrol show nodes`` will print out the node configuration of Shaheen's Cray
XC40 nodes:

.. code-block::

   $ scontrol show nodes
   NodeName=nid07679 Arch=x86_64 CoresPerSocket=16 
   CPUAlloc=64 CPUTot=64 CPULoad=64.00
   [...]

The configuration considers each core to have 2 threads. Thus each node has
32 CPUs per socket and 64 CPUs per node.

In the Shaheen entry of the ``config_machines.xml`` file, we copy values
defined in the Cori Haswell entry and set ``MAX_TASKS_PER_NODE`` and 
``MAX_MPI_TASKS_PER_NODE`` as follows:

.. code-block:: xml

   <MAX_TASKS_PER_NODE>32</MAX_TASKS_PER_NODE>
   <MAX_MPITASKS_PER_NODE>32</MAX_MPITASKS_PER_NODE>

From this `DiscussCESM post <https://bb.cgd.ucar.edu/cesm/threads/trouble-running-on-cori.5832/>`_,
we know that on Cori Haswell the ``srun`` command is invoked with the
``--cpus-per-task 2`` option, which, according to Brian Dobbins 
instructs the node not do use hyperthreading.

This documents our attempt to build two cases, the first in which ``srun`` is
given the ``--cpus-per-task 2`` option and the second in which ``srun`` isn't 
given the option.

Parallel netCDF library
=======================

In this attempt we use the ``cray-parallel-netcdf`` library.

.. code-block:: xml

   <modules mpilib="!mpi-serial">
      <command name="load">cray-parallel-netcdf/1.11.1.1</command>
   </modules>
   <environment_variables>
      <env name="PNETCDF_PATH">/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0</env>
   </environment_variables>

This library is the one used in ``cime/scripts/Tools/Makefile``:

.. code-block::

   ifdef LIB_PNETCDF
      CPPDEFS += -D_PNETCDF
      SLIBS += -L$(LIB_PNETCDF) -lpnetcdf
   endif

Attempt to spoof a Cori Haswell Run
===================================

.. code-block::

   $ source activate py27
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts/
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.cori-haswell.f09_f09_mg17.001 --compset FHIST --res f09_f09_mg17 --machine cori-haswell --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [...]
   $ cd /lustre/project/k1421/cases/FHIST.cori-haswell.f09_f09_mg17.001
   $ ./case.setup
   ERROR: inputdata root is not a directory or is not readable: /project/projectdirs/ccsm1/inputdata

We need to change the paths in ``config_machines.xml`` 

<machine MACH="cori-haswell">
<!-- 2021-01-14 BKJ: Changing the Directories for Cori to see if I can execute ./preview_run on Shaheen-->
<!--<DIN_LOC_ROOT>/project/projectdirs/ccsm1/inputdata</DIN_LOC_ROOT>
<DIN_LOC_ROOT_CLMFORC>/project/projectdirs/ccsm1/inputdata/atm/datm7</DIN_LOC_ROOT_CLMFORC>
<DOUT_S_ROOT>$CIME_OUTPUT_ROOT/archive/$CASE</DOUT_S_ROOT>
<BASELINE_ROOT>/project/projectdirs/ccsm1/ccsm_baselines</BASELINE_ROOT>
<CCSM_CPRNC>/project/projectdirs/ccsm1/tools/cprnc.corip1/cprnc</CCSM_CPRNC>-->

<DIN_LOC_ROOT>/lustre/project/k1421/cesm_store/inputdata</DIN_LOC_ROOT>
<DIN_LOC_ROOT_CLMFORC>/lustre/project/k1421/cesm_store/inputdata/atm/datm7</DIN_LOC_ROOT_CLMFORC>
<DOUT_S_ROOT>$CIME_OUTPUT_ROOT/archive/$CASE</DOUT_S_ROOT>
<BASELINE_ROOT>/lustre/project/k1421/cesm_store/baselines</BASELINE_ROOT>
<CCSM_CPRNC>/lustre/project/k1421/CESM/cime/tools/cprnc</CCSM_CPRNC>
</machine>

.. code-block::

   $ source activate py27
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts/
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.cori-haswell.f09_f09_mg17.002 --compset FHIST --res f09_f09_mg17 --machine cori-haswell --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [...]
   $ cd /lustre/project/k1421/cases/FHIST.cori-haswell.f09_f09_mg17.002
   $ ./case.setup
   ERROR: inputdata root is not a directory or is not readable: /project/projectdirs/ccsm1/inputdata

Trial 1: srun isn't given the --cpus-per-task 2 option
======================================================

$ source activate py27
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts/
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.cpus-per-task.f09_f09_mg17.001 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [...]
   Creating Case directory /lustre/project/k1421/cases/FHIST.cpus-per-task.f09_f09_mg17.001
   $ cd /lustre/project/k1421/cases/FHIST.cpus-per-task.f09_f09_mg17.001
   $ ./case.setup
   $ ./preview_run
   [...]
   srun  --label  -n 384  --cpus-per-task 2 /lustre/scratch/x_johnsobk/FHIST.cpus-per-task.f09_f09_mg17.002/bld/cesm.exe  >> cesm.log.$LID 2>&1
   $ ./case.build
   [...]

Trial 2: srun is given the --cpus-per-task 2 option
===================================================

We edit ``/lustre/project/k1421/cesm2_1_3/cime/config/cesm/machines/config_machines.xml``
to use ``--cpus-per-task 2``.

.. code-block:: xml

   <mpirun mpilib="default">
      <executable>srun</executable>
      <arguments>
         <!-- Default arguments from Cori-Haswell-->
         <arg name="label"> --label</arg>
         <arg name="num_tasks" > -n {{ total_tasks }}</arg>
         <!--<arg name="binding"> -c {{ srun_binding }}</arg>-->
         <arg name="binding"> --cpus-per-task 2</arg>
      </arguments>
   </mpirun>

We then build the case.

.. code-block::

   $ source activate py27
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts/
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.cpus-per-task.f09_f09_mg17.002 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [...]
   Creating Case directory /lustre/project/k1421/cases/FHIST.cpus-per-task.f09_f09_mg17.002
   $ cd /lustre/project/k1421/cases/FHIST.cpus-per-task.f09_f09_mg17.002
   $ ./case.setup
   $ ./preview_run
   [...]
   srun  --label  -n 384  --cpus-per-task 2 /lustre/scratch/x_johnsobk/FHIST.cpus-per-task.f09_f09_mg17.002/bld/cesm.exe  >> cesm.log.$LID 2>&1
   $ ./case.build
   [...]
   Time spent not building: 14.555864 sec
   Time spent building: 606.567624 sec
   MODEL BUILD HAS FINISHED SUCCESSFULLY

.. note::

   Can we just build a case and tell ``.create_newcase`` that we 

Third case:

<arg name="binding"> --cpus-per-task 2</arg>
AND