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

* [pantcl.html](pantcl.html) - main documentation

Filter documentation:

- [filter-abc](lib/tclfilters/filter-abc.html)
- [filter-cmd](lib/tclfilters/filter-cmd.html)
- [filter-dot](lib/tclfilters/filter-dot.html)
- [filter-eqn](lib/tclfilters/filter-eqn.html)
- [filter-kroki](lib/tclfilters/filter-kroki.html)
- [filter-mmd](lib/tclfilters/filter-mmd.html)
- [filter-mtex](lib/tclfilters/filter-mtex.html)
- [filter-pic](lib/tclfilters/filter-pic.html)
- [filter-pik](lib/tclfilters/filter-pik.html)
- [filter-pipe](lib/tclfilters/filter-pipe.html)
- [filter-puml](lib/tclfilters/filter-puml.html)
- [filter-rplot](lib/tclfilters/filter-rplot.html)
- [filter-sqlite](lib/tclfilters/filter-sqlite.html)
- [filter-tcl](lib/tclfilters/filter-tcl.html)
- [filter-tcrd](lib/tclfilters/filter-tcrd.html)
- [filter-tdot](lib/tclfilters/filter-tdot.html)
- [filter-tsvg](lib/tclfilters/filter-tsvg.html)

