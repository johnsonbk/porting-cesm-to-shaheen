##############
Compiling DART
##############

Programming Environment
=======================

Of the environments available on Shaheen, we are using the Intel programming 
environment, ``PrgEnv-intel``, because the new DART algorithms use ``mkl``. As  
an alternative, the Cray programming environment, ``PrgEnv-cray``, contains the
``cray-libsci`` which provides the same  functionality as mkl. Brian Dobbins 
and his former coworkers in ASAP have working software on NERSC’s Cori system
(which is a Cray XC40) using ``PrgEnv-cray`` and ``cray-libsci``. However, they
found that CESM ran ~10-15% faster there using the Intel compilers.

This DART build, ``/lustre/project/k1421/DART_beta/``, does not have any
``mkl`` dependencies so we can configure the build templates.

Two of these templates to actually work:

::

   /lustre/project/k1421/DART_beta/mkmf.template.PrgEnv-intel.WORKING
   /lustre/project/k1421/DART_beta/mkmf.template.PrgEnv-cray.WORKING

They are both built using ``mkmf.template.pgi.cray`` as a starting point, since
it contains the Cray compiler wrappers that we should be using on Shaheen, but
they have different compiler flags and paths to netCDF.

Cray Programming Environment
----------------------------

To build with the Cray compilers using ``PrgEnv-cray``:

.. code-block:: bash

   $ module load cray-netcdf
   $ nc-config --all
   ...
   --includedir  /opt/cray/pe/netcdf/4.6.3.2/include
   --libdir      /opt/cray/pe/netcdf/4.6.3.2/CRAYCLANG/9.0/lib

Thus, in ``mkmf.template`` this configuration works:

.. code-block::

   INCS = -I/opt/cray/pe/netcdf/4.6.3.2/include
   LIBS = -L/opt/cray/pe/netcdf/4.6.3.2/CRAYCLANG/9.0/lib -lnetcdff -lnetcdf
   FFLAGS  = -O $(INCS)
   LDFLAGS = $(INCS) $(LIBS)

The compiler does print out a lot of disconcerting warnings.

Intel Programming Environment
-----------------------------

To build with Intel compilers using ``PrgEnv-intel`` and ``mkl``:

.. code-block:: bash

   $ module swap PrgEnv-cray PrgEnv-intel
   $ module load cray-netcdf
   $ module unload cray-libsci
   $ nc-config --all
   ...
   --includedir  /opt/cray/pe/netcdf/4.6.3.2/include
   --libdir      /opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0/lib
   ...

In ``mkmf.template`` this configuration works:

.. code-block::

   MPIFC = ftn
   MPILD = ftn
   FC = ftn
   LD = ftn
   INCS = -I/opt/cray/pe/netcdf/4.6.3.2/include
   LIBS = -L/opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0/lib -lnetcdff -lnetcdf FFLAGS  = -O -assume buffered_io -xAVX -mkl $(INCS)
   LDFLAGS = $(FFLAGS) $(LIBS)

When running ``quickbuild.csh`` for lorenz_63 and lorenz_96, the compiler
prints out a perplexing warning:

::

   ifort: command line warning #10121: overriding '-xCORE-AVX2' with '-xAVX'

This doesn’t make sense because we’re not using the ``-xCORE-AVX2`` flag in the
first place. "AVX" stands for Advanced Vector Extension, which is an extension
to the x86 instruction set architecture that makes use of the additional
registers in modern CPUs to handle calculations more efficiently.
