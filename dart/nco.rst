###
NCO
###

One of the CAM assimilation scripts used in the experiment uses ``nco``:

.. code-block::

   /lustre/project/k1421/DART/models/cam-fv/shell_scripts/cesm2_1/assimilate.csh.template

It uses ``ncgen`` (which is already available on Shaheen II) and ``ncks``:

.. code-block::

   [...]
   994    ncgen -k netCDF-4 -o ${CASE}.dart.r.${scomp}.${ATM_DATE_EXT}.nc inf_restart_list.cdl
   [...]
   1000   module load nco
   [...]
   1019   ncks -O -v $vars[$c] $f ../run_shadow/$f

After the 25 January 2022 software update, the ``nco`` installation no longer
worked, with the error message:

.. error::

   nco: This library has not been built for this programming environment...
   please switch to GNU or Intel programming environment first with the command (PrgEnv-intel).

This error message gets printed even if ``PrgEnv-intel`` is loaded.

It is possible to use Conda to install ``nco``:

.. code-block::

   source acivate py27
   conda install -c conda-forge nco

