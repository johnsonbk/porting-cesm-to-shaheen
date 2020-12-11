################
Grid and Compset
################

Custom Grid
===========

The port on Shaheen II uses the same grid as the `DART CAM Reanalysis <https://rda.ucar.edu/datasets/ds345.0/>`_,
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
