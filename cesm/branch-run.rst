##########
Branch run
##########

Overview
========

Switching from a ``f09_d025`` grid to a ``f09_g17`` grid requires paying
attention to the ``RUN_TYPE`` of the case.

.. code-block::

  ./xmlquery RUN_TYPE --valid-values
       RUN_TYPE: ['startup', 'hybrid', 'branch']

