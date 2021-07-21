####################
Troubleshooting CIME
####################

The testing suite for the Common Infrastructure for Modeling the Earth (CIME)
doesn't seem to comprehensively cover the use cases we've been conducting. Thus
there are many instances in which builds and case submissions fail for reasons
that are seemingly perplexing. This document explains a subset of these
failures.

input_data.checksum.dat
=======================

.. error::

   .. code-block::

      Trying to download file: '../inputdata_checksum.dat' to path [...]/run/inputdata_checksum.dat.raw'

This error seems to be caused by the configuration of the wget address path
(which gets called since the globus-url-copy tool isn't installed on either
Cori or Shaheen II) in ``$CIMEROOT/config/cesm/config_inputdata.xml``:

.. code-block::

   <server>
     <protocol>wget</protocol>
     <address>ftp://ftp.cgd.ucar.edu/cesm/inputdata</address>
     <user>anonymous</user>
     <password>user@example.edu</password>
     <checksum>../inputdata_checksum.dat</checksum>
   </server>

The address path should be appended with a trailing slash 
``ftp://ftp.cgd.ucar.edu/cesm/inputdata/`` since the checksum path starts with
``../inputdata_checksum.dat``.

