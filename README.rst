##############################
Sphinx as a Documentation Tool
##############################

This is created using a documentation generation tool written in python known
as `Sphinx <https://www.sphinx-doc.org/en/master/>`_.

If you are a regular python user, and would like to use Sphinx, install it
using the package management procedure with which you are most comfortable.

Installing Conda
================

If you are novice python user, here are instructions for installing Sphinx
using the package manager known as `Conda  <https://docs.conda.io/en/latest/>`_
(short for Anaconda) on Mac OSX.

Open a terminal window and execute these three commands:

1. Download the installation script:

.. code:: bash

   curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

2. Modify the execution permissions of the recently downloaded script:

.. code:: bash

   chmod 755 ./Miniconda3-latest-MacOSX-x86_64.sh

3. Run the installation script and follow its instructions:

.. code:: bash

   ./Miniconda3-latest-MacOSX-x86_64.sh

Downloading Sphinx
==================

Now that Conda is installed, use it to download Sphinx. Close and reopen the
terminal window to ensure conda is activated.

1. Invoke Conda and instruct it to install two packages, Sphinx and the "Read
   the Docs" CSS theme for Sphinx:

.. code:: bash

   conda install sphinx sphinx-rtd-theme

Clone the Repository
====================

You're ready to clone the repository:

.. code:: bash

   git clone https://github.com/johnsonb-ucar/porting-cesm-to-shaheen.git
   cd porting-cesm-to-shaheen

Edit Files and Remake the Documentation
=======================================

The files that comprise the documentation are written in `reStructuredText
<https://thomas-cokelaer.info/tutorials/sphinx/rest_syntax.html>`_ which offers
a reasonably simple syntax for writing documentation while still accommodating
the elements needed for technical writing such as equations, references, code
snippets, tables, etc.

Find the reStructuredText documents contained in this repository:

.. code:: bash

   find . -name "*.rst"

Edit them using your favorite text editor and then remake the documentation:

.. code:: bash

   make clean
   make html

View the remade documentation in your favorite web browser by opening the
``./_build/html/index.html`` using your graphical user interface or via the
command line:

.. code:: bash

   open ./_build/html/index.html
