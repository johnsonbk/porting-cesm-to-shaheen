################
List of Attempts
################

It took very, very many attempts to get a CAM ensemble performing well on 
Shaheen. 

Trial 094
=========

Rebuilding with 1000 members in case the efforts to fix the broken 
Trial 090 take much longer than expected.

Trial 093
=========

.. code-block:: bash

   $ cd /lustre/project/k1421/cases/FHIST_BGC.f09_d025.093.e500
   $ ./xmlquery JOB_WALLCLOCK_TIME
   Results in group case.run
   JOB_WALLCLOCK_TIME: 12:00:00
   Results in group case.st_archive
	JOB_WALLCLOCK_TIME: 1:00
   $ ./xmlchange --subgroup case.run  JOB_WALLCLOCK_TIME=12:00:00

Trial 092
=========

To avoid the error in Trial 91, we changed:

.. code-block:: fortran

&filter_nml
...
single_file_in = .false.
perturb_from_single_instance = .false.
...
/
making another attempt.

Trial 091
=========

Since 090 takes so long to build, this case runs with 100 members to see if the
copied restart files for ensemble members 81-100 are able to be used without 
issue before we run with 1000 members.

Result
------

The case runs to completion, however, the assimilation fails perhaps because
we changed ``single_file_in = .true.`` to get the perturbation working.

From the log file ``/lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.091.e100/run/da.log.17183899.201202-061559``:
   
.. error::
   
   .. code-block:: bash
   
      ERROR FROM:
      PE   512: direct_netcdf_mod:
      routine: direct_netcdf_mod:
      message: If using single_file_in/single_file_out = .true.
      message: ... you must have a member dimension in your input/output file.
      Rank 512 [Wed Dec  2 08:08:45 2020] [c6-1c2s11n0] application called MPI_Abort(comm=0x84000004, 99) - process 512


Trial 090
=========

Since we don't know how long it'll take to get through the run we change the 
wallclock time to ``12:00:00``.

.. code-block:: bash

   $ cd /lustre/project/k1421/cases/FHIST_BGC.f09_d025.090.e1000
   $ ./xmlquery JOB_WALLCLOCK_TIME
   Results in group case.run
   JOB_WALLCLOCK_TIME: 12:00:00
   Results in group case.st_archive
	JOB_WALLCLOCK_TIME: 1:00
   $ ./xmlchange --subgroup case.run  JOB_WALLCLOCK_TIME=12:00:00

After the error in Trial 091, we change the filter namelist since aren't using
perturb_from_single_instance:

.. code-block:: fortran

   &filter_nml
     ...
     single_file_in               = .false.
     perturb_from_single_instance = .false.
     ...
   /

Trial 089
=========

Testing how to use ``.i.`` files in a hybrid run.

I'm not sure how to use .i. files in a hybrid run rather than .r. files.

Here is the `relevant page in the CIME documentation <https://esmci.github.io/cime/versions/master/html/users_guide/cime-change-namelist.html>`_.

To test whether we can do this, change rpointer atm contents to ``.i.`` rather
than ``.r.`` and see if it works in line 1257 of ``setup_advanced_Rean``.

.. code-block:: bash

   $ ncdump -h cam_initial_0001.nc
   
shows that the initial file is an ``'i'`` file rather than an ``'r'`` file.

This, and the change from ``'r'`` to ``'i'``, also seems to suggest that it's
an initial file: ``/lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.088.e03/run/cam_initial_0001.nc``.

In ``setup_advanced_Rean`` Line 1283, we're linking the ``'i'`` files here. 
Be able to explain what the purpose is of the slwe of rpointer files:

