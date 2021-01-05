################
Case Timing Data
################

Overview
========

CIME uses the `General Purpose Timing Library (GPTL)
<https://esmci.github.io/cime/versions/master/html/users_guide/timers.html>`_
to provide detailed timing information.

Timing files are output to ``$CASEROOT/timing/$model_timing.$CASE.$datestamp``.

The two areas we plan to focus on to increase the model performance is to
understand the bottlenecks occuring during the ``Init Time`` phase of each job.

Does init time take longer for first job in hybrid run?
-------------------------------------------------------

No. I suspected that the init time might take longer for the first submission
of a given integration since there may be initialization tasks involved for a
hybrid run in which continue_run = FALSE but this seems to be fals.

For the first submission of FHIST_BGC.f09_d025.052.e3 ``Init Time : 539.420
seconds`` while in the second submission ``Init Time: 562.777 seconds``.

Major Issue: Init Time
======================

It's unclear how to disassemble the ``Init Time`` statistic to determine what
is causing the initialization to be so slow.

.. code-block::
   
   $ cd /lustre/project/k1421/cesm2_1_3/cime
   $ grep -Rl "Init Time" ./
   ./doc/source/users_guide/timers.rst
   ./tools/load_balancing_tool/tests/timing/timing_2
   ./tools/load_balancing_tool/tests/timing/timing_3
   ./tools/load_balancing_tool/tests/timing/timing_1
   ./scripts/lib/CIME/get_timing.py

It looks like ``get_timing.py`` is the best candidate to look through for the
relevant code:

.. code-block:: python

   nmax  = self.gettime(' CPL:INIT ')[1]
   ...
   self.write("    Init Time   :  {:10.3f} seconds \n".format(nmax))

Previously Encountered Problem
==============================

In 
``_create_component_modelio_namelists``

.. note::

   This is the file to look in to see what is taking so long.
   /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.095.e500/run/cpl_0229.log.17860564.201220-165938.gz

