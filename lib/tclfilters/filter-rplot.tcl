#' ---
#' title: "filter-rplot.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2021-11-29
#' rplot:
#'     app: Rscript
#'     imagepath: figures
#'     ext: png
#'     eval: 1
#' ---
#' 
#' ------
#' 
#' ```{.tcl eval=true results="asis" echo=false}
#' include header.md
#' ```
#' 
#' ------
#'
#' ## Name
#' 
#' _filter-rplot.tcl_ - Filter which can be used to display R plots
#'  within a Pandoc processed document using the Tcl filter driver 
#' `pantcl.bin`. 
#' 
#' ## Usage
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pandoc input.md --filter pantcl.bin -s -o output.html
#' ```
#' 
#' The file `filter-rplot.tcl` is not used directly but sourced automatically by the `pantcl.bin` file.
#' If code blocks with the `.rplot` marker are found, the contents in the code block is 
#' processed via the Rscript interpreter if the chunk option `eval` is set to true or 1. 
#' If the interpreter is not in the PATH you might add the application path in your YAML header as shown below.
#' 
#' 
#' The following options can be given via code chunks options or as defaults in the YAML header.
#' 
#' > - app - the application to be called, default: Rscript
#'   - eval - should the code in the code block be evaluated, default: false
#'   - ext - file file extension, can be png or pdf, default: png
#'   - fig - should a figure be created, default: true
#'   - height - the figure height, default: 600
#'   - imagepath - output imagepath, default: images
#'   - include - should the created image be automatically included, default: true
#'   - label - the code chunk label used as well for the image name, default: null
#'   - results - should the output of the command line application been shown, should be show or hide, default: hide
#'   - width - the figure width, default: 600
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' default Rscript interpreter, the image output path to nfigures and the file extension to pdf 
#' (useful for Pdf output of the document).
#' Please note that in the YAML header you can only use 0 or 1 instead of false
#' and true.
#' 
#' ```
#'  ----
#'  title: "filter-rplot.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2021-11-29
#'  rplot:
#'      app: /path/to/Rscript
#'      imagepath: nfigures
#'      ext: pdf
#'      eval: 1
#'  ----
#' ```
#'
#' ## Examples
#' 
#' Here an example for a pairsplot  graph:
#' 
#' ```
#'      ```{.rplot eval=true}
#'      data(iris)
#'      pairs(iris[,1:3],col=as.numeric(iris$Species)+1,pch=19)
#'      ```
#' ```
#' 
#' And here is the output:
#' 
#' ```{.rplot eval=true}
#' data(iris)
#' pairs(iris[,1:3],col=as.numeric(iris$Species)+1,pch=19)
#' ```
#' 
#' To supress the message line you can add results="hide" as chunk option like this: `{.rplot results="hide"}`
#' 
#' ```{.rplot eval=true results="hide"}
#' boxplot(iris$Sepal.Length ~ iris$Species,col=2:4)
#' ```
#' 
#' ## See also:
#' 
#' * [pantcl Readme](../../README.html)
#' * [Pipe filter for R, Python, Octave](filter-pipe.html)
#' 


proc filter-rplot {cont dict} {
    global n
    global rplotx
    if {[info exists rplotx]} {
        incr rplotx
    } else {
        set rplotx 0
    }
    incr n
    set def [dict create results show eval true fig true width 600 height 600 \
             include true imagepath images app Rscript label null ext png]
    set dict [dict merge $def $dict]
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    set ret ""
    set owd [pwd] 
    if {[dict get $dict label] eq "null"} {
        set fname [file join $owd [dict get $dict imagepath] rplot-$n]
    } else {
        set fname [file join $owd [dict get $dict imagepath] [dict get $dict label]]
    }
    if {![file exists [file join $owd [dict get $dict imagepath]]]} {
        file mkdir [file join $owd [dict get $dict imagepath]]
    }
    set out [open ${fname}.R w 0600]
    if {$rplotx == 0} {
        if {[file exists ".RData"]} {
            file delete .RData
        }
    }
    if {[file exists .RData]} {
        puts $out "load('.RData')"
    }
    if {[dict get $dict fig]} {
        set imgfile ${fname}.[dict get $dict ext]
        puts $out "[dict get $dict ext]('$imgfile' , width=[dict get $dict width] , height=[dict get $dict height]);"
        puts $out $cont
        puts $out "dev.off()"
    } else {
        puts $out $cont
    }
    puts $out "save.image(file='.RData')"
    close $out
    # TODO: error catching
    if {[dict get $dict eval]} {
        set res [exec [dict get $dict app] ${fname}.R]
    } else {
        set res ""
    }
    if {[dict get $dict results] eq "show"} {
        set res $res
    } else {
        set res ""
    }
    set img ""
    if {[dict get $dict fig]} {
        if {[dict get $dict include]} {
            set img $imgfile
        }
    }
    return [list $res $img]
}