.. code-block:: bash

   @ inst=1
      while (\$inst <= $num_instances)
         set inst_string = \`printf _%04d \$inst\`
         ${LINK} -f ${case}.cam\${inst_string}.i.\${restart_time}.nc cam_initial\${inst_string}.nc
      @ inst ++
   end

Trial 088
=========

Edit ``DART_config.template`` to set:

.. code-block:: bash

   ./xmlchange DATA_ASSIMILATION_ATM=TRUE
   ...
   if ($?CIMEROOT) ./xmlchange DATA_ASSIMILATION_SCRIPT=${CASEROOT}/assimilate.csh

Do adaptive inflation and run an assimilation cycle.

.. code-block:: fortran

   inf_flavor = 5, 0

Is it worth considering ``cray-mpich`` versus ``mpt``?

In ``config_machines.xml`` try adding:

.. code-block:: xml

   NCAR_LIBS_PNETCDF=-Wl,-Bstatic -lpnetcdf -Wl,-Bdynamic

Add ``-Wl,-Bstatic -lpnetcdf -Wl,-Bdynamic``.

Trial 087
=========

Change to 1 node per instance.

Compare this with Trial 086. It looks *nearly* the same for total cost.

.. code-block::

   setenv timewall 2:30
   total pes active           : 96
   mpi tasks per node               : 32
   pe count for cost estimate : 96
   Overall Metrics:
     Model Cost:           51504.09   pe-hrs/simulated_year
     Model Throughput:         0.04   simulated_years/day
     Init Time   :    1837.831 seconds
     Run Time    :    1322.879 seconds     5291.516 seconds/day
     Final Time  :       0.081 seconds

Trial 086
=========

Changing ``ESP`` to ``32``.

.. code-block::

   total pes active           : 384
   mpi tasks per node               : 32
   pe count for cost estimate : 384
   Overall Metrics:
      Model Cost:           50881.78   pe-hrs/simulated_year
      Model Throughput:         0.18   simulated_years/day
      Init Time   :    1364.705 seconds
      Run Time    :     326.724 seconds     1306.895 seconds/day
      Final Time  :       0.017 seconds
      Actual Ocn Init Wait Time     :       0.000 seconds
      Estimated Ocn Init Run Time   :       0.006 seconds
      Estimated Run Time Correction :       0.006 seconds
      (This correction has been applied to the ocean and total run times)

Trial 085
=========

Same as Trial 084, except changing:

.. code-block:: xml

   <arg name="binding" > --cpu_bind=cores</arg>

Trial 084
=========

Same configuration as in Trial 083 except we restripe the forcing files in
accordance with Bilel Hadri's recommendations.

Trial 083
=========

Same configuration as Trial 082 except all of the restart files are no longer
striped.

The first submission takes 00:32:41.

The second submission with  ``./case.submit --skip-preview-namelist -M begin,end``
takes 00:32:04.

Trial 082
=========

Setting ``config_machines.xml``:

.. code-block:: xml

   <modules mpilib="mpi-serial">
      <command name="load">cray-hdf5/1.10.5.2</command>
      <command name="load">cray-netcdf/4.6.3.2</command>
   </modules>
   <modules mpilib="!mpi-serial">
	   <command name="load">cray-hdf5-parallel/1.10.5.2</command>
      <command name="load">cray-parallel-netcdf/1.11.1.1</command>
   </modules>
   <env name="NETCDF_PATH">/opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0</env>
   <env name="PNETCDF_PATH">/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0</env>

Setting ``config_compilers.xml``:

.. code-block:: xml

   <SLIBS>
      <append> -L$(NETCDF_PATH) -lnetcdff -Wl,--as-needed,-L$(NETCDF_PATH)/lib -lnetcdff -lnetcdf </append>
   </SLIBS>
   <MPICC> cc </MPICC>
   <MPICXX> CC </MPICXX>
   <MPIFC> ftn </MPIFC>
   <PIO_FILESYSTEM_HINTS>lustre</PIO_FILESYSTEM_HINTS>
   <NETCDF_PATH>$ENV{NETCDF_PATH}</NETCDF_PATH>

Trial 081
=========

Setting ``config_machines.xml``:

.. code-block:: xml

   <command name="load">cray-netcdf/4.6.3.2</command>
   <command name="load">cray-netcdf-hdf5parallel/4.6.3.2</command>

Setting ``config_compilers.xml``:

.. code-block:: xml
   
   <SLIBS>
      <append> -L$(NETCDF_PATH) -lnetcdff -Wl,--as-needed,-L$(NETCDF_PATH)/lib -lnetcdff -lnetcdf </append>
   </SLIBS>
   <MPICC> cc </MPICC>
   <MPICXX> CC </MPICXX>
   <MPIFC> ftn </MPIFC>
   <PIO_FILESYSTEM_HINTS>lustre</PIO_FILESYSTEM_HINTS>
   <NETCDF_PATH>$ENV{NETCDF_PATH}</NETCDF_PATH>

Trial 079
=========

Let's try use the ``slibs`` tag instead of the parallel netcdf tag.

Setting ``config_compilers.xml``:

.. code-block:: xml

   <SLIBS>
      <append>-L$(PNETCDF_PATH_KAUST)/lib -lnetcdff_parallel</append>
   </SLIBS>
   <MPICC> cc </MPICC>
   <MPICXX> CC </MPICXX>
   <MPIFC> ftn </MPIFC>
   <PIO_FILESYSTEM_HINTS>lustre</PIO_FILESYSTEM_HINTS>
   <NETCDF_PATH>$ENV{NETCDF_PATH_KAUST}</NETCDF_PATH>

This errors out:

.. error::

   65:  PNETCDF not enabled in the build

.. code-block::

   --prefix        -> /opt/cray/pe/netcdf-hdf5parallel/4.6.3.2/INTEL/19.0
   --includedir    -> /opt/cray/pe/netcdf/4.6.3.2/include
   --libdir        -> /opt/cray/pe/netcdf-hdf5parallel/4.6.3.2/INTEL/19.0/lib

.. note::

   Typos in the CIME documentation:
   https://esmci.github.io/cime/versions/master/html/users_guide/porting-cime.html
   Should be ``cime/tools/load_balancing_tool`` -- no "s".

Trial 078
=========

Made these changes to ``DART_config``:

.. code-block::

   # ./xmlchange DATA_ASSIMILATION_ATM=TRUE
   # if ($?CIMEROOT) ./xmlchange DATA_ASSIMILATION_SCRIPT=${CASEROOT}/assimilate.csh

When we want to run assimilatte, we need to undo this change.

Changed ``PNETCDF_PATH_KAUST`` within ``config_machines.xml`` to:

.. code-block:: xml

   <env name="PNETCDF_PATH_KAUST">/opt/cray/pe/netcdf-hdf5parallel/4.6.3.2/INTEL/19.0</env>

Looking at the pio.bldlogs.

Working version
---------------

``/lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.075.e03/bld/pio.bldlog.201027-211925.gz``

In this working build, these lines are printed:

.. code-block::

   -- Found NetCDF_Fortran: /opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0/lib/libnetcdff.a
   -- Found PnetCDF_Fortran: /opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/lib/libpnetcdf.a

Non-working version
-------------------

``/lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.078.e03/bld/pio.bldlog.201104-002417``

In this non-working build, this is the final line before a build error:

.. code-block::

   Found NetCDF_Fortran: /opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0/lib/libnetcdff.a  
   -- Configuring incomplete, errors occurred!

Could the issue be that the library is not called ``libpnetcdf`` and instead is called
``libnetcdf_parallel`` but ``-lpnetcdf`` is hard-coded into the makefile?

Trial 077
=========

This is the same as Trial 075, we're just rebuilding to sidestep this `NetCDF
Issue <https://bb.cgd.ucar.edu/cesm/threads/cesm-defaults-to-using-netcdf-instead-of-pnetcdf.5674/#post-38106>`_.

.. code-block:: bash

   $ cd /lustre/project/k1421/cesm_store/inputdata/atm/cam/tracer_cnst/
   $ mv tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc old_tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc
   $ nccopy -k cdf5 old_tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc

Trial 076
=========

Setting ``config_compilers.xml``:

.. code-block:: xml

   <SLIBS>
   <append>-L$(NETCDF_PATH_KAUST)/lib -lnetcdff</append>
   </SLIBS>
   <!--<append>-L$(NETCDF_PATH_KAUST) -lnetcdff, -L$(PNETCDF_PATH_KAUST) -lpnetcdf</append>-->

Trial 075
=========

Comment out the append line in ``config_compilers.xml``:

.. code-block:: xml

   <!--<append>-L$(NETCDF_PATH_KAUST) -lnetcdff, -L$(PNETCDF_PATH_KAUST) -lpnetcdf</append>-->

.. code-block::

   223: MOSART decomp info proc =        95 begr =    192376 endr =    194400 numr =      2025
   srun: Job step aborted: Waiting up to 302 seconds for job step to finish.
   0: slurmstepd: error: *** STEP 16076077.0 ON nid01376 CANCELLED AT 2020-10-28T19:25:55 DUE TO TIME LIMIT ***
   srun: got SIGCONT

The second run completed the atmospheric portion.

This is the last printed statment in all three rof files is:

.. code-block::
   
   001
   hist_htapes_build Successfully initialized MOSART history files
   ------------------------------------------------------------
   (Rtmini)  done
   Snow capping will flow out in frozen river runoff
   002
   hist_htapes_build Successfully initialized MOSART history files
   ------------------------------------------------------------
   (Rtmini)  done
   Snow capping will flow out in frozen river runoff
   003
   hist_htapes_build Successfully initialized MOSART history files
   ------------------------------------------------------------
   (Rtmini)  done
   Snow capping will flow out in frozen river runoff

