#####
SLURM
#####

Shaheen uses the Simple Linux Utility for Resource Management (SLURM) system
for job scheduling.

Aliases
=======

Since the status and kill commands for SLURM differ from PBS, it is useful to
set up common aliases, for example in ``.bashrc``:
 
.. code-block:: bash
 
  # Terminate a job when given its job id
  alias jkill='scancel'
  # Print user's jobs and status
  alias jstat='squeue -u $USER'
  # Start an interactive session on a compute node
  alias jinter='srun -u --pty bash -i'
  # Print out jobs that have run since a start date
  alias jhist='sacct -u $USER --format="JobID%20,JobName%30,Partition,Account,AllocCPUS,State,ExitCode" -S'

The last alias, ``jhist``, prints out jobs that have been completed since a
given start date:

.. code-block::

  $ jhist 2020-11-13
                 JobID                        JobName  Partition    Account  AllocCPUS      State ExitCode
  -------------------- ------------------------------ ---------- ---------- ---------- ---------- --------
              16435549 run.FHIST_BGC.f09_d025.084.e03      workq      k1421        768  COMPLETED      0:0
        16435549.batch                          batch                 k1421         64  COMPLETED      0:0
            16435549.0                       cesm.exe                 k1421        384  COMPLETED      0:0


Job Queue
=========
 
The standard job queue on Shaheen is ``workq``.

Resource Binding
================

SLURM is `highly configurable <https://slurm.schedmd.com/resource_binding.html>`_
with respect to its ability to bind tasks to various resources such as
"threads, cores, sockets, NUMA or boards."


Node Configuration
==================

To see the configuration of Shaheen's Cray XC40 nodes, invoking
``scontrol show nodes`` will print out the node configuration:

.. code-block::

   $ scontrol show nodes
   NodeName=nid07679 Arch=x86_64 CoresPerSocket=16 
   CPUAlloc=64 CPUTot=64 CPULoad=64.00
   AvailableFeatures=(null)
   ActiveFeatures=(null)
   Gres=craynetwork:4
   NodeAddr=nid07679 NodeHostName=nid07679 Version=20.02.6
   OS=Linux 4.12.14-150.17_5.0.91-cray_ari_c #1 SMP Wed May 27 02:24:01 UTC 2020 (6b16d42) 
   RealMemory=128803 AllocMem=128448 FreeMem=123036 Sockets=2 Boards=1
   State=ALLOCATED ThreadsPerCore=2 TmpDisk=0 Weight=1 Owner=N/A MCS_label=N/A
   Partitions=workq,72hours 
   BootTime=2020-12-03T10:05:38 SlurmdStartTime=2020-12-03T10:22:30
   CfgTRES=cpu=64,mem=128803M,billing=64
   AllocTRES=cpu=64,mem=128448M
   CapWatts=n/a
   CurrentWatts=47 AveWatts=0
   ExtSensorsJoules=n/s ExtSensorsWatts=0 ExtSensorsTemp=n/s

When counting CPUs per node, there are:

- ``Sockets=2``
- ``CoresPerSocket=16``
- ``ThreadsPerCore=2``

Thus ``cpu=64``. Should we set: ``--ntasks-per-node=32`` or
``--ntasks-per-node=64``?

Default Settings
================

To see the default settings for SLURM, invoking the ``scontrol show config``
command will print all of the settings:

.. code-block::

   $ scontrol show config
   ...
   DefMemPerCPU            = 2007
   ...
   MaxTasksPerNode         = 512
   ...

We see, for example, that ``DefMemPerCPU = 2007`` (which is reported in 
megabytes, ``M``) and there are 64 cpu/node, thus the memory per node is
``2007M*64=128448M`` which is consisent with the printout of
``scontrol show nodes`` above.

Analogs for Cheyenne
====================

While Cheyenne uses PBS rather than SLURM it's usefult to have their settings
as well. The analagous command for ``scontrol show nodes`` is ``pbsnodes -a``.

.. code-block::

   $ pbsnodes -a
   r8i5n1
   Mom = r8i5n1.ib0.cheyenne.ucar.edu
   ntype = PBS
   state = free
   pcpus = 72
   resources_available.arch = linux
   resources_available.host = r8i5n1
   resources_available.iru = r8i5
   resources_available.iru2 = r8i4i5
   resources_available.mem = 131567260kb
   resources_available.ncpus = 72
   resources_available.nodetype = largemem
   resources_available.Qlist = system,special,ampsrt,capability,premium,regular,standby,economy,small
   resources_available.rack = r8
   resources_available.rack16 = r1r2r3r4r5r6r7r8r9r10r11r12r13r14r15r16
   resources_available.rack2 = r15r16
   resources_available.rack4 = r13r14r15r16
   resources_available.rack8 = r9r10r11r12r13r14r15r16
   resources_available.switch = r8i5a0s0
   resources_available.switchblade = r8i5s0
   resources_available.vnode = r8i5n1
   resources_assigned.accelerator_memory = 0kb
   resources_assigned.hbmem = 0kb
   resources_assigned.mem = 0kb
   resources_assigned.naccelerators = 0
   resources_assigned.ncpus = 0
   resources_assigned.vmem = 0kb
   comment =  
   resv_enable = True
   sharing = default_shared
   license = l
   last_state_change_time = Mon Dec 21 17:14:09 2020
   last_used_time = Mon Dec 21 17:14:09 2020

We haven't been able to find the analagous command for ``scontrol show config``.