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

.. code-block:: bash

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