Rerunning Trial 075 to see if it hangs at the same spot. Started at 12:42.

Trial 074
=========

Setting ``config_compilers.xml``:

.. code-block:: xml

   <append>-L$(NETCDF_PATH_KAUST) -lnetcdff, -L$(PNETCDF_PATH_KAUST) -lpnetcdf</append>

Trial 073
=========

Setting ``config_compilers.xml``:

.. code-block:: xml
   
   -L$(NETCDF_DIR) -lnetcdff -Wl,--as-needed,-L$(NETCDF_DIR)/lib -lnetcdff -lnetcdf
   <append>-L$(NETCDF_PATH_KAUST) -lnetcdff -l, -L$(PNETCDF_PATH_KAUST) -lpnetcdf -l</append>

.. error::

   /usr/bin/ld: cannot find -l,

Trial 072
=========

Setting ``config_compilers.xml``:

.. code-block:: xml

   <append>-L$(NETCDF_PATH_KAUST)/lib -lnetcdff, -L$(PNETCDF_PATH_KAUST)/lib -lpnetcdf</append>

.. error::

   /usr/bin/ld: cannot find -lnetcdff

Trial 071
=========

Setting ``config_compilers.xml``:

.. code-block:: xml

   <append>-L$(NETCDF_PATH_KAUST)/lib -lnetcdff -lnetcdf, -L$(PNETCDF_PATH_KAUST)/lib -lpnetcdf</append>

..error::

   /usr/bin/ld: cannot find -lnetcdf,

Trial 070
=========

Setting ``config_compilers.xml``:

.. code-block:: xml

   <append>-L$(NETCDF_PATH_KAUST) -lnetcdff -Wl, -L$(PNETCDF_PATH_KAUST) -lpnetcdf -Wl</append>

This builds, but we still get an error.

.. error::

   1:   NetCDF: Attempt to use feature that was not turned on when netCDF was built.

Checking the cesm buildlog.

.. code-block::

   -lpnetcdf -Wl  -mkl=cluster  -L/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/lib -lpnetcdf   -mkl
   ifort: command line warning #10157: ignoring option '-W'; argument is of wrong type
   ifort: command line warning #10121: overriding '-mkl=cluster' with '-mkl'

Trial 069
=========

Since the compiler so the flag has to match the name of the shared object file
``-lpnetcdf`` should work but not ``-lpnetcdff``.

.. code-block::

   <SLIBS>
      <append> -I$(NETCDF_PATH_KAUST)/include, -I$(PNETCDF_PATH_KAUST)/include, -L$(NETCDF_PATH_KAUST)/lib -lnetcdff -lnetcdf, -L$(PNETCDF_PATH_KAUST)/lib -lpnetcdf</append>
   </SLIBS>

Trial 068
=========

Attempting the same configuration as in Trial 067, except comment out
``INC_PNETCDF`` and ``LIB_PNETCDF``. The cesm buildlog reads:

.. code-block::

   ifort: command line warning #10121: overriding '-mkl=cluster' with '-mkl'
   /usr/bin/ld: cannot find -lpnetcdff
   /usr/bin/ld: cannot find -lnetcdf,
   /usr/bin/ld: cannot find -lpnetcdff
  /usr/bin/sha1sum: /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.068.e03/bld/cesm.exe: No such file or directory

What are the names of the shared files?

.. code-block:: bash

   /opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0/lib♡ ls *so
   libbzip2_intel.so  libmisc_intel.so  libnetcdf_c++4_intel.so  libnetcdff_intel.so  libnetcdf_intel.so
   libbzip2.so        libmisc.so        libnetcdf_c++4.so        libnetcdff.so        libnetcdf.so

.. code-block:: bash

   /opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/lib♡ ls
   libpnetcdf.a        libpnetcdf_intel.so    libpnetcdf_intel.so.3.0.1  libpnetcdf.so.3      pkgconfig
   libpnetcdf_intel.a  libpnetcdf_intel.so.3  libpnetcdf.so              libpnetcdf.so.3.0.1

Trial 067
=========

Setting ``config_machines.xml``:

.. code-block:: xml

   <env name="PNETCDF_PATH_KAUST">/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0</env>
   <env name="INC_PNETCDF_KAUST">/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/include</env>
   <env name="LIB_PNETCDF_KAUST">/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/lib</env>
   <SLIBS>
      <append> -L$(NETCDF_PATH_KAUST) -lnetcdff -Wl, -L$(PNETCDF_PATH_KAUST) -lpnetcdff -Wl, --as-needed, -               L$(NETCDF_PATH_KAUST)/lib -lnetcdff -lnetcdf, -L$(PNETCDF_PATH_KAUST)/lib -plnetcdff -lpnetcdf</append>
   </SLIBS>
   <MPICC> cc </MPICC>
   <MPICXX> CC </MPICXX>
   <MPIFC> ftn </MPIFC>
   <PIO_FILESYSTEM_HINTS>lustre</PIO_FILESYSTEM_HINTS>
   <NETCDF_PATH>$ENV{NETCDF_PATH_KAUST}</NETCDF_PATH>
   <PNETCDF_PATH>$ENV{PNETCDF_PATH_KAUST}</PNETCDF_PATH>
   <INC_PNETCDF>$ENV{INC_PNETCDF_KAUST}</INC_PNETCDF>
   <LIB_PNETCDF>$ENV{LIB_PNETCDF_KAUST}</LIB_PNETCDF>

The ``PIO_CONFIG_ARGS`` sets the ``PNETCDF_PATH`` argument:

.. code-block:: xml

   <append> -L$(NETCDF_PATH_KAUST) -lnetcdff -Wl, -L$(PNETCDF_PATH_KAUST) -lpnetcdff -Wl, -L$(NETCDF_PATH_KAUST)/lib -lnetcdff -lnetcdf, -L$(PNETCDF_PATH_KAUST)/lib -lpnetcdff -lpnetcdf</append>

This errors out when running ``create_newcase``...

.. code-block::

   Schemas validity error : Element 'INC_PNETCDF': This element is not expected.

Trial 066
=========

This fails, too. What should we attempt next do?

.. code-block:: xml

   <append> -L$(NETCDF_DIR) -lnetcdff -Wl,-L$(PNETCDF_DIR)/lib -lpnetcdff -lpnetcdf,--as-needed,-L$(NETCDF_DIR)/lib -  lnetcdff -lnetcdf</append>

