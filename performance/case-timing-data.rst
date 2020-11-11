################
Case Timing Data
################

Overview
========

CIME uses the `General Purpose Timing Library (GPTL)
<https://esmci.github.io/cime/versions/master/html/users_guide/timers.html>`_
to provide detailed timing information.

Timing files are output to ``$CASEROOT/timing/$model_timing.$CASE.$datestamp``.

The two areas we plan to focus on to increase the model performance is to
understand the bottlenecks occuring during the ``Init Time`` phase of each job.

Does init time take longer for first job in hybrid run?
-------------------------------------------------------

No. I suspected that the init time might take longer for the first submission
of a given integration since there may be initialization tasks involved for a
hybrid run in which continue_run = FALSE but this seems to be fals.

For the first submission of FHIST_BGC.f09_d025.052.e3 ``Init Time : 539.420
seconds`` while in the second submission ``Init Time: 562.777 seconds``.

