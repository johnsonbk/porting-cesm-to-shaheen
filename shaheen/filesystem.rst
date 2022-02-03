##########
Filesystem
##########

A helpful reminder
==================

.. important::

   Shaheen, as of 9 January 2022, no longer allows scripts to write to project
   space.

This is the notification from Maciej Olchowik:

  Following successful acceptance of the new project filesystem last month, we
  are now in a position to deploy more storage in production.

  In the next two weeks we will transition most of the projects to this new
  filesystem.

  The only impact on the users is that the new ``/project`` filesystem is now
  mounted read-only on the compute nodes. This means that any jobs that are
  configured to write to ``/project`` directly will fail. 

  We have always encouraged all our users to run their jobs from the
  ``/scratch`` filesystem, this will now be necessary with the above change.
  Please see this link for the differences between project and scratch: 
  https://www.hpc.kaust.edu.sa/tips/scratch-vs-project

Thus to compile DART executables it is necessary to move the DART directory to
scratch, run the quickbuild scripts and then move the directory back to project
space.

