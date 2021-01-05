########
obs_diag
########

Running obs_diag on CAM output
==============================

Change directory to the case's run directory:

.. code-block::

   $ cd /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.104.e0250/run

Echo a list of all of the ``obs_seq.final`` files into a text file:

.. code-block::

   $ ls -d -1 "$PWD/"\*final\*00000\* > /lustre/project/k1421/DART/models/cam-fv/work/obs_seq_final_list.txt

Change directory to DART's CAM-FV work directory:

.. code-block::

   $ cd /lustre/project/k1421/DART/models/cam-fv/work/

Edit the ``&obs_diag_nml`` namelist in ``input.nml`` to reflect our
experimental configuration:

.. code-block:: fortran

   &obs_diag_nml
      obs_sequence_name = ''
      obs_sequence_list = 'obs_seq_final_list.txt'
      first_bin_center =  2019, 8, 6, 12, 0, 0
      last_bin_center  =  2019, 8, 18, 12, 0, 0
      bin_separation   =     0, 0, 1, 0, 0, 0
      bin_width        =     0, 0, 1, 0, 0, 0
      time_to_skip     =     0, 0, 0, 0, 0, 0
      max_num_bins     = 1000
      trusted_obs      = 'null'
      plevel_edges = 1036.5, 962.5, 887.5, 775, 600, 450, 350, 275, 225,   175,   125,   75,   35,   15,    2
      hlevel_edges =    200, 630,   930,  1880,3670,5680,7440,9130,10530,12290, 14650,18220,23560,29490,43000
      Nregions   = 3
      lonlim1    =   0.0,   0.0,   0.0
      lonlim2    = 360.0, 360.0, 360.0
      latlim1    =  20.0, -20.0, -90.0
      latlim2    =  90.0,  20.0, -20.0
      reg_names  = 'Northern Hemisphere', 'Tropics', 'Southern Hemisphere'
      print_mismatched_locs = .false.
      create_rank_histogram = .true.
      outliers_in_histogram = .true.
      use_zero_error_obs    = .false.
      verbose               = .false.
   /

Since Shaheen doesn't seem to be able to run the Fortran executables from the
login nodes, we need to make a batch script to submit that merely just runs
``obs_diag``.

.. code-block::

   $ vim run_obs_diag.csh

.. code-block::

   #!/bin/csh
 
   #SBATCH --job-name=run_obs_diag
   #SBATCH --account=k1421
   #SBATCH --ntasks=1
   #SBATCH --ntasks-per-node=1
   #SBATCH --time=00:59:00
   #SBATCH --partition=workq
   #SBATCH --output=run_obs_diag.out.%j
 
   ./obs_diag
 
   exit 0

Submit the script we just created and wait for it to complete. It will create
a file named ``obs_diag_output.nc``.

.. code-block::

  $ sbatch run_obs_diag.csh
  [...]
  $ ls -lart
  obs_diag_output.nc

Using the MATLAB Diagnostic Scripts
===================================

Now that we have ``obs_diag_output.nc``, we can use the MATLAB diagnostic 
scripts to see statistics about the ensemble. Navigate to the DART
sub-directory containing the diagnostic scripts and start MATLAB.

.. code-block::

  $ mv obs_diag_output.nc $DARTROOT/diagnostics/matlab
  $ cd $DARTROOT/diagnostics/matlab
  $ matlab

Once MATLAB is open, run ``plot_evolution.m`` using:

.. code-block::

  >> fname   = 'obs_diag_output.nc';
  >> copy    = 'bias';
  >> plotdat = plot_evolution(fname, copy);

This will output a slew of diagnostic plots.
