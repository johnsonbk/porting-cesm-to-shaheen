###############################
Generating the Initial Ensemble
###############################

In order to generate the initial 1000-member ensemble we will make infinitesmal
perturbations to a single initial file from Kevin's CAM reanalysis and then
run the integration with filter and adaptive inflation to spread out the
ensemble. Only the CAM initial files will be perturbed -- the hope is that
filter and adaptive inflation will adjust the remainder of the components.

Perturb Single Instance Program
===============================

The ``perturb_single_instance`` program in 
``/lustre/project/k1421/DART/models/cam-fv/work`` will take a single initial
file and then will perturb a field within it to generate an initial ensemble.

Files Needed
============

The program needs the following files in order to run:

1. ``input.nml`` - This must contain the :code:`&perturb_single_instance_nml`
   namelist with proper settings for the program to read.
2. ``campinput.nc`` - A CAM **initial** file -- not a restart file -- since 
   initial files contain the lev and T fields needed for perturbation.
3. ``cam_phis.nc`` - A CAM file containing the PHIS, or surface geopotential
   field (m :sup:`2` /s :sup:`2` ), since surface geopotential is needed to 
   compute potential temperature.
4. *(Optional)* ``output_file_list.txt`` - A text file containing the names of the
   perturbed files to be created. These names can be provided in the
   ``output_files`` field of ``input.nml``. However, since we want 1000
   perturbed files it is easier to specify them in a seperate text file and
   setting the ``output_file_list`` field of ``input.nml``.

Steps to Generate the Necessary Files
=====================================

We create an empty directory in which to build our ensemble.

.. code-block:: bash

   $ cd /lustre/scratch/x_johnsobk/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest
   $ mv  2019-08-05-00000 2019-08-05-00000-original
   $ mkdir 2019-08-05-00000
   $ cd 2019-08-05-00000

perturb_single_instance
-----------------------

Then we copy ``perturb_single_instance`` from the model's work directory.

.. code-block:: bash
   
   $ cp /lustre/project/k1421/DART/models/cam-fv/work/perturb_single_instance ./

input.nml
---------

Then we start by configuring ``input.nml``, which must contain the 
``&perturb_single_instance_nml`` namelist in order for the program to work.

.. code-block:: bash

   $ cp /lustre/project/k1421/DART/models/cam-fv/work/input.nml.original ./input.nml
   $ vim input.nml

We configure the namelist so that the program builds a 1000-member ensemble,
looks for an initial file known as ``caminput.nc`` and a text file containing
the names of the desired output files known as ``output_file_list.txt``.

.. code-block:: fortran

  &perturb_single_instance_nml
     ens_size               = 1000
     input_files            = 'caminput.nc'
     output_files           = ''
     output_file_list       = 'output_file_list.txt'
     perturbation_amplitude = 0.2
  /

An additional file is also specified in the ``cam_phis_filename`` field of the 
``&model_nml`` namelist.

.. code-block:: fortran

  &model_nml
     cam_template_filename       = 'caminput.nc'
     cam_phis_filename           = 'cam_phis.nc'
     ...
  /

caminput.nc
-----------

We copy one of the initial files from Kevin's CAM reanalysis.

.. code-block:: bash

   $ cp ../2019-08-05-00000-original/f.e21.FHIST_BGC.f09_025.CAM6assim.011.cam_0001.i.2019-08-05-00000.nc ./caminput.nc


cam_phis.nc
-----------

We need to transfer ``cam_phis.nc`` from Cheyenne.

.. code-block:: bash

   $ sftp <user>@data-access.ucar.edu
   $ get /glade/scratch/raeder/f.e21.FHIST_BGC.f09_025.CAM6assim.011/run/cam_phis.nc

output_file_list.txt
--------------------

Then we write a short python script to generate a list of 1000 filenames to
insert into ``output_file_list.txt``.

.. code-block:: bash

   $ vim make_list.py

The ``make_list.py`` script is very simple.

.. code-block:: python

  #!/usr/bin/env python
 
  prefix = 'f.e21.FHIST_BGC.f09_025.CAM6assim.011.cam_'
  suffix = '.i.2019-08-05-00000.nc'
  
  f = open('output_file_list.txt', 'w')
  
  for iensemble in range(1, 1001):
      f.write(prefix+str(iensemble).zfill(4)+suffix+'\n')
    
  f.close()

When we run it, it generates ``output_file_list.txt``.

.. code-block:: bash

   $ python make_list.py
   $ ls -l output_file_list.txt
   -rw-r--r-- 1 x_johnsobk g-x_johnsobk 69000 Nov 24 20:18 output_file_list.txt

Running perturb_single_instance
===============================

Finally, with all of those files in place, we can run ``perturb_single_instance``
by first starting an interactive job on one of Shaheen's compute nodes and then
running the program.

.. warning::

   Running ``perturb_single_instance`` on a login node on Shaheen will crash
   with an error similar to:

   .. code-block:: bash
   
      Fatal error in MPI_Init: Other MPI error, error stack:
      MPIR_Init_thread(537):
      MPID_Init(246).......: channel initialization failed
      MPID_Init(647).......: PMI2 init failed: 1 libhugetlbfs

We use the ``jinter`` alias that we described in the Aliases section of the
:doc:`/shaheen/slurm` page to start an interactive job before running the 
program.

.. code-block:: bash

    $ jinter
    srun: job 16821392 queued and waiting for resources
    srun: job 16821392 has been allocated resources
    $ ./perturb_single_instance
    ...
    --------------------------------------
    Starting ... at YYYY MM DD HH MM SS =
                    2020 11 24 21 54 27
    Program perturb_single_instance
    --------------------------------------
    ...
    --------------------------------------
    Finished ... at YYYY MM DD HH MM SS =
                    2020 11 24 22  7 10
    Program perturb_single_instance
    --------------------------------------
