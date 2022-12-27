############################################
Getting files from the Research Data Archive
############################################

The output from the `CAM6+DART Reanalysis <https://www.nature.com/articles/s41598-021-92927-0>`_
is stored in `NCAR's Research Data Archive <https://rda.ucar.edu/datasets/ds345.0/>`_.

Location of files on the GLADE filesystem
=========================================

The files are available for Cheyenne users on the GLADE filesystem here:

.. code-block::

   cd /gpfs/fs1/collections/rda/data/ds345.0/rest/2018-01/
   cp *2018-01-01* /glade/scratch/johnsonb/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest

Untarring all of the instances
==============================

In order to untar all of the instances, run ``untar.py``:

.. code-block:: python

   #!/usr/bin/env python
 
   from __future__ import print_function
 
   import os
 
   for instance in range(1, 81):
 
      instance_string = str(instance).zfill(4)
      print(instance_string)
 
      arch_string = 'f.e21.FHIST_BGC.f09_025.CAM6assim.011.'+instance_string+'.alltypes.2018-01-01-00000.tar'
 
      command = 'tar -xvf '+arch_string
 
      print(command)
      os.system(command) 

Then simply unzip the compressed files:

.. code-block::

   cd /glade/scratch/johnsonb/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest/2018-01-01-00000
   gunzip -v *.gz

