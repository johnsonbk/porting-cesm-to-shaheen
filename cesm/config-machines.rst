###################
config_machines.xml
###################


Tasks per node
==============

The Cray XC40 is comprised of dual-socket nodes with Haswell processors that
have 16 cores per socket (thus 32 cores per node).

There seems to be a nuance here, in that the Haswell CPUs each have two
ThreadsPerCore so the ``MAX_TASKS_PER_NODE`` should be twice the
``MAX_MPITASKS_PER_NODE``.

.. code-block:: xml

   <MAX_TASKS_PER_NODE>64</MAX_TASKS_PER_NODE>
   <MAX_MPITASKS_PER_NODE>32</MAX_MPITASKS_PER_NODE>

This is different from the configuration stated in ``config_machines.xml`` for
Cheyenne, which also has dual-socket nodes but with Broadwell processors that
have 18 cores per socket (thus 36 cores per node). However, for Cheyenne
``MAX_TASKS_PER_NODE`` is set to the same value as ``MAX_MPITASKS_PER_NODE``:

.. code-block:: xml

   <MAX_TASKS_PER_NODE>36</MAX_TASKS_PER_NODE>
   <MAX_MPITASKS_PER_NODE>36</MAX_MPITASKS_PER_NODE>

One question
============

The cpl logs comparing an 80 member ensemble run on Cheyenne versus an 80 member
run on Shaheen show that the Cheyenne ensemble is using much more memory
(an order of magnitude greater at peak). Why?

We ran tests trying to see if it's because the srun script mistakenly doesn't
request all the memory on a node. That doesn't seem to be the case. These 
timing files are from two jobs, the first with the default configuration and 
the second with the ``#SBATCH  --mem=0`` directive present in the job script:

.. code-block::

   /lustre/project/k1421/cases/FHIST_BGC.f09_d025.097.e80/timing/cesm_timing_0080.FHIST_BGC.f09_d025.097.e80.17866538.201223-080254
   /lustre/project/k1421/cases/FHIST_BGC.f09_d025.097.e80/timing/cesm_timing_0080.FHIST_BGC.f09_d025.097.e80.17866547.201223-085717

The Init Time is pretty comparable and the second job actually uses less peak memory.

Should we try to fiddle with the netCDF libraries again? Brian Dobbins said that
makes the biggest difference with respect to performance.

mpirun Settings
===============

After consulting with Bilel Hadri, we came upon this setting within
``config_machines.xml``:

.. code-block:: xml

   <mpirun mpilib="default">
      <executable>srun</executable>
      <arguments>
         <arg name="label"> --label</arg>
         <arg name="num_tasks" > --hint=nomultithread -n {{ total_tasks }}</arg>
         <arg name="binding" > --cpu_bind=cores</arg>
      </arguments>
   </mpirun>

The settings copied from the ``cori-haswell`` entry are:

.. code-block:: xml

   <mpirun mpilib="default">
      <executable>srun</executable>
      <arguments>
           <arg name="label"> --label</arg>
           <arg name="num_tasks" > -n {{ total_tasks }}</arg>
           <arg name="binding"> -c {{ srun_binding }}</arg>
      </arguments>
   </mpirun>

