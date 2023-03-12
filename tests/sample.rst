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

For pdf creation we used a command line like this:

.. code-block:: bash

   pandoc sample.rst --filter ../pantcl.tcl -o sample-rst.pdf --metadata \
       documentclass=scrartcl --metadata-file sample.yaml

Here the source code of the rst-document:
`<https://raw.githubusercontent.com/mittelmark/pantcl/main/tests/sample.rst>`_

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


For more fine tuned output it is recommend to use the pipe filter like this:

.. code-block:: pipe
   :eval: true
   :pipe: R 

   x=2
   png("sample.png")
   plot(1:20,pch=1:20,cex=2,col=rainbow(20))
   dev.off()

 
.. image:: sample.png
  :width: 400
  :alt: Alternative text  

As this filter does not automatically include the image we write here a PNG
file using the ``png`` command. The `pipe` filter allows as well to have a 
continued session over all code chunks. Let's access for instance now the x 
variable in a next code chunk:

.. code-block:: pipe
   :eval: true
   :pipe: R

    print(x)


OK, this should display a two even if x was declared in the previous chunk.


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


Now an example where we hide the source code which should be normal if we like
only to show the image but not the code:

.. code-block:: kroki
   :caption: kroki example
   :eval: true
   :echo: false

   digraph g {
      
      rankdir="LR";
      node[style=filled,fillcolor=salmon,shape=box];
      A -> B -> C;
   }


That's the end of this short example on how to use `Rst` files with some of the
`pantcl` filters.