I guess the next thing to try is to toggle through differnt compiler flags. It 
might be faster to iterate by building DART rather than building CESM.

What does the the ``--as-needed`` flag accomplish?

Trial 065
=========

Adding back in the link to ``-lpnecdff`` in ``config_compilers.xml``:

.. code-block:: xml

   <SLIBS>
      <append> -L$(NETCDF_PATH) -lnetcdff -Wl, --as-needed, -L$(PNETCDF_PATH)/lib -lpnetcdff</append>
   </SLIBS>

This fails to build. Remember:

- The NETCDF_PATH has a library: ``/opt/cray/pe/netcdf/4.6.3.2/INTEL/19.0/lib``
- The PNETCDF_PATH also has a library: ``/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0/lib``

What to do next? I think the issue is it's linking netcdf rather than pnetcdf.

Spitballing ideas --
#################################################
1. The directory we're linking to is wrong. 
There's an L directory and an I directory, right?
#################################################
-L goes to the lib directory
-I goes to the include directory

Trial 064
=========

Removed this from ``config_compilers.xml``:

.. code-block:: xml

   <SLIBS>
   <append> -L$(NETCDF_PATH) -lnetcdff -Wl, --as-needed, -L$(NETCDF_PATH)/lib -lnetcdff,  -L$(PNETCDF_PATH)/     lib -lnetcdff</append>
   </SLIBS>

.. error::

   .. code-block::
   
      1:  pio_support::pio_die:: myrank=          -1 : ERROR: ionf_mod.F90:         235 :
      1:   NetCDF: Attempt to use feature that was not turned on when netCDF was built.

Trial 063
=========

How do we tell CESM to trigger which MPI library to use?
MPI Libs
http://www.cesm.ucar.edu/models/cesm1.2/cesm/doc_cesm1_2_1/modelnl/machines.html
!mpi-serial
/lustre/project/k1421/cases/FHIST_BGC.f09_d025.062.e03♡ ./xmlquery MPILIB
MPILIB: mpt
https://bb.cgd.ucar.edu/cesm/threads/viability-of-running-cesm-on-40-cores.4997/page-2#post-37159
You should build and install netcdf and pnetcdf separately and link both.
Tried to building with this one:
<appe:q
nd> -L$(NETCDF_PATH) -lnetcdff -Wl, --as-needed, -L$(NETCDF_PATH)/lib -lnetcdff,  -L$(PNETCDF_PATH)/lib -      lnetcdff</append>

Trial 062
=========

If that doesn't work, try linking to ``PNETCDF`` path in this line of
``config_compilers.xml``:

.. code-block:: xml

   <append> -L$(NETCDF_PATH) -lnetcdff -Wl, --as-needed, -L$(NETCDF_PATH)/lib -lnetcdff</append>

Okay that fixes the ``PNETCDF not enabled in the build`` issue.

Although now we have a different error.

.. error::

   .. code-block::

      1:  pio_support::pio_die:: myrank=          -1 : ERROR: ionf_mod.F90:         235 :
      1:   NetCDF: Attempt to use feature that was not turned on when netCDF was built.

.. code-block:: bash

   $ nc-config --all
   ...
   --has-pnetcdf   -> no
   ...

You have to define an environmental variable that contains the path to the
``PNETCDF`` library in ``config_machines.xml``.

And then reference that environmental variable when assinging a value to the
``PNETCDF_PATH`` key in ``config_compilers.xml`` but I actually don't
understand how the linker is made aware of that value, because the linker is
only given the serial netcdf path.

Trial 061
=========

I'm not sure why we're getting this error.

When trying to set:

.. code-block:: bash

   $ ./xmlchange PIO_TYPENAME=pnetcdf
   Did not find pnetcdf in valid values for PIO_TYPENAME: ['netcdf']

Examining ``config_pio.xml`` but I'm not sure how to interpret the results.

.. code-block:: bash

   $ vim /lustre/project/k1421/cesm2_1_3/cime/config/cesm/machines/config_pio.xml

In ``config_compilers.xml``:

.. code-block:: xml

   <PNETCDF_PATH>$ENV{PARALLEL_NETCDF_DIR}</PNETCDF_PATH>

The error is from Line 238 of ``${CIMEROOT}/scripts/lib/CIME/XML/entry_id.py``
in the function:

.. code-block:: python

   get_valid_value_string in "Did not find {} in valid values for {}: {}"

What does the entry for CNL look like?

.. code-block:: xml

   <compiler OS="CNL">
      <CMAKE_OPTS>
         <base> -DCMAKE_SYSTEM_NAME=Catamount</base>
      </CMAKE_OPTS>
      <CPPDEFS>
         <append> -DLINUX </append>
         <append MODEL="gptl"> -DHAVE_NANOTIME -DBIT64 -DHAVE_VPRINTF -DHAVE_BACKTRACE -DHAVE_SLASHPROC -DHAVE_COMM_F2C -    DHAVE_TIMES -DHAVE_GETTIMEOFDAY  </append>
      </CPPDEFS>
      <MPICC> cc </MPICC>
      <MPICXX> CC </MPICXX>
      <MPIFC> ftn </MPIFC>
      <NETCDF_PATH>$ENV{NETCDF_DIR}</NETCDF_PATH>
      <PIO_FILESYSTEM_HINTS>lustre</PIO_FILESYSTEM_HINTS>
      <PNETCDF_PATH>$ENV{PARALLEL_NETCDF_DIR}</PNETCDF_PATH>
      <SCC> cc </SCC>
      <SCXX> CC </SCXX>
      <SFC> ftn </SFC>
   </compiler>

Edited the shaheen entry in ``config_compilers.xml``:

.. code-block:: xml

   <PIO_FILESYSTEM_HINTS>lustre</PIO_FILESYSTEM_HINTS>
   <PNETCDF_PATH>$ENV{PNETCDF_PATH}</PNETCDF_PATH>
   <SCC> cc </SCC>

And added this to ``config_machines.xml``:

.. code-block:: xml

   <env name="PNETCDF_PATH">/opt/cray/pe/parallel-netcdf/1.11.1.1/INTEL/19.0</env>

Trial 060
=========

Using ``/Users/johnsonb/scratch/cheyenne/buildnml`` which is the same as the
reanalysis, except it has had these lines inserted from cesm2_1_3:

.. code-block:: python

   docn_mode = case.get_value("DOCN_MODE")
   if docn_mode and 'aqua' in docn_mode:
       config['aqua_planet_sst_type'] = docn_mode
   else:
       config['aqua_planet_sst_type'] = 'none'

This crashes, with a warning.

