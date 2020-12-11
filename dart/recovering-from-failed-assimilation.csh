####################
Sampling Error Table
####################

gen_sampling_err_table
======================

In order to apply Sampling Error Correction, we use ``gen_sampling_err_table``
to compute the statistics described in Anderson (2012). [1]_

The table with the error correction values is stored in the netCDF file 
``sampling_error_correction_table.nc`` in:

.. code-block:: bash

   ${DARTROOT}/assimilation_code/programs/gen_sampling_err_table/work/

However, the table typically only contains values for ensemble sizes up to 200
ensemble members. Thus we edit ``input.nml`` in the above directory thus we 
edit the following namelist to add ensemble sizes of 250, 500 and 1000:

.. code-block:: fortran

   &gen_sampling_error_table_nml
     ens_sizes = 250, 500, 1000
     debug = .false.
   /

We then run ``quickbuild.csh`` and ``submit.csh`` the latter of which simply
submits a batch job that runs ``gen_sampling_err_table`` on a compute node.

The program required 01:53:14 on 8 CPUs to complete and add the correction 
values for the additional ensemble sizes.

DART_config.template
====================

Finally, we need to edit Line 325 of the ``DART_config.template`` script to 
reflect the fact that we are now able to run ensemble sizes of larger than 200.
The template is here:

.. code-block:: bash

   $ vim ${DARTROOT}/models/cam-fv/shell_scripts/cesm2_1/DART_config.template

And we change 200 to 1000 here:

.. code-block:: bash

   if ( $num_instances < 3 || $num_instances > 1000 ) then


References
==========

.. [1] Anderson, Jeffrey L. (2012) "Localization and Sampling Error Correction in Ensemble Kalman Filter Data Assimilation." *Monthly Weather Review* **140**: 2359-2371, doi: 10.1175/MWR-D-11-00013.1.

