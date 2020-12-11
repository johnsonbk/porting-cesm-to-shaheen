#########
Libraries
#########

Parallel NetCDF String
======================

The default makefile in ``${CIMEROOT}/scripts/Tools/Makefile`` has a hard-wired
compiler flag to link the parallel NetCDF library in it, of the form 
``-lpnetcdf``. This works for the ``parallel_netcdf`` library since
the static library is:

.. code-block:: bash

  ``/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/lib/libpnetcdf.a``

However, the ``netcdf-hdf5parallel`` library has a compiler flag of the form
``-lnetcdff_parallel`` since the static library is:

.. code-block:: bash

  ``/opt/cray/pe/netcdf-hdf5parallel/4.6.3.2/INTEL/19.0/lib/libnetcdff_parallel.a``

I attempted to rewrite the compiler link flag in ``${CIMEROOT}/scripts/Tools/Makefile``
but perhaps did not rewrite the flag correctly. Brian Dobbins suggests:

  You should just be able to modify (as a test) the Macros.make file in a case
  directory and add something like:
  
  .. code-block:: bash
   
    SLIBS += -lnetcdf_parallel
  
  That should let it find that library (though it might complain if SLIBS
  already has ``-lpnetcdf`` in it and it can't find that one, in which case you
  can do:
  
  .. code-block:: bash
  
    SLIBS := -lnetcdf_parallel
  
  You might need to add other things, like the math libraries or NetCDF
  libraries, too.  For example, on the cloud config, I use:
  
  .. code-block:: bash
  
    SLIBS := -lalapack -lblas -lnetcdf -lpnetcdf

