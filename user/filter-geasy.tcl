#' ---
#' title: "filter-geasy.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2023-04-17
#' geasy:
#'     app: graph-easy
#'     eval: 1
#'     as: ascii
#'     filter: user/filter-geasy.tcl
#' ---
#' 
# A simple pandoc filter for the [graph-easy](http://bloodgate.com/perl/graph/manual/)  application to demonstrate the use of user programmed filters.
#' 
#' 
#' ## Name
#' 
#' _filter-geasy.tcl_ - Filter which can be used to evaluate [Graph-Easy](http://bloodgate.com/perl/graph/manual/) code
#' within a Pandoc processed document using the Tcl filter driver `pantcl` using user 
#' provided filter written in Tcl. 
#' 
#' ## Description
#' 
#' This is a filter supporting an easy to use command line based diagramming tool. The `graph-easy` command line application can be installed using your 
#' package manager on Unix system like this on Fedora Linux `sudo dnf install perl-Graph-Easy` or on 
#' Ubuntu/Debian `sudo apt-get install -y libgraph-easy-perl`. 
#' 
#' Please note that this filter mainly exists mainly to demonstrate how to use an external pandoc
#' filter written in the Tcl programming without adding it directly to the pantcl executable.
#' For more documentation on how to implement your own filter see the [user-filter](user-filter.html).
#' 
#' ## Usage
#' 
#' Graph-Easy code is embedded into Markup languages like Markdown like this 
#' (remove the spaces at the beginning, they are here just for protecting the evaluation):
#' 
#' ```
#'      # code chunk defaults (must be in fact not given):
#'      ```{.geasy eval=true echo=true}
#'      [Bonn] - car -> [Berlin]
#'      ```
#' ```
#' 
#' Where `eval` and `echo` are so called chunk options. Please note that this is an external filter,
#' to use the filter your actual need to point in your YAML header to the filter implementation, see below for more informatian.
#' 
#' The conversion of the Markdown documents via Pandoc should be then done as follows:
#' 
#' ```
#' pantcl input.md output.html  -s
#' ```
#' 
#' The application file *pantcl* which contains the Tcl filter and all other filters has to be placed in the PATH and the 
#' system has to support the Shebang, on Unix this is standard on Windows you need to use tools like Cygwin, Msys, 
#' Git-Bash or Cygwin (untested).  
#' 
#' The arguments after the output file are delegated to pandoc.
#' 
#' If code blocks with the `.geasy` marker are found, the contents in the code 
#' block is processed via the graph-easy command line application.
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - _app_ - the command line application to be called, usually `graph-easy`, default: `graph-easy`
#'   - _as_  - the output format default, ascii, other options are boxart, dot, default: ascii
#'   - _echo_ - should the graph easy source code be shown, default: true|1
#'   - _eval_ - should the code in the code block be evaluated, default: false|0
#'   - _ext_ - the image filetype to be generated if output `as` is `dot`, either png, pdf, svg usually, default: svg
#'   - _results_ - should the output of the command line application been shown, should be show or hide, default: "show"
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' You should set eval to 1 as shown as well below, the term true
#' might produce an error, so write `eval: 1`
#' 
#' ```
#'  ----
#'  title: "filter-geasy.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2023-04-15
#'  geasy:
#'      app: graph-easy
#'      eval: 1
#'      filter: user/filter-geasy.tcl
#'      ext: svg
#'  ----
#' ```
#'
#' ## Examples
#' 
#' Here an example for a simple diagram  with chunk options `{.geasy eval=true}`:.
#' 
#' ```{.geasy eval=true}
#' [Bonn] - car -> [Berlin]
#' ```
#' 
#' Using the option `{.geasy eval=true results="hide"}` the output of the command line tool can be hidden.
#' 
#' ```{.geasy eval=true results="hide"}
#' [Bonn] - car -> [Berlin]
#' ```
#' 
#' Using the option `{.geasy eval=true as="boxart"}` we can try to use Unicode boxart characters.
#' 
#' ```{.geasy eval=true as="boxart"}
#' [Bonn] - car -> [Berlin]
#' ```
#' 
#' Using the option `{.geasy eval=true as="dot"}` we can as well output a SVG graphic. Please
#' note that this needs an installed GraphViz dot interpreter which must be in the PATH.
#' 
#' ```{.geasy eval=true as="dot"}
#' [Bonn] - car -> [Berlin]
#' ```
#' 
#' In this case we usually like to hide the digraph code output we can to this by writing results="hide" as code chunk option.
#' Consulting the tutorial page for graph-easy syntax we can as well see that we can set 
#' some display options for nodes etc. the code chunk options here are: `{.geasy eval=true as="dot" results="hide"}`
#'
#' ```{.geasy eval=true as="dot" results="hide"}
#' [ Paris ]   { shape: ellipse; fill: salmon; }
#' -- Flight -->
#' [ Bonn  ]   { shape: circle; fill: skyblue; }
#' -- Car -->  { color: red; }
#' [ Berlin ]  { fill: rgb(255,228,221); }
#' ```
#' 
#' The default filetype is svg, but we can as well change this to png by using the chunk option `ext=png`.
#' 
#' ```{.geasy eval=true as="dot" results="hide" ext=png}
#' [ PNG-Output ]
#' [ Paris ]   { shape: ellipse; fill: salmon; }
#' -- Flight -->
#' [ Bonn  ]   { shape: circle; fill: skyblue; }
#' -- Car -->  { color: red; }
#' [ Berlin ]  { fill: rgb(255,228,221); }
#' ```
#'
#' ## See also:
#' 
#' * [user-filter](user-filter.html) - more information on how to create your own filter using Tcl
#' * [pantcl Readme](../README.html)
#' * [pantcl manual](../pantcl.html)
#' * [pantcl Tutorial](../pantcl-tutorial.html)
#' 


