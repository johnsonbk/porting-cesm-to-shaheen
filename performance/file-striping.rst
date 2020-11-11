#############
File Striping
#############

Overview
========

Shaheen uses the lustre filesystem, which provides the ability for `file
striping <https://www.hpc.kaust.edu.sa/content/lustre>`_.

Striping files and directories must be done with care. A note from Shaheen's 
documentation:

.. note:: *Once a file has been written to Lustre with a particular stripe 
   configuration, you cannot simply use setstripe to change it. The file must
   be re-written with a new configuration. Generally, if you need to change the
   striping of a file, you can do one of two things:*
   
   - *using setstripe, create a new, empty file with the desired stripe
     settings and then copy the old file to the new file, or*
   - *setup a directory with the desired configuration and cp (not mv) the file
     into the directory*

Some other general considerations, per the documentation:

  *Large files benefit from higher stripe counts. By striping a large file over
  many OSTs, you increase bandwidth for accessing the file and can benefit from
  having many processes operating on a single file concurrently. Conversely, a
  very large file that is only striped across one or two OSTs can degrade the
  performance of the entire Lustre system by filling up OSTs unnecessarily. A
  good practice is to have dedicated directories with high stripe counts for
  writing very large files into.*
  *Another scenario to avoid is having small files with large stripe counts.*


Optimizing your I/O Performance
-------------------------------

Some general tips for optimizing I/O performance `include
<https://www.hpc.kaust.edu.sa/tips/optimizing-your-io-performance>`_:

- Increasing the stripe count when multiple processes write to a single shared
  file, such as when parallel NetCDF is used
- Avoiding striping small files

Setting the striping of a directory
===================================

If a directory has not been previously striped, it is straightforward to stripe
all of the files contained within it:

.. code-block:: bash

  $ cd /lustre/scratch/x_johnsobk/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest/
  $ lfs setstripe --stripe-count 128 2019-08-05-00000
  $ lfs getstripe -d 2019-08-05-00000                                           
  stripe_count:  128 stripe_size:   1048576 pattern:       raid0 stripe_offset: -1

Changing the striping of a directory
====================================

If we want to change the striping of a directory that already has a certain
filestriping configuration:

.. code-block:: bash

  $ cd /lustre/scratch/x_johnsobk/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest/
  $ lfs getstripe -d 2019-08-05-00000
  stripe_count:  128 stripe_size:   1048576 pattern:       raid0 stripe_offset: -1

We need to move the directory,  make a new one:

.. code-block:: bash

  $ mv 2019-08-05-00000 2019-08-05-00000-old
  $ mkdir 2019-08-05-00000

Then copy the files from the old directory to the new one (which, of course,
will take a while since there are 80 ensemble members):

.. code-block:: bash

  $ cp  2019-08-05-00000-old/* 2019-08-05-00000
  $ rm -rf 2019-08-05-00000-old

And we'll see the new striping is present:

.. code-block:: bash

  $ lfs getstripe -d 2019-08-05-00000
  stripe_count:  1 stripe_size:   1048576 pattern:       0 stripe_offset: -1