.. warning::

   PNETCDF not enabled in the build.
   
Is this warning present in Trial 059 as well?

.. code-block:: bash

   $ vim /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.059.e80/run/cesm.log.15958125.201019-232044.gz
   Pattern not found: PNETCDF not enabled in the build

According to this `DiscussCESM post <https://bb.cgd.ucar.edu/cesm/threads/using-pnetcdf-for-cesm.3084/>`,
the message indicates that PNETCDF was not linked with the application.

Trial 059
=========

Keeping ``OMP_STACKSIZE`` and using the old buildnml script.

..code-block::

   <env name="OMP_STACKSIZE">256M</env>

This runs properly.

Trial 058
=========

Changing ``OMP_STACKSIZE``.

..code-block::

   <env name="OMP_STACKSIZE">256M</env>

Also using Kevin Raeder's ``buildnml`` script modification.

Trial 057
=========

Changing ``OMP_STACKSIZE``.

..code-block::

   <env name="OMP_STACKSIZE">1024M</env>

Doesn't seem to affect performance.

Trial 056
=========

Changing ``OMP_STACKSIZE``.

..code-block::

   <env name="OMP_STACKSIZE">128M</env>

Doesn't seem to affect performance.

Trial 055
=========

This run timed out with a super user message:

.. error::

   run.FHIST_BGC.f09_d025.055.e80 Ended, Run time 01:00:26


It also sat in the queue for a really long time so maybe there is traffic on 
the interconnects.

Trial 054
=========

Toggling settings in ``config-machines.xml``:

.. code-block:: xml

   <env name="MPI_COMM_MAX">16383</env>
   <env name="MPI_GROUP_MAX">1024</env>

Trial 049
=========

Added echo statements to ``assimilate.csh``.

To see what a bash script to submit a SLURM job looks like:

.. code-block:: bash

   vim /lustre/project/k1421/scripts_logs/run_check_input_data_SMS_Lm13.f10_f10_musgs.I1850Clm50SpG.shaheen_intel.20200612_215255_kuwhyp

.. code-block:: bash

   #!/bin/bash
   #
   #SBATCH --job-name=run_check_input_data_SMS_Lm13.f10_f10_musgs.I1850Clm50SpG.shaheen_intel.20200612_215255_kuwhyp
   #SBATCH --output=run_check_input_data_SMS_Lm13.f10_f10_musgs.I1850Clm50SpG.shaheen_intel.20200612_215255_kuwhyp.txt
   #SBATCH --partition=workq
   #SBATCH --ntasks=1
   #SBATCH --time=23:59:00
   #SBATCH --mem-per-cpu=100
   python run_check_input_data.py SMS_Lm13.f10_f10_musgs.I1850Clm50SpG.shaheen_intel.20200612_215255_kuwhyp

Examining ``assimilate.csh``, it's crashing when trying to execute this line:

.. code-block::

   setenv   NODENAMES $SLURM_NODELIST
   nid00[136-147]: No match.

Cross-referencing this with the da.log and the assimilate script:

.. code-block::

   vim /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.049.e3/run/da.log.15905662.201015-053628
   vim /lustre/project/k1421/DART/models/cam-fv/shell_scripts/cesm2_1/assimilate.csh.template 

.. code-block::

   inf_flavor(1) = 2, using namelist values.
   [  Thu Oct 15 18:38:59 2020] [c0-0c0s9n0] Fatal error in MPI_Init: Other MPI error, error stack:
   MPIR_Init_thread(537):
   MPID_Init(246).......: channel initialization failed
   cray-netcdf/4.6.3.2(9):ERROR:150: Module 'cray-netcdf/4.6.3.2' conflicts with the currently loaded module(s) 'cray-netcdf-hdf5parallel/4.6.3.2'
   ncks: Command not found
   Can't load parallel netcdf and nco at the same time.
   MPI_COMM_MAX=16383

Trial 048
=========

After differencing the SourceMod of ``dyn_comp.F90`` we're using and the one in
cesm2_1_3, it might be worth trying to see if swapping out the SourceMod gets 
us to a different point in the compiling before crashing.

Removing ``lustre/project/k1421/SourceMods/cesm2_1_3/SourceMods/src.cam/dyn_comp.F90``.

This works! The run doesn't complete, since ``assimilate.csh`` crashes, but 
this is clear progress. Now what the error log is printing:

.. code-block:

   nid00[136-147]: No match.
   nid00[136-147]: No match.

Trial 047
=========

.. note::

   This is an important debugging trial because we fixed the PE issue in Trial
   46 and can move onto determining why the build mysteriously hangs without
   producing any meaningful error messages.

We focus on determining which task happens right after ``GSMap indices not
increasing``. Change the debug settings, with ``./xmlchange DEBUG=TRUE`` and 
``./xmlchange INFO_DBUG=1``.

Last working startup case
-------------------------

The last working startup -- not hybrid case is Trial 018:

``/lustre/project/k1421/cases/FHIST_BGC.f09_d025.018.e3``

Its buildlog continues past ``GSMap indices not increasing``:

.. code-block::

   MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   0: calcsize j,iq,jac, lsfrm,lstoo  1  1  1  26  21
   Opened file FHIST_BGC.f09_d025.018.e3.cam_0001.r.1979-01-01-21600.nc to write

Attempting to clone Kevin's CAM Reanalysis on Cheyenne
------------------------------------------------------

.. error::

   CAM Could not be built
   cat /glade/scratch/johnsonb/FHIST_BGC.f09_d025.001.e3/bld/atm.bldlog.201012-214748

Attempting to clone Kevin's CAM Reanalysis on Shaheen
------------------------------------------------------

Working on: ``/glade/work/johnsonb/DART_Shaheen/models/cam-fv/shell_scripts/cesm2_1/setup_advanced_Rean``
Stage directory: ``/glade/scratch/johnsonb/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest/2019-08-05-00000``

.. code-block:: bash

   gunzip f.e21.FHIST_BGC.f09_025.CAM6assim.011.cam_00[45678]?.r.2019-08-05-00000.nc.gz

Rebuilding with cesm2.1.resl5.6 instead of cesm2_1_3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Two candidate source files:

1. ``./components/cam/src/chemistry/modal_aero/modal_aero_gasaerexch.F90``
2. ``./components/cam/src/chemistry/utils/modal_aero_calcsize.F90``

This is the code that prints the relevant statement in the buildlog:

.. code-block:: fortran

   1016      write( 6, '(a,3i3,2i4)' ) 'calcsize j,iq,jac, lsfrm,lstoo',   &
   1017      j,iq,jac, lsfrm,lstoo

