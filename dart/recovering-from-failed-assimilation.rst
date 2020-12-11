#####################################
Recovering from a Failed Assimilation
#####################################

Sometimes the ``assimilate.csh`` script will error out and must be rerun.

For example, when running the Kilo-CAM ensemble for the first time, the
integration took much, much longer than it should've and it hit the 12:00:00
job wallclock limit. I resubmitted the job, but there were extraneous CESM logs
present due to the failed integration, thus when ``assimilate.csh`` was run
it exited with the following message:

.. code-block::

   ERROR: Too many cesm.log files (3) for the 1 restart sets.
   Clean out the cesm.log files from failed cycles.

So let's do just that:

.. code-block::

   $ cd /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.090.e1000/run
   $ ls cesm.log*
   cesm.log.17201900.201203-174150  cesm.log.17246904.201206-104359.gz  cesm.log.17325936.201207-142703
   $ mv cesm.log.17201900.201203-174150 ~/

The script comments say that:

.. code-block::

  The (resulting) assimilate.csh script is called by CESM with two arguments:
  1) the CASEROOT, and
  2) the assimilation cycle number in this CESM job

The task is to rerun ``assimilate.csh``.

.. code-block:: bash

   $ cd /lustre/project/k1421/cases/FHIST_BGC.f09_d025.090.e1000
   $ ./xmlquery CASEROOT
   CASEROOT: /lustre/project/k1421/cases/FHIST_BGC.f09_d025.090.e1000
   $ ./xmlquery DATA_ASSIMILATION_CYCLES
   DATA_ASSIMILATION_CYCLES: 1
   $ csh
   $ csh DART_config
   $ csh ./assimilate.csh /lustre/project/k1421/cases/FHIST_BGC.f09_d025.090.e1000 1
   ...
   LAUNCHCMD: Undefined variable.

