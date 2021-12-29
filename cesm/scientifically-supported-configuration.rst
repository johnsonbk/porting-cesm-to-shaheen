######################################
Scientifically supported configuration
######################################

Overview
========

As discussed in the :doc:`/cesm/grid-and-compset` page, the scientifically 
supported configuration used in the experiment is the ``FHIST`` compset and the
``f09_f09_mg17`` grid.

Scientifically supported grid
=============================

The scientifically supported grid for the FHIST compset is the ``f09_f09_mg17``
grid. For more information, see the
`CAM documentation <https://ncar.github.io/CAM/doc/build/html/users_guide/atmospheric-configurations.html>`_.
Efficiency testing should be done with this grid before moving on to the CAM6 
Reanalysis grid.

Cori
----

.. note::

   On Cori the default version of python is 2.7.18. Thus the multi-instance
   cesm2.1.3 build script doesn't crash because of attempted concatenation of a 
   string and an int. There is no need to create a python 2.7 environment.

.. code-block::

   $ cd /project/projectdirs/m3857/cesm2_1_3/cime/scripts
   $ ./create_newcase --case /project/projectdirs/m3857/cases/FHIST.f09_f09_mg17.e001.n0003 --compset FHIST --res f09_f09_mg17 --machine cori-haswell --project m3857 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [ ... ]
   Creating Case directory /project/projectdirs/m3857/cases/FHIST.f09_f09_mg17.e001.n0003
   $ cd /project/projectdirs/m3857/cases/FHIST.f09_f09_mg17.e001.n0003
   $ ./case.setup
   $ ./case.build
   [ ... ]
   MODEL BUILD HAS FINISHED SUCCESSFULLY
   $ ./case.submit -M begin,end

Shaheen
-------

.. caution::
   
   On Shaheen the default version of python is 3.7.7. Thus the multi-instance
   cesm2.1.3 build script crashes because of attempted concatenation of a 
   string and an int (which isn't allowed in python 3). It was necessary to
   create a python 2.7 environment using conda. It is activated using the
   ``source activate py27`` line.

   Additionally, the LibXML2 library is missing from most of the login nodes. 
   Thus it is necessary to build on cdl5.

.. code-block::

   $ ssh cdl5
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts
   $ source activate py27
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.f09_f09_mg17.e001.n0003 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [ ... ]
   Creating Case directory /lustre/project/k1421/cases/FHIST.f09_f09_mg17.e001.n0003
   $ cd /lustre/project/k1421/cases/FHIST.f09_f09_mg17.e001.n0003
   $ ./case.setup
   $ ./case.build
   [ ... ]
   MODEL BUILD HAS FINISHED SUCCESSFULLY
   $ ./case.submit -M begin,end

Cheyenne
--------

.. note::

   On Cheyenne the default version of python is 2.7.16. Thus the multi-instance
   cesm2.1.3 build script doesn't crash because of attempted concatenation of a 
   string and an int. There is no need to create a python 2.7 environment.

.. warning::

   Running a build of CESM on a Cheyenne login node will likely result in one
   of the daemons killing the build script due to the build "using an excessive
   amount of the total available CPU resources." Thus use the ``qcmd`` build 
   wrapper and options for the ``./case.build`` script.

.. code-block::

   $ cd /glade/work/johnsonb/cesm2_1_3/cime/scripts
   $  ./create_newcase --case /glade/work/johnsonb/cases/FHIST.f09_f09_mg17.e001.n0003 --compset FHIST --res f09_f09_mg17 --machine cheyenne --project P86850054 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [ ... ]
   Creating Case directory /glade/work/johnsonb/cases/FHIST.f09_f09_mg17.e001.n0003
   $ cd /glade/work/johnsonb/cases/FHIST.f09_f09_mg17.e001.n0003
   $ ./case.setup
   $ qcmd -q share -l select=1 -A P86850054 -- ./case.build
   [ ... ]
   MODEL BUILD HAS FINISHED SUCCESSFULLY
   $ ./case.submit -M begin,end

Custom Grid
===========

The port on Shaheen II uses the same grid as the `DART CAM6 Reanalysis <https://rda.ucar.edu/datasets/ds345.0/>`_,
which is a custom grid created by Kevin Raeder, called ``f09_d025``.

The grid specification is available on GLADE here:

.. code-block:: bash

   /glade/work/raeder/Models/CAM_init/SST/config_grids+fv1+2deg_oi0.25_gland20.xml

The grid has quarter-degree horizontal resolution, so that CAM can be forced with
the `AVHRR quarter-degree SST product <https://rda.ucar.edu/datasets/ds277.7/>`_.

Compset
=======

The integration uses an ``F`` with biogeochemistry. Kevin's ``CASEROOT`` on 
GLADE and his ``README.case`` are:

.. code-block:: bash

   /glade/work/raeder/Exp/f.e21.FHIST_BGC.f09_025.CAM6assim.011/README.case

The ``create_newcase`` command invoked is as follows:

.. code-block::

   /glade/work/raeder/Models/cesm2_1_relsd_m5.6/cime/scripts/create_newcase --case /glade/work/raeder/Exp/f.e21.FHIST_BGC.f09_025.CAM6assim.011 --machine cheyenne --res f09_d025 --project NCIS0006 --queue premium --walltime 1:00 --pecount 36x1 --ninst 80 --compset HIST_CAM60_CLM50%BGC-CROP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV --run-unsupported --multi-driver --gridfile /glade/work/raeder/Models/CAM_init/SST/config_grids+fv1+2deg_oi0.25_gland20.xml
