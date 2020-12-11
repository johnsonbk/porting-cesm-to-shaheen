#############
File Striping
#############

Optimizing I/O Performance
==========================

Shaheen uses the lustre filesystem, which provides the ability for `file
striping <https://www.hpc.kaust.edu.sa/content/lustre>`_.

Some general tips for optimizing I/O performance `include
<https://www.hpc.kaust.edu.sa/tips/optimizing-your-io-performance>`_:

- Increasing the stripe count when multiple processes write to a single shared
  file, such as when parallel NetCDF is used
- Avoiding striping small files

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

Advice from KAUST Supercomputing Lab
====================================

We corresponded with `Dr. Bilel Hadri <https://twitter.com/mnoukhiya?lang=en>`_,
a computational scientist at the KAUST Supercomputing Lab, for advice on
how to configure the file striping for the forcing and restart files. His 
general suggestions are as follows:

   *For the I/O striping, I would suggest to go around 24/48 maximum probably
   only for the large files around 20-34GB, while keeping the default one at 1.
   Make sure to check the striping per file to validate them, since the
   striping is not inherited by the directory only at its creation of the file
   or copied, while when moved the file is keeping its original striping.*

Best LFS Stripe Count for Different Node Counts
===============================================

This `presentation <https://www.hpc.kaust.edu.sa/sites/default/files/files/public/Shaheen_training/171107_IO/IO-Arch.pdf>`_
contains a benchmarking graph on slide 13 that shows the optimal stripe count
is around 100 for processes using more than 500 nodes.


Striping Commands
=================

Below are sets of commands to change the striping of files and directories. 
Again, once a file has been written with a particular configuration, invoking 
`setstripe` will not change its file striping. A new file must be created with
the desired striping and the old data must be copied into it.

Changing the striping of a file
-------------------------------

If a file has been previously striped, we must create a new file, assign it the
desired stripe configuration, then copy the contents of the old file into the
new one.

.. code-block:: bash

  $ cd /lustre/project/k1421/cesm_store/inputdata/atm/cam/tracer_cnst/
  $ mv tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216_old.nc
  $ lfs setstripe -c 48 tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc
  $ cp tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216_old.nc tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc

Once this procedure has completed, we see that the file possesses the new file
striping.

.. code-block:: bash

  $ lfs getstripe tracer_cnst_halons_WACCM6_3Dmonthly_L70_1975-2014_c180216.nc 
  lmm_stripe_count:  48
  lmm_stripe_size:   1048576
  lmm_pattern:       raid0
  lmm_layout_gen:    0
  lmm_stripe_offset: 84

Setting the striping of a directory
-----------------------------------

If a directory has not been previously striped, it is straightforward to stripe
all of the files contained within it:

.. code-block:: bash

  $ cd /lustre/scratch/x_johnsobk/archive/f.e21.FHIST_BGC.f09_025.CAM6assim.011/rest/
  $ lfs setstripe --stripe-count 128 2019-08-05-00000
  $ lfs getstripe -d 2019-08-05-00000                                           
  stripe_count:  128 stripe_size:   1048576 pattern:       raid0 stripe_offset: -1

Changing the striping of a directory
------------------------------------

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

