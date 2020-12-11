###########
Environment
###########

User Guide
==========

`Shaheen II User Guide <https://www.hpc.kaust.edu.sa/user_guide>`_

Training Materials
==================

KAUST provides instructional materials about the programming environments on
Shaheen.

- `Programming/Runtime Environment
  <https://www.hpc.kaust.edu.sa/sites/default/files/files/public//KSL/150520-User_Workshop/KSL_ProgEnv.pdf>`_
- `List of User Training Materials <https://www.hpc.kaust.edu.sa/training>`_

Programming Environments
========================

Shaheen provides three different programming environments 

There are three different compiler environments, each with their own compilers:

- ``PrgEnv-cray`` (crayftn, craycc, crayCC)
- ``PrgEnv-intel`` (ifort, icc, icpc)
- ``PrgEnv-gnu`` (gfortran, gcc, g++)

According to the `documentation
<https://www.hpc.kaust.edu.sa/sites/default/files/files/public//KSL/150520-User_Workshop/KSL_ProgEnv.pdf>`_: 

  *All applications that will run in parallel on the Cray XC should be compiled
  with standard language wrappers:* ``cc`` *for C,* ``CC`` *for C++, and*
  ``ftn`` *for Fortran.*

.. note:: Using the ``ftn`` wrapper means that the appropriate Fortran compiler
   will be used, regardless of the programming environment.

No additional MPI flags are needed as they are included by wrappers.

Again, according to the `documentation                                                 
<https://www.hpc.kaust.edu.sa/sites/default/files/files/public//KSL/150520-User_Workshop/KSL_ProgEnv.pdf>`_:

  *There is no universally fastest compiler – but performance depends on the
  application, even input. However Cray is trying to excel with the Cray
  Compiler Environment. Compiler flags do matter – be ready to spend some
  effort finding the best ones for your application.*


