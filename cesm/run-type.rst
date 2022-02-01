########
Run type
########

I can't find the run type documentation for CESM2, but the analagous
documentation from CESM1 can be found on this `Running CESM page
<https://www.cesm.ucar.edu/models/cesm1.1/cesm/doc/usersguide/c1128.html>`_.

.. note::

   There was some confusion on my part about whether the KiloCAM experiment
   should be a branch or a hybrid run. To extend the Reanalysis from 2019 to
   2020, Kevin set up a branch run because it allowed him to change the SST
   forcing for the reanalysis while, at the same time, using restart files.
   For the KiloCAM experiment, we require using ``perturb_single_instance`` to
   generate the thousand members, which only works on initial files rather than
   restart files, so it should be set up as a hybrid run.

Initial files
=============

The initial files from the CAM6 reanalysis are here:

.. code-block::

   /lustre/project/k1421/Reanalyses/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest/2018-01-01-00000

The individual filenames are of the form:

.. code-block::

   f.e21.FHIST_BGC.f09_025.CAM6assim.011.cam_00??.i.2018-01-01-00000.nc

Using ``perturb_single_instance``
=================================

The ``&perturb_single_instance_nml`` namelist in ``input.nml`` has this
structure:

.. code-block::

   &perturb_single_instance_nml
      ens_size               = 3
      input_files            = 'caminput.nc'
      output_files           = 'cam_pert1.nc','cam_pert2.nc','cam_pert3.nc'
      output_file_list       = ''
      perturbation_amplitude = 0.2
   /

The simplest way to generate the initial ensemble is to use a symbolic link
for ``caminput.nc`` and write the names of the desired perturbed initial files
into the file declared in ``output_file_list``.

