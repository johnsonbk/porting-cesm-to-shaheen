###################
Load Balancing Tool
###################

Overview
========

The load balancing tool attempts to find a reasonable processor element (PE)
layout for a given compset and resolution.

Instructions
============

The instructions for the tool are available in the `CIME documentation <https://esmci.github.io/cime/versions/maint-5.6/html/misc_tools/load-balancing-tool.html>`_ In order for the load balancing
tool to run correctly, the CIME scripts and load balancing tool directories
should be added to the PYTHONPATH environmental variable.

.. code-block:: bash

  CIME_DIR=/lustre/project/k1421/cesm2_1_3/cime
  PYTHONPATH=$CIME_DIR/scripts:$CIME_DIR/tools/load_balancing_tool:$PYTHONPATH

Then run the submit script after specifying a given resolution, compset and
PEs file.

.. code-block:: bash

   $ cd /lustre/project/k1421/cesm2_1_3/cime/tools/load_balancing_tool
   $ ./load_balancing_submit.py –res <RESOLUTION> –compset <COMPSET> –pesfile <PESFILE>

After the jobs finish, run the solver:

.. code-block:: bash

   $ ./load_balancing_solve.py –total-tasks <N> –blocksize 8

