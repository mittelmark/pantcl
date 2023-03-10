#############
Rst Example 
#############

The text below will contain the following examples:

* Tcl code blocks
* Tcl inline codes
* R code blocks using the pipe filter
* R inline codes  
* GraphViz Dot code blocks
* Kroki code blocks

This document was created using the following command line:

.. code-block:: bash

   pandoc sample.rst --filter pantcl -o sample-rst.html -s \
      --metadata-file sample.yaml



*************
Tcl Code
*************

Let's now try Tcl code blocks:

.. code-block:: tcl
   :caption: Tcl-code
   :eval: true

   set x 1
   puts $x
   incr x



Now some more text with inline Tcl x is now ``tcl set x``!

*************
R Code
*************

Now some R code:

.. code-block:: rplot
   :eval: true

   r = 1
   print(r)
   plot(1)



Let's now try Tcl code blocks:


.. code-block:: tcl

   set x 1
   puts $x
   incr x




That's the end.


