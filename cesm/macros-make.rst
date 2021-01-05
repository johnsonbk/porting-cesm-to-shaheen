###########
Macros.make
###########

We're trying to follow Brian Dobbins' instructions about using ``Macros.make``
to change the compiler flags in order to use a different parallel netCDF
library.

.. code-block::

   $ source activate py27   
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts/
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.f09_f09_mg17 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [...]
   Creating Case directory /lustre/project/k1421/cases/FHIST.f09_f09_mg17
   $ cd /lustre/project/k1421/cases/FHIST.f09_f09_mg17
   $ ./case.setup

After ``case.setup`` is run the ``Macros.make`` file is available in the 
``$CASEROOT`` directory. According to the instructions from Brian that we
posted on the :doc:`/cesm/libraries` page.

.. attention::

   **LEFT OFF HERE.**  We've opened Macros.make and there are many unfamiliar
   options regarding which of the SLIBS lines to edit (lines 94-115).
