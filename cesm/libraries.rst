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
but perhaps did not rewrite the flag correctly.

Instructions Regarding Macros.make
==================================

Brian Dobbins suggests:

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
  
Attempting to Build a Case Using Macros.make
============================================

We'll try to build a case using Brian's instructions. The first step is editing
``config_machines.xml``.

config_machines.xml
-------------------

.. code-block::

   $ vim /lustre/project/k1421/cesm2_1_3/cime/config/cesm/machines/config_machines.xml

Edit the module loaded when the mpi library is not mpi-serial.

.. code-block:: xml

   <modules mpilib="!mpi-serial">
      <command name="load">cray-netcdf-hdf5parallel/4.6.3.2</command>
   </modules>
   [...]
   <environment_variables>
      <env name="PNETCDF_PATH">/opt/cray/pe/netcdf-hdf5parallel/4.6.3.2/INTEL/19.0</env>
   </environment_variables>

Again, if we examine the parallel netCDF libraries:

.. code-block::

   $ ls /opt/cray/pe/netcdf-hdf5parallel/4.6.3.2/INTEL/19.0/lib
   [...]
   libnetcdff_parallel.a

We see that the linker flag should be ``-lnetcdff_parallel``.

Setup Case
----------

We're trying to follow Brian Dobbins' instructions about using ``Macros.make``
to change the compiler flags in order to use a different parallel netCDF
library.

.. code-block::

   $ source activate py27   
   $ cd /lustre/project/k1421/cesm2_1_3/cime/scripts/
   $ ./create_newcase --case /lustre/project/k1421/cases/FHIST.f09_f09_mg17.001 --compset FHIST --res f09_f09_mg17 --machine shaheen --project k1421 --run-unsupported --ninst 3 --multi-driver --walltime 2:00:00
   [...]
   Creating Case directory /lustre/project/k1421/cases/FHIST.f09_f09_mg17.001
   $ cd /lustre/project/k1421/cases/FHIST.f09_f09_mg17.001
   $ ./case.setup

Edit Macros.make
----------------

After ``case.setup`` is run the ``Macros.make`` file is available in the 
``$CASEROOT`` directory. According to the instructions from Brian reposted
above, we should edit the ``Macros.make`` to add the ``-lnetcdff_parallel``
flag:

.. code-block::

   ifeq ($(MPILIB),mvapich2)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif
   ifeq ($(MPILIB),mpich2)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif
   ifeq ($(MPILIB),mpt)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif
   ifeq ($(MPILIB),openmpi)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif
   ifeq ($(MPILIB),mpich)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif
   ifeq ($(MPILIB),mvapich)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif
   ifeq ($(MPILIB),impi)
     SLIBS := $(SLIBS)  -lnetcdff_parallel -mkl=cluster 
   endif

After editing ``Macros.make`` we attempt to build the case:

.. code-block::

   $ case.build
   [...]
   ERROR: /lustre/project/k1421/cesm2_1_3/cime/src/build_scripts/buildlib.pio
   FAILED, cat /lustre/scratch/x_johnsobk/FHIST.f09_f09_mg17.001/bld/pio.bldlog.210106-234616
   cat /lustre/scratch/x_johnsobk/FHIST.f09_f09_mg17.001/bld/pio.bldlog.210106-234616

.. error::

   In spite of following the instructions, this procedure still results in the 
   same error that we arrived at while attempting to edit the ``Makefile``
   directly. Here we reprint the relevant section of
   ``/lustre/scratch/x_johnsobk/FHIST.f09_f09_mg17.001/bld/pio.bldlog.210106-234616``:

   .. code-block::

      Configuring incomplete, errors occurred!
      See also "/lustre/scratch/x_johnsobk/FHIST.f09_f09_mg17.001/bld/intel/mpt/nodebug/nothreads/pio/pio1/CMakeFiles/CMakeOutput.log".
      gmake: Leaving directory '/lustre/scratch/x_johnsobk/FHIST.f09_f09_mg17.001/bld/intel/mpt/nodebug/nothreads/pio/pio1'
      cat: Filepath: No such file or directory
      cat: Srcfiles: No such file or directory
      Building PIO with netcdf support
      CMake Error at /sw/xc40cle7/cmake/3.13.4/sles15_gcc7.4.1/install/share/cmake-3.13/Modules/FindPackageHandleStandardArgs.cmake:137 (message):
      Could NOT find PnetCDF_Fortran (missing: PnetCDF_Fortran_LIBRARY
      PnetCDF_Fortran_INCLUDE_DIR)
      

