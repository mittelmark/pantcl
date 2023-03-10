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


********************
GraphViz dot example
********************

Let's continue with a GraphViz dot example:

.. code-block:: dot
   :caption: GraphViz dot example
   :eval: false

   digraph g {
      A -> B ;
   }


 
***************
Kroki example
***************

.. code-block:: kroki
   :caption: kroki example
   :eval: true

   digraph g {
      graph[size="8.0,4.0!",scale="3.0!"];
      rankdir="LR";
      node[style=filled,fillcolor=skyblue,shape=box];
      A -> B -> C;
   }


Now an example where we hide the source code:


.. code-block:: kroki
   :caption: kroki example
   :eval: true
   :echo: false

   digraph g {
      
      rankdir="LR";
      node[style=filled,fillcolor=salmon,shape=box];
      A -> B -> C;
   }
That's the end.