This file never gets called: ``./components/cam/src/chemistry/utils/modal_aero_calcsize.F90``

Thus it's actually hanging in: ``./components/cam/src/dynamics/fv/cd_core.F90``

We can attempt a case with a different resolution: ``FHIST_BGC.f19_f19_mg17.001.e3``.

However, using the build scripts don't work because there isn't a way to get the
SST flux properly into the coupler.

.. code-block:: bash

   source activate py27
   cd /lustre/project/k1421/cesm2_1_3/cime/scripts
   ./create_newcase --case /lustre/project/k1421/cases/FHIST_BGC.f19_f19_mg17.002.e3 --machine shaheen --res f19_f19_mg17 --project k1421 --queue workq --walltime 1:00:00 --pecount 32x1 --ninst 3 --compset HIST_CAM60_CLM50%BGC-CROP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV --multi-driver --run-unsupported
   cd /lustre/project/k1421/cases/FHIST_BGC.f19_f19_mg17.002.e3
   ./case.setup
   ./case.build
   cd /lustre/project/k1421/cases/FHIST_BGC.f19_f19_mg17.002.e3
   ./case.submit -M begin,end

This gives us a "working" start up run with a f19_f19_mg17 grid. It's useful
because it provides two clues: where the cesm.log.* fails and where the
atm_00??.log.* fails.

Examining the CESM Log
~~~~~~~~~~~~~~~~~~~~~~

In a job submission that runs to completion, the CESM log continues past the 
``GSMap indices not increasing...Will correct`` line:

.. code-block::

   /lustre/scratch/x_johnsobk/archive/FHIST_BGC.f19_f19_mg17.002.e3/logs/cesm.log.15883098.201014-065036.gz
   transitions from the MCT::m_Router to the calcsize printouts immediately after it.
   3226  0: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   3227  0: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
   3228  0: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
   3229  0: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   3230 64: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   3231 64: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
   3232 64: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
   3233 64: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   3234 32: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   3235 32: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
   3236 32: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
   3237 32: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   3238  0: calcsize j,iq,jac, lsfrm,lstoo  1  1  1  26  21
   3239  0: calcsize j,iq,jac, lsfrm,lstoo  1  1  2  26  21
   3240  0: calcsize j,iq,jac, lsfrm,lstoo  1  2  1  22  15
   3241  0: calcsize j,iq,jac, lsfrm,lstoo  1  2  2  22  15
   3242  0: calcsize j,iq,jac, lsfrm,lstoo  1  3  1  24  17

The ``MCT::m_router`` lines are printed from the subroutine ``initp__(inGSMap,inRGSMap,mycomm,Rout,name )``
in ``m_Router.F90``:

.. code-block:: fortran

   336     if(myPid == 0) call warn(myname_,'GSMap indices not increasing...Will correct')
   337     call GlobalSegMap_OPoints(inGSMap,myPid,gpoints)

Note well, in ``mct_mod.F90``, ``m_router`` undergoes association renaming:

.. code-block:: fortran

   use m_Router             ,only: mct_router             => Router

Additionally, the ``calcsize`` lines are from ``modal_aero_calcize.F90``:

.. code-block:: fortran

   1016    write( 6, '(a,3i3,2i4)' ) 'calcsize j,iq,jac, lsfrm,lstoo',   &
   1017    j,iq,jac, lsfrm,lstoo

Thus the log from a non-working run, ``/lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.047.e3/run/atm_0001.log.15874648.201013-170022``,
ends here:

.. code-block:: fortran

   4619  FV subcycling - nv, n2, nsplit, dt =            2           1           4
   4620    225.000000000000

Line 4620 is printed from ``./components/cam/src/dynamics/fv/dyn_comp.F90``:

.. code-block:: fortran

   1443          write(iulog,*) 'FV subcycling - nv, n2, nsplit, dt = ', nv, n2, nsplit, dt

The working log, ``/lustre/scratch/x_johnsobk/archive/FHIST_BGC.f19_f19_mg17.002.e3/logs/atm_0001.log.15883098.201014-065036.gz``,
continues:

.. code-block::

   4993  FV subcycling - nv, n2, nsplit, dt =            1           1           4
   4994    450.000000000000
   4995  Divergence damping: use 4th order damping

Line 4995 is printed from ``./components/cam/src/dynamics/fv/cd_core.F90``:

.. code-block:: fortran

   545 if (masterproc) write(iulog,*) 'Divergence damping: use 4th order damping'

So the key is to determine what happens in between Line 1443 of ``dyn_comp.F90``
and the invocation of ``cd_core`` which is called only once on lone 1862:

