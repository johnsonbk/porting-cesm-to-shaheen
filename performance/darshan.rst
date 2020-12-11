#######
Darshan
#######

Darshan is a tool that produces a graphical summary of performance data for a 
particular job or a comparison of performance for two jobs.

George Markomanolis presented a `summary of the tool <https://www.hpc.kaust.edu.sa/sites/default/files/files/public/Shaheen_training/171107_IO/harshad_presentation.pdf>`_.

Installation
============

.. code-block:: bash

  $ cd /lustre/project/k1421
  $ mkdir -p logs/darshan
  $ git clone https://github.com/KAUST-KSL/HArshaD.git darshan
  $ cd darshan
  $ vim open_darshan.sh

Set ``export darshan_path="/lustre/project/k1421/logs/darshan"`` in 
``open_darshan.sh``.

Finding Job IDs
===============

The ``jhist`` alias, as described on the :doc:`/shaheen/slurm` page prints out
information for jobs run by a user since a specified date in YYYY-MM-DD format:

.. code-block:: bash

  $ jhist 2020-11-13
                 JobID                        JobName  Partition    Account  AllocCPUS      State ExitCode 
  -------------------- ------------------------------ ---------- ---------- ---------- ---------- -------- 
              16435549 run.FHIST_BGC.f09_d025.084.e03      workq      k1421        768  COMPLETED      0:0 
        16435549.batch                          batch                 k1421         64  COMPLETED      0:0 
            16435549.0                       cesm.exe                 k1421        384  COMPLETED      0:0 

Run Darshan for a Specific Job
==============================

Then pass desired the JobID to the Darshan scripts.

.. code-block:: bash

  $ ./open_darshan.sh 16435549
