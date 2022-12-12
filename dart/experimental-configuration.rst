##########################
Experimental configuration
##########################

Filters
=======

- The Ensemble Kalman Filter (Evensen, 2003 [1]_ )
- The Ensemble Adjustment Kalman Filter (Anderson, 2003 [2]_ )
- The Ensemble Kalman Filter with Exact Second Order Perturbation Sampling
  (Hoteit et al. 2015 [3]_ )

.. note::

   ``sort_obs_inc`` must be set to ``.true.`` for EnKF-esops and EnKF.

.. important::

   For Moha's diagnostics: ``compute_posterior = .true.``

Inflation
=========

Inverse gamma adaptive (Gharamti, 2018 [4]_ ) prior inflation will be used for 
each of the three experiments.

Saved output
============

The following files will be saved from the integration:

- All ``obs_seq.final`` files
- All prior inflation mean and standard deviation files
- The preassim and output stages will be saved.


References
==========

.. [1] Evensen, G., 2003: The Ensemble Kalman Filter: theoretical formulation
       and practical implementation. Ocean Dynamics, 53, 343–367,
       https://doi.org/10.1007/s10236-003-0036-9.
.. [2] Anderson, J. L., 2003: A Local Least Squares Framework for Ensemble
       Filtering. *Monthly Weather Review*, **131**, 634–642.
.. [3] Hoteit, I., D.-T. Pham, M. E. Gharamti, and X. Luo, 2015: Mitigating
       Observation Perturbation Sampling Errors in the Stochastic EnKF.
       *Monthly Weather Review*, **143**, 2918–2936.
.. [4] Gharamti M., 2018: Enhanced Adaptive Inflation Algorithm for Ensemble
       Filters. *Monthly Weather Review*, **2**, 623-640,
       `doi:10.1175/MWR-D-17-0187.1 <https://doi.org/10.1175/MWR-D-17-0187.1>`_