.. code-block:: fortran

   1862                call cd_core(grid,   nx,     u,   v,   pt,

Trial 046
=========

Edited ``config_machines.xml`` to:

.. code-block:: xml

   <!-- <MAX_TASKS_PER_NODE>64</MAX_TASKS_PER_NODE> -->
   <MAX_TASKS_PER_NODE>32</MAX_TASKS_PER_NODE>

.. important::

   This fixes the PE crash and we now hang at a different point.

Trial 045
=========

Forgot to build Trial 044 with ``OMP_STACKSIZE=256MB``.

Edited ``config_machines.xml`` to set ``OMP_STACKSIZE=256MB``. Rebuilt the case.

Trial 044
=========

``./xmlchange ROOTPE_ESP=0,NTHRDS_ESP=$nthreads,NTASKS_ESP=1``

Trial 043
=========

``./xmlchange NTASKS_PER_INST_ESP=1``

For some reason that still results in:

``NTASKS_PER_INST: ['ATM:128', 'LND:128', 'ICE:128', 'OCN:128', 'ROF:128', 'GLC:128', 'WAV:128', 'ESP:32']``

Trial 042
=========

``./xmlchange OMP_STACKSIZE=128MB``

Trial 041
=========
Attempting to change the stack limit to see if it noticeably affects performance.

``./xmlchange OMP_STACKSIZE=1024MB``

Trial 040
=========

.. code-block:: bash

    128:  Reading zbgc_nml
      0: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
      0: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
      0: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
      0: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
    128: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
    256: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
    128: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
    256: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
    256: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
    128: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
    256: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
    128: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
    361: forrtl: severe (174): SIGSEGV, segmentation fault occurred
    128: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
    256: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
   9583 srun: error: nid04049: tasks 37-38,40-42,44,48,50-51,54-55,57,61-63: Exited with exit code 174
   9584 srun: Terminating job step 15810768.0
   9585   0: slurmstepd: error: *** STEP 15810768.0 ON nid04048 CANCELLED AT 2020-10-08T21:09:34 ***

Trial 039
=========

Seems like we should just try this attempt again in case the error was caused
by running 3 the script times simultaneously.

Trial 038
=========

Changing ``set do_clm_interp = "true"``.

This works! However we should go through the CESM logs to see if it's hanging
anywhere.

Trial 037
=========

Omitted ``modules.csh``.

Questions:

1. ``PIO_TYPENAME = 'pnetcdf'``; Do we need to change it to netcdf?
2. ``set do_clm_interp = "false"``; Do we need to change it to true?

Another issue:

.. code-block:: bash

   /usr/bin/cp: option '--v' is ambiguous; possibilities: '--verbose' '--version'
   Try '/usr/bin/cp --help' for more information.

Edited ``DART_config`` to omit update_dart_namelists.

Also copied a file from GLADE:

.. code-block:: bash

   Fetching /glade/p/cesmdata/cseg/inputdata/atm/cam/tracer_cnst/tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc to tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc
   lustre/project/k1421/cesm_store/inputdata/atm/cam/tracer_cnst

This gives us an error.

.. error::

  .. code-block:: bash
  
     Did you mean to set use_init_interp = .true. in user_nl_clm?
     94: (Setting use_init_interp = .true. is needed when doing a
     94: transient run using an initial conditions file from a non-transient run,
     94: or a non-transient run using an initial conditions file from a transient run,
     94: or when running a resolution or configuration that differs from the initial conditions.

Trial 036
=========

Changed ``NTASKS`` for ``ESP=1`` and set ``PIO_TYPENAME=netcdf``

But we still have the same SIGTERM failure. GRRR.

At least it's good to report that the Invalid PIO rearranger issue even occurs
in a working run:

.. code-block:: bash

   $ vim /lustre/scratch/x_johnsobk/archive/FHIST_BGC.f09_g17.002.e3/logs/cesm.log.15594937.200910-181624.gz
   0:  Invalid PIO rearranger comm max pend req (comp2io),            0
   0:  Resetting PIO rearranger comm max pend req (comp2io) to           64
   0:  PIO rearranger options:
   0:    comm type     =

Working on contrasting these two runs, since one works and the other doesn't

.. code-block:: bash

   $ cd /lustre/project/k1421/cases/FHIST_BGC.f09_g17.002.e3
   $ ./xmlquery --partial PE
   RUN_TYPE: startup
   $ cd /lustre/project/k1421/cases/FHIST_BGC.f09_d025.036.e3
   $ ./xmlquery --partial PE
   RUN_TYPE: hybrid

The output of these are identical except for ``RUN_TYPE``.

There are two plausible paths:

1. Go through Kevin's script here: ``/lustre/project/k1421/DART_CASES/setup_advanced_Rean.original``
and see if we're missing anything significant. It seems like the stagedir is
just the full path wehre the restart files are. I think that might be it.

In line 1295 of ``setup_advanced_Rean.original``

.. code-block:: bash

   1295 ${LINK} -f ${stagedir}/${refcase}.clm2\${inst_string}.r.${init_time}.nc  .
   ./xmlchange RUN_REFDIR=$stagedir

2. Or get Kevin's setup script working, which might actually only entail
changing the user_nl text. This might actually be pretty fast.

.. code-block:: bash

   360 set user_grid = "${user_grid} --gridfile /glade/work/raeder/Models/CAM_init/SST"
   361 set user_grid = "${user_grid}/config_grids+fv1+2deg_oi0.25_gland20.xml"
   362 setenv sst_dataset \
   363    "/glade/work/raeder/Models/CAM_init/SST/avhrr-only-v2.20110101_cat_20111231_gregorian_c190703.nc"

We should only need to change these, right?

.. code-block:: bash

   340 set use_tasks_per_node = 36
   ...
   959       set cesm_data_dir = "/glade/p/cesmdata/cseg/inputdata/atm"
   960       set cesm_chem_dir = "/gpfs/fs1/p/acom/acom-climate/cmip6inputs/emissions_ssp119"
   961       set chem_root     = "${cesm_chem_dir}/emissions-cmip6-ScenarioMIP_IAMC-IMAGE-ssp119-1-1"
   962       set chem_dates    = "175001-210012_0.9x1.25_c20181024"

Trial 035
=========

Set ``tasks_per_node=16`` but we still get the segmentation fault. So this might
be a PE layout issue. We should really be trying to track down what the correct
layout was for the last working ensemble.

.. warning::

   .. code-block:: bash
   
      Warning: missing non-idmap ROF2OCN_LIQ_RMAPNAME for ocn_grid, d.25x.25 and rof_grid r05 
      Warning: missing non-idmap ROF2OCN_ICE_RMAPNAME for ocn_grid, d.25x.25 and rof_grid r05

Looking back to ``/lustre/project/k1421/cases/FHIST_BGC.f09_g17.002.e3`` we see:

.. code-block:: bash

   NTASKS_PER_INST: ['ATM:128', 'LND:128', 'ICE:128', 'OCN:128', 'ROF:128', 'GLC:128', 'WAV:128', 'ESP:1']
   ROOTPE: ['CPL:0', 'ATM:0', 'LND:0', 'ICE:0', 'OCN:0', 'ROF:0', 'GLC:0', 'WAV:0', 'ESP:0']

   Results in group mach_pes_last
	   COSTPES_PER_NODE: 32
	   COST_PES: 384
	   MAX_MPITASKS_PER_NODE: 32
	   MAX_TASKS_PER_NODE: 64
	   TOTALPES: 384

I checked to see run_domain is the same in the working case and the non-working
case.

.. code-block:: bash

   Results in group run_domain
   	ATM2LND_FMAPTYPE: X
   	ATM2LND_SMAPTYPE: X
   	ATM2OCN_FMAPTYPE: X
   	ATM2OCN_SMAPTYPE: X
   	ATM2OCN_VMAPTYPE: X
   	ATM2WAV_SMAPTYPE: Y
   	GLC2ICE_RMAPTYPE: Y
   	GLC2LND_FMAPTYPE: Y
   	GLC2LND_SMAPTYPE: Y
   	GLC2OCN_ICE_RMAPTYPE: Y
   	GLC2OCN_LIQ_RMAPTYPE: Y
   	ICE2WAV_SMAPTYPE: Y
   	LND2ATM_FMAPTYPE: Y
   	LND2ATM_SMAPTYPE: Y
   	LND2GLC_FMAPTYPE: X
   	LND2GLC_SMAPTYPE: X
   	LND2ROF_FMAPTYPE: X
   	OCN2ATM_FMAPTYPE: Y
   	OCN2ATM_SMAPTYPE: Y
   	OCN2WAV_SMAPTYPE: Y
   	ROF2LND_FMAPTYPE: Y
   	ROF2OCN_FMAPTYPE: Y
   	ROF2OCN_ICE_RMAPTYPE: Y
   	ROF2OCN_LIQ_RMAPTYPE: Y
   	WAV2OCN_SMAPTYPE: X
   
   Results in group mach_pes
	   NTASKS_PER_INST: ['ATM:128', 'LND:128', 'ICE:128', 'OCN:128', 'ROF:128', 'GLC:128', 'WAV:128', 'ESP:1']
	   ROOTPE: ['CPL:0', 'ATM:0', 'LND:0', 'ICE:0', 'OCN:0', 'ROF:0', 'GLC:0', 'WAV:0', 'ESP:0']

   Results in group mach_pes_last
	   COSTPES_PER_NODE: 32
	   COST_PES: 384
	   MAX_MPITASKS_PER_NODE: 32
	   MAX_TASKS_PER_NODE: 64
	   TOTALPES: 384

   PIO_NETCDF_FORMAT: ['CPL:64bit_offset', 'ATM:64bit_offset', 'LND:64bit_offset', 'ICE:64bit_offset', 'OCN:64bit_offset', 'ROF:64bit_offset', 'GLC:64bit_offset', 'WAV:64bit_offset', 'ESP:64bit_offset']

Trial 034
=========

In Trial 034 we don't get the problem encountered in Trial 031 after changing
``PIO_TYPENAME`` to netcdf. However, we still get an error.

.. error::

   .. code-block::

      96: MCT::m_Router::initp_: RGSMap indices not increasing...Will correct
      96: MCT::m_Router::initp_: GSMap indices not increasing...Will correct
      52: forrtl: severe (174): SIGSEGV, segmentation fault occurred

Trial 033
=========

We should build Trial 033 with as a ``hybrid`` run and comment out
``PIO_TYPENAME``.

.. code-block:: bash

   $ cd /lustre/project/k1421/cases/FHIST_BGC.f09_d025.033.e3/
   $ cp /lustre/project/k1421/DART/models/cam-fv/shell_scripts/cesm2_1/assimilate.csh.template assimilate.csh
   $ ./xmlchange DATA_ASSIMILATION_SCRIPT=./assimilate.csh
   $ ./case.submit -M begin,end

The two candidate settings for toggling are ``RUN_TYPE`` AND ``PIO_TYPENAME``.

Check the PIO buildlog for Trials 33 and 32.

.. code-block:: bash

   Building pio with output to file /lustre/scratch/x_johnsobk/FHIST_BGC.f09_d025.033.e3/bld/pio.bldlog.201007-210614

.. error:

   The build fails at a similar part to the CICE initial condition issue
   (around 7 minutes in) but for a different reason (segmentation fault) with
   an error about PIO_NETCDF.

   .. code-block:: bash

      /lustre/project/k1421/cesm2_1_3/cime/scripts/Tools/../../scripts/lib/CIME/case/case.py

Here's what the config_machines.xml modules look like:

.. code-block:: xml

   <modules mpilib="mpi-serial">
       <command name="load">cray-hdf5/1.10.5.2</command>
       <command name="load">cray-netcdf/4.6.3.2</command>
   </modules>
       <modules mpilib="!mpi-serial">
       <command name="load">cray-netcdf-hdf5parallel/4.6.3.2</command>
       <command name="load">cray-hdf5-parallel/1.10.5.2</command>
       <command name="load">cray-parallel-netcdf/1.11.1.1</command>
   </modules>

Maybe we shouldn't use the restart files for ice_ic?


Trial 032
=========

Attempting to use a continue run instead of a hybrid run.

.. error::

   .. code-block:: bash
   
      Did not find continue in valid values for RUN_TYPE: ['startup', 'hybrid', 'branch']
      RUN_TYPE = 'continue'

Aha, ``continue`` was permitted in CESM1 but isn't permitted anymore, so this
doesn't work. 

We can try a startup run next. Alternatively it could be a ``PIO_TYPENAME`` issue?




Trial 031
=========

Attempted to only change ``NTASKS_PER_INST_ATM``.

Okay this is progress as it results in an error.

.. error::

   .. code-block:: bash
   
      130:  aborting in ice-pio_ropen with invalid file
      130:  ERROR: aborting in ice-pio_ropen with invalid file

Is the abort trap signal related to `this post <https://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg14310.html>`_?

In user_nl_cice, and the variable is "ice_ic". In Kevin's directory, 
``/glade/work/raeder/Exp/f.e21.FHIST_BGC.f09_025.CAM6assim.011``, it is set as
``ice_ic = 'Rean_spinup_2010.cice_0001.r.2011-01-01-00000.nc'``

Hmm...are these files different resolution? Do they need to be both on the
atmospheric grid, and not the oceanic grid?

This could be a number of different things:

1. The initial condition specified incorrectly? Or is the grid specified incorrectly?
2. What if we just omit ice_ic and see what happens.

This wasn't a problem before because we were doing a startup run instead of a 
hybrid run.

Trial 030
=========

Setting: ``use_tasks_per_node = 16``

Which results in this result for our case on Shaheen.

.. code-block:: bash

   $ cd ${CASEROOT}
   $ ./xmlquery NTASKS
   NTASKS: ['CPL:108', 'ATM:108', 'LND:108', 'ICE:108', 'OCN:108', 'ROF:108', 'GLC:108', 'WAV:108', 'ESP:36']

Comparing it to Kevin's configuration for the reanlysis on Cheyenne.

.. code-block:: bash

   $ cd /glade/work/raeder/Exp/f.e21.FHIST_BGC.f09_025.CAM6assim.011
   $ ./xmlquery NTASKS_PER_INST
   NTASKS_PER_INST: ['ATM:108', 'LND:108', 'ICE:108', 'OCN:108', 'ROF:108', 'GLC:108', 'WAV:108', 'ESP:36']

So this seems to be the key thing we're missing.

Trial 029
=========

Trying different nodes per instance: ``tasks_per_node = 32`` and ``nodes_per_instance = 4``

.. code-block::

   cd /lustre/project/k1421/cases/FHIST_BGC.f09_d025.031.e3/
   cp /lustre/project/k1421/DART/models/cam-fv/shell_scripts/cesm2_1/assimilate.csh.template assimilate.csh
   ./xmlchange DATA_ASSIMILATION_SCRIPT=/lustre/project/k1421/cases/FHIST_BGC.f09_d025.031.e3/assimilate.csh
   ./case.submit -M begin,end