proc filter-geasy {cont dict} {
    # count all code chunk filters
    global n
    incr n
    # default values for the code chunks attributes
    set def [dict create results show eval true scriptpath scripts \
             app graph-easy label null as ascii ext svg]
    # overwrite them with the current code chunk attributes         
    set dict [dict merge $def $dict]
    # if eval is false return nothing
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    # check if the application is installed at all
    if {[auto_execok [dict get $dict app]] eq ""} {
        return [list "Error: This filter requires the command line tool [dict get $dict app] - please install it!" ""]
    }
    # intialize return text
    set ret ""
    set owd [pwd]
        
    # create a filename for the outputs
    if {[dict get $dict label] eq "null"} {
        set fname [file join $owd [dict get $dict scriptpath] geasy-$n]
    } else {
        set fname [file join $owd [dict get $dict scriptpath] [dict get $dict label]]
    }
    if {![file exists [file join $owd [dict get $dict scriptpath]]]} {
        file mkdir [file join $owd [dict get $dict scriptpath]]
    }
    # write down the code chunk text
    set out [open $fname.txt w 0600]
    puts $out $cont
    close $out
    # run the tool
    # TODO: error catching
    set res [exec -ignorestderr [dict get $dict app] --as=[dict get $dict as] $fname.txt]
    # initialize the image variable
    set img ""
    # do the user like to use the dot tool for image generation?
    if {[dict get $dict as] eq "dot"} {
        set out [open $fname.dot w 0600] 
        puts $out $res
        close $out
        if {[auto_execok dot] eq ""} {
             return [list "Error: Dot output requires the command line tool GraphViz dot application - please install GraphViz or add the application sto your PATH variable!" ""]
        }  
        set ext [dict get $dict ext]
        exec -ignorestderr dot $fname.dot -T$ext -o $fname.$ext
        set img $fname.$ext
    }
    # check if results should be shown
    if {[dict get $dict results] eq "show"} {
        set res $res
    } else {
        set res ""
    }
    # return text and image path
    return [list $res $img]
}
