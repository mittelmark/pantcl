# pantcl


Providing document conversion with Tcl based filters using pandoc or Tcl only.

The application `pantcl` is a command line tool whioch can be used as a
standalone tool for document conversion for instance from Markdown to HTML. It
can be used as well as a filter for the pandoc document processor to embed and
execute Tcl code in documents like Markdown or LaTeX and to write addtional
filters using the Tcl progtamming language to embed code for other command line tools for instance GraphViz, ABC music, the Python or R programming language. It as well contains an option to execute code chunks within a graphical user interface

So in summary pantcl allows you:

- document conversion from Markdown to HTML
- extraction of Markdown embedded documentation in Programming code like Tcl, Python or C++.
- embed and execute Tcl code in Markdown documents
- write filters for other tools using the Tcl prgramming language /many sample filters already included)
- graphical interface to edit Markdown files with embedded code chunks

# Documentation

Here are links to the documentation:

* [pantcl.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/pantcl.html) - main documentation

Filter documentation:

- [filter-abc](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-abc.html)
- [filter-cmd](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-cmd.html)
- [filter-dot](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-dot.html)
- [filter-eqn](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-eqn.html)
- [filter-kroki](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-kroki.html)
- [filter-mmd](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-mmd.html)
- [filter-mtex](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-mtex.html)
- [filter-pic](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-pic.html)
- [filter-pik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-pik.html)
- [filter-pipe](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-pipe.html)
- [filter-puml](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-puml.html)
- [filter-rplot](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-rplot.html)
- [filter-sqlite](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-sqlite.html)
- [filter-tcl](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tcl.html)
- [filter-tcrd](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tcrd.html)
- [filter-tdot](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tdot.html)
- [filter-tsvg](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tsvg.html)

# Installation

Download the latest build from the Github page here: [https://github.com/mittelmark/pantcl/suites/10308182396/artifacts/506908587](https://github.com/mittelmark/pantcl/suites/10308182396/artifacts/506908587)

Unpack the Zip-Archive and make the file pantcl.tapp executable you can rename
it for instance as well to something like `pantcl.bin` or just `pantcl`. Then move it to a folder within belonging to your `PATH` variable.

This file contains all the filters mentioned above. You can try out the installation by creating a simple Markdown file with some embedded Tcl code like this:

```
     ---
     title: Test Markdown
     author: Detlef Groth
     date: 2023-01-10
     ---

     This is some text.

     ```{.tcl}
     set x 1
     set x
     ```
```

Save this code in a file `test.md` removing the leading whitespaces and try to convert the file using the command line:

```
pantcl.tapp test.md test.html -s
```



