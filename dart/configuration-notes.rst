###################
Configuration Notes
###################

Maximum Number of Members?
==========================

Tim Hoar suggested that the maximum number of ensemble members might be limited
by a character string of length three, thus limiting the ensemble to 999.

Jeff Anderson said the quickest way to test this is to run Lorenz '63 with 1000
members to see if anything crashes. The likeliest place to look for this would
be in the ensemble manager and it might be a two line modification to test
the string output.

I was able to run Lorenz '63 with 1001 members, so this seems to be a
non-issue.
