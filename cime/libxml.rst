###################
Missing XML Library
###################

When Shaheen II underwent maintenance on two seperate occasions -- the 22 June
2021 and the 25 January 2022 upgrades -- the LibXML library went missing.

This library is used by a pair of perl scripts in CIME:

.. code-block::

   /lustre/project/k1421/cesm2_1_3/cime/utils/perl5lib/compilers_translation_tool.pl
   /lustre/project/k1421/cesm2_1_3/cime/utils/perl5lib/Config/SetupTools.pm

After the 22 June 2021 upgrade, Bilel Hadri provided these instructions:

   Here is a work around. On the cdl5, connect via ssh cdl5 once you are on
   shaheen and load the module perl/5.34.0. It should work.

The problem seems to occur when the ``XML::LibXML module`` isn't installed.

This ``xml_test.pl`` script triggers the error if the module is not installed:

.. code-block::

   #!/usr/bin/env perl
 
   use strict;
   use warnings;
   use XML::LibXML;
   
   print "Hello world!\n";
   
   my $new_node = XML::LibXML::Element->new("compiler");

Run the script as follows:

.. code-block::

   perl xml_test.pl 

It will merely print "Hello World!" if the module is installed. If it isn't,
an error message gets printed:

.. error::

   Can't locate XML/LibXML.pm in @INC (you may need to install the XML::LibXML module)
   (@INC contains: /opt/slurm/default//lib/perl5/site_perl/5.26.1/x86_64-linux-thread-multi
   /usr/lib/perl5/site_perl/5.26.1/x86_64-linux-thread-multi /usr/lib/perl5/site_perl/5.26.1
   /usr/lib/perl5/vendor_perl/5.26.1/x86_64-linux-thread-multi
   /usr/lib/perl5/vendor_perl/5.26.1 /usr/lib/perl5/5.26.1/x86_64-linux-thread-multi
   /usr/lib/perl5/5.26.1 /usr/lib/perl5/site_perl) at xml_test.pl line 5.
   BEGIN failed--compilation aborted at xml_test.pl line 5.

Installing perl locally
=======================

Following the instructions in this `tutorial
<https://help.dreamhost.com/hc/en-us/articles/360028572351-Installing-a-custom-version-of-Perl-locally>`_
and noting that `batch jobs on Shaheen cannot write to project or home
directories anymore <https://www.hpc.kaust.edu.sa/tips/scratch-vs-project>`_, 
these steps install perl on scratch. It can then be copied to project space.

.. code-block::

   cd /lustre/scratch/x_johnsobk
   wget https://www.cpan.org/src/5.0/perl-5.26.1.tar.gz
   tar zxf perl-5.26.1.tar.gz 
   cd perl-5.26.1/
   vim runme.sh

The ``runme.sh`` shell script contains:

.. code-block::

  #!/bin/bash

  #SBATCH --job-name=build_perl
  #SBATCH --account=k1421
  #SBATCH --ntasks=32
  #SBATCH --ntasks-per-node=32
  #SBATCH --time=11:59:00
  #SBATCH --partition=workq
  #SBATCH --output=build_perl.out.%j
  
  ./Configure -des -Dprefix=/lustre/scratch/x_johnsobk/opt/perl
  make
  make test
  make install
  
  exit 0 

Submit the shell script:

.. code-block::

   sbatch runme.sh
   Submitted batch job 23628102

The perl installation path can be prepended to the ``$PATH`` environmental
variable:

.. code-block::

   vim ~/.bashrc
   [...]
   export PATH=/lustre/scratch/x_johnsobk/opt/perl/bin:$PATH
   [...]
   source ~/.bashrc

