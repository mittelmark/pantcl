# Pantcl

Standalone Tcl application for document conversion with support for Tcl based
filters using the Pandoc document processor or Tcl only.

The application `pantcl(.bin)` is a command line tool which can be used as a
standalone tool for document conversion from Markdown to HTML. In the Markdown
document as well code for programming languages like Tcl, Python, C++, Go or other tools like diagram
creation tools, image creation tools or for instance music note processors can be embedded.
For processing other input formats like ReStructuredText, Wiki Syntax, LaTeX it
can be used as well as a filter for the pandoc document processor. This way it
is as well possible to target other output format like docx, pdf and many
others. The tools contains as well a graphical user interface for direct
editing of code for graphical tools like GraphViz, PlantUml and many others.

So in summary pantcl allows you:

- document conversion from Markdown to HTNML with evaluation of internal code chunks without pandoc
- document conversion from many input (Markdown, ReStructuredText, Wiki formats, ...) 
  to many output formats (HTML, DOCX, PDF, ...) with evaluation of internal code chunks 
- writing code documentation inside source code using a `#'` prefix followed by
  Markdown code
- write filters for other graphical or programming tools using the Tcl programming language
- use a graphical interface to edit Markdown files with embedded code chunks
- use a graphical interface to edit diagram code with real time preview

# Documentation

Here are links to the documentation:

* [pantcl.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/pantcl.html) - main documentation
* [pantcl-tutorial.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/pantcl-tutorial.html) - more extensive tutorial

<a name="filterlist" />
Filter documentation:

- [filter-abc](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-abc.html) - visualize [ABC music notation](https://abcnotation.com/)
- [filter-cmd](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-cmd.html) - execute shell scripts for instance [Lilypond music scripts](http://lilypond.org/), [GraphViz](https://www.graphviz.org) scripts, Python, Lua, R scripts, [sqlite3](https://www.sqlite.org) scripts, or code for languages like  C, C++, Go, Rust, V  etc.
- [filter-dot](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-dot.html) - [GraphViz dot](https://www.graphviz.org) filter
- [filter-eqn](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-eqn.html) - visualize mathematical equations using eqn2graph, see here [Guide for typesetting using eqn](https://lists.gnu.org/archive/html/groff/2013-10/pdfTyBN2VWR1c.pdf)
- [filter-kroki](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-kroki.html) - visualize diagram code using the [kroki webservice](https://kroki.io)
- [filter-mmd](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-mmd.html) - visualize diagram code using the [mermaid command line tool](https://github.com/mermaidjs/mermaid.cli)
- [filter-mtex](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-mtex.html) - visualize mathematical equations using LaTeX
- [filter-pic](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-pic.html) - visualize diagram and flowcharts using the [PIC language](https://en.wikipedia.org/wiki/PIC_(markup_language))
- [filter-pik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-pik.html) - visualize diagram code or flowcharts uing [pikchr](https://fossil-scm.org/home/doc/trunk/www/pikchr.md) or [fossil](https://fossil-scm.org/home/doc/trunk/www/index.wiki)
- [filter-pipe](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-pipe.html) - embed R, Python or Octave code or plots into Markdown
- [filter-puml](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-puml.html) - embed [PlantUML](http://www.plantuml.com) code
- [filter-rplot](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-rplot.html) - embed R plots
- [filter-sqlite](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-sqlite.html) - embed [Sqlite3 SQL database](https://www.sqlite.org) statements
- [filter-tcl](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tcl.html) - embed Tcl statements
- [filter-tcrd](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tcrd.html) - embed Tcl music chords.
- [filter-tdot](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tdot.html) - embed Tcl GraphViz diaragrams
- [filter-tsvg](https://htmlpreview.github.io/?https://raw.githubusercontent.com/mittelmark/pantcl/master/lib/tclfilters/filter-tsvg.html) - embed Tcl created SVG code

# Installation

Please note, that you must have a tclsh executable in your PATH to use this
tool. On Ubuntu systems you can install Tcl using your package managers like
this: `sudo apt install Tcl`. If you have a `tclsh` executable in your `PATH`
you then download the latest build from the Github page here: 

[https://github.com/mittelmark/pantcl/suites/10325546892/artifacts/508197131](https://github.com/mittelmark/pantcl/suites/10325546892/artifacts/508197131)

Unpack the Zip-Archive and make the file pantcl.bin executable using chmod. You can as rename
it for instance to just `pantcl`. Then move it to a folder within belonging to your `PATH` variable. For instance "~./bin" or "~/.local/bin".

The file `pantcl.bin` contains embedded all the filters mentioned above. You can try out the installation by creating a simple Markdown file with some embedded Tcl code like this:

```
    ---
    title: Test Markdown witch embedded Tcl code.
    author: Detlef Groth
    date: 2023-01-11
    tcl:
       eval: 1
    ---

    ## Header

    This is some text.

    ```{.tcl eval=true}
    set x 1
    set x
    ```

    Here some inline Tcl expression x is now `tcl set x`. 

    This document was compiled at 
    `tcl clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"` CET.
```

Save this code in a file `test.md` removing the leading whitespaces and try to convert the file using the command line:

```
pantcl.bin test.md test.html -s
```

The output `test.html` should then look like this:

![](examples/test1.png)


If this works you can continue and try to use other code filters from the list shown [above](#filterlist).

Please note, that since version 0.9.2 the filter evaluation is per default set
to false to avoid interpretation just by accident. You must enable filter
evaluation either on individual code chunks by setting `eval=true` as the code
chunk option as shown above or if you like to have it globally enabbled by
writing it in the YAML header of a Markdown document like this:

```
---
title: xyz
author: nn
date: 2023-03-11
tcl:
    eval: 1
dot:
    eval: 1
---
```

Which would enable code evaluation for Tcl and graphics generation for every
GraphViz dot code chunk. 

## Rst files

If your input document does not support YAML headers
you can provide a YAML configuration in an external file, an example can be seen
in the file [tests/sample.yaml](tests/sample.yaml). You then provide the required
argument for the pandoc document converter in the command line like this:

```
pandoc sample.rst --filter pantcl -o sample-rst.html -s \
		--metadata-file sample.yaml
```

How to define chunk options in Rst files can be seen here in the file
[tests/sample.rst](tests/sample.rst).

To create a PDF file you could use a command line like this:

```
pandoc sample.rst --filter ../pantcl.tcl -o sample-rst.pdf \
    --metadata documentclass=scrartcl --metadata-file sample.yaml
```

Here the resulting output file 
[sample-rst.pdf](https://github.com/mittelmark/pantcl/files/10951380/sample-rst.pdf).

