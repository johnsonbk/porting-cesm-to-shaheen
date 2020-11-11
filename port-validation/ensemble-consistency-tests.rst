##########################
Ensemble Consistency Tests
##########################

The Ensemble Consistency Tests (ECT) are intended to determine whether output
from a ported setup is statistically indistinguishable from a ensemble run on a
trusted machine. Once the ensembles complete, history files are uploaded to the
verification tests page of the `CESM2 python tools website
<http://www.cesm.ucar.edu/models/cesm2/python-tools/>`_.

.. note:: When running these tests initially on Shaheen, the scripts weren't 
   able to run to completion because they weren't compabile with python3. I 
   rewrote the relevant parts of the scripts and made a `pull request to
   Allison Baker's PyCECT repository <https://github.com/NCAR/PyCECT/pull/8>`_.
   Thus, when running these tests on Shaheen, it was necessary to use python 
   2.7.

There are three sets of tests: a CAM and ultrafast CAM (UF-CAM) test and a POP
test.

POP Ensemble Consistency Test
=============================

The POP test requires only running a single instance of POP for comparison to 
the ensemble run on Cheyenne.

.. code-block:: bash

   $ cd /lustre/project/k1421/CESM/cime/tools/statistical_ensemble_test
   $ python ensemble.py --case /lustre/scratch/x_johnsobk/cesm2.1.3/G.T62_g17.cesm2.1.3.000 --ect pop --mach shaheen --project k1421 --compset G --res T62_g17 --ensemble 1

This passes the verification tests.

CAM Ensemble Consistency Test
=============================

The CAM test requires running three instances of CAM for comparison to the 
ensemble run on Cheyenne.

.. warning:: CGD does not run CAM ensembles for each of the minor releases of 
   CESM. As of the 20th of September, 2020 `there was no ensemble available for
   CESM2.1.3 <https://bb.cgd.ucar.edu/cesm/threads/availability-of-cesm-2-1-3-ensemble-consistency-test-summary-files.5369/#post-36859>`_
   and (it seems) no plans to create one. Thus, this ensemble will not pass the
   verification tests.

.. code-block:: bash

   $ cd /lustre/project/k1421/CESM/cime/tools/statistical_ensemble_test
   $ python ensemble.py --case /lustre/scratch/x_johnsobk/cesm2.1.3/F2000climo.f19_f19_mg17.cesm2.1.3.000 --ect cam --mach shaheen --project k1421 --compset F2000climo --res f19_f19_mg17 --ensemble 3

This fails the verification tests.

UF-CAM Ensemble Consistency Test
================================

The UF-CAM test requires running three instances of CAM for a short 6-hour 
integration for comparison to the ensemble run on Cheyenne.

.. code-block:: bash

   $ cd /lustre/project/k1421/CESM/cime/tools/statistical_ensemble_test
   $ python ensemble.py --case /lustre/scratch/x_johnsobk/cesm2.1.3/uf.F2000climo.f19_f19_mg17.cesm2.1.3.000 --ect cam --uf --mach shaheen --project k1421 --compset F2000climo --res f19_f19_mg17 --ensemble 3

This passes the verification tests.
