###################
Load Balancing Tool
###################

Overview
========

The load balancing tool attempts to find a reasonable processor element (PE)
layout for a given compset and resolution.

Instructions
============

In order for the load balancing tool to run correctly, the CIME scripts and 
load balancing tool directories should be added to the PYTHONPATH environmental
variable.

.. code-block:: bash

  CIME_DIR=/lustre/project/k1421/cesm2_1_3/cime
  PYTHONPATH=$CIME_DIR/scripts:$CIME_DIR/tools/load_balancing_tool:$PYTHONPATH


