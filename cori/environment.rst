####
Cori
####

Cori is a supercomputer supported by the US Department of Energy (DOE). Like 
Shaheen, Cori is also a Cray XC40. Unlike Shaheen, since NCAR and DOE partner
for Earth System Model Computational Infrastructure, CESM is well-tested and
supported on Cori.

Thus DAReS staff use Cori as a "trusted machine" to provide configuration and
benchmarking hints for the CESM port on Shaheen.

Login instructions
==================

Multi-factor authentication
---------------------------

Cori uses multi-factor authetication (MFA) which can be configured by logging
onto `Iris <https://iris.nersc.gov>`_ and clicking on the MFA tab in the 
navigation menu.

SSH
---

Cori is accessed via SSH:

.. code-block::

   ssh <username>@cori.nersc.gov

Ben's username is ``johnsonb``.

File system
===========

The `NERSC file system <https://docs.nersc.gov/filesystems/>`_ has:

- ``home``: a global storage system that is mounted everywhere.
  
  .. code-block::
  
     echo $HOME
     /global/homes/j/johnsonb

- ``scratch``: a lustre file system for temporary, high-performance storage.
  
  .. code-block::

     echo $scratch
     /global/cscratch1/sd/johnsonb

- ``common``: a high performance platform for installing software and compiling
  code. On compute nodes, common is read-only.

- ``community``: Large, permanent, medium-performance file system for sharing 
  project files. For the DAReS project, this directory is
  ``project/projectdirs/m3857``.

- ``archive (HPSS)``: A high capacity tape archive intended for long term
  storage of inactive and important data

Project
-------

The DAReS project on Cori is ``m3857``. The project usage can be found by
typing ``cmnquota <proj_name>``.

.. code-block::

   cmnquota m3857
   -------- Space (GB) ------- ------ Inode --------
   Project Usage Quota Percent Usage Quota   Percent
   ------- ----- ----- ------- ----- ------- -------
   m3857       0    10       0     1 1000000       0

CESM
====

The CESM build requires an XML libary to be installed.

.. error::

   .. code-block::

      ERROR: Command /global/project/projectdirs/m3857/cesm2_1_3/components/clm/bld/build-namelist failed rc=2
      out=
      err=Can't locate XML/LibXML.pm in @INC (you may need to install the XML::LibXML module)

You need to install this library via cpan:

.. code-block::

   cpan XML::LibXML
   Result: PASS
   SHLOMIF/XML-LibXML-2.0207.tar.gz
   Tests succeeded but one dependency not OK (Alien::Libxml2)
   SHLOMIF/XML-LibXML-2.0207.tar.gz
   [dependencies] -- NA

Edit config_machines.xml
------------------------

Certain libraries have changed and must be updated in order to get CESM to run.

.. code-block::

   vim /project/projectdirs/m3857/cesm2_1_3/cime/config/cesm/machines/config_machines.xml 

Update the following libraries:

+----------------------------------+----------------------------------+
| Old                              | New                              |
+==================================+==================================+
| cray-mpich/7.7.8                 | cray-mpich/7.7.10                |
+----------------------------------+----------------------------------+
| cray-netcdf-hdf5parallel/4.6.3.0 | cray-netcdf-hdf5parallel/4.6.3.2 |
+----------------------------------+----------------------------------+
| cray-hdf5-parallel/1.10.5.0      | cray-hdf5-parallel/1.10.5.2      |
+----------------------------------+----------------------------------+
| cray-parallel-netcdf/1.11.1.0    | cray-parallel-netcdf/1.11.1.1    |
+----------------------------------+----------------------------------+

Installation
------------

CESM is installed on Cori in the project's community directory.

.. code-block::

   cd /project/projectdirs/m3857
   git clone https://github.com/escomp/cesm.git cesm2_1_3
   cd cesm2_1_3
   git checkout cesm2.1.3
   ./manage_externals/checkout_externals
   cd cime/scripts
   ./create_newcase --case /project/projectdirs/m3857/cases/FHIST_BGC.f19_f19_mg17.001.e3 --machine cori-haswell --res f19_f19_mg17 --project m3857 --walltime 1:00:00 --ninst 3 --compset HIST_CAM60_CLM50%BGC-CROP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV --multi-driver --run-unsupported
   cd /project/projectdirs/m3857/cases/FHIST_BGC.f19_f19_mg17.001.e3
   ./case.setup
   ./case.build

Error with LibXml.pm

.. error::

   .. code-block::

      ERROR: Command /global/project/projectdirs/m3857/cesm2_2_0/components/clm/bld/build-namelist failed rc=2
      out=
      err=Can't locate XML/LibXML.pm in @INC (you may need to install the XML::LibXML module) (@INC contains: /global/project/projectdirs/m3857/cesm2_2_0/components/clm/bld /global/project/projectdirs/m3857/cesm2_2_0/components/clm/bld /global/project/projectdirs/m3857/cesm2_2_0/cime/scripts/Tools/../../utils/perl5lib /global/project/projectdirs/m3857/cesm2_2_0/components/clm/bld /usr/common/software/darshan/perl-packages/perl-Pod-LaTeX/lib/ /usr/lib/perl5/site_perl/5.26.1/x86_64-linux-thread-multi /usr/lib/perl5/site_perl/5.26.1 /usr/lib/perl5/vendor_perl/5.26.1/x86_64-linux-thread-multi /usr/lib/perl5/vendor_perl/5.26.1 /usr/lib/perl5/5.26.1/x86_64-linux-thread-multi /usr/lib/perl5/5.26.1 /usr/lib/perl5/site_perl) at /global/project/projectdirs/m3857/cesm2_2_0/cime/scripts/Tools/../../utils/perl5lib/Config/SetupTools.pm line 5.
      BEGIN failed--compilation aborted at /global/project/projectdirs/m3857/cesm2_2_0/cime/scripts/Tools/../../utils/perl5lib/Config/SetupTools.pm line 5.
      Compilation failed in require at /global/project/projectdirs/m3857/cesm2_2_0/components/clm/bld/CLMBuildNamelist.pm line 410
