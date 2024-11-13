#' ---
#' title: "filter-pipe.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2023-05-24
#' pipe:
#'     results: show
#'     eval: 1
#'     wait: 100
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
#' _filter-pipe.tcl_ - Filter which can be used to execute various programming
#' languages using a pipe mechanism using the Tcl filter driver `pantcl.bin` and showing or hiding the output. 
#' 
#' ## Usage
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pandoc input.md --filter pantcl.bin -s -o output.html
#' ```
#' 
#' The file `filter-pipe.tcl` is not used directly but sourced automatically by the `pantcl.bin` file.
#' If code blocks with the `.pipe` marker are found, the contents in the code block is processed via
#' a shell pipe either using the python3, the Rscript or the octave command line application.
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - eval - should the code in the code block be evaluated, default: false/0
#'   - echo - should the input code been shown, default: true/1
#'   - pipe - the programming language to be used, either R, python, which is python3 or octave, default: python3
#'   - results - should the output of the command line application been shown, should be asis, show or hide, default: show
#'   - wait - the timeout (ms) after every code evaluation to wait for the pipe to
#'            read, try to decrease the time to get a speedup, increase of you
#'            observe output at wrong places, default: 100
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' default pipe command to R and evaluate all code chunks. Please note that you
#' should write `eval: 1` and not(!) `eval: true`
#' 
#' ```
#'  ----
#'  title: "filter-pipe.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2022-01-12
#'  pipe:
#'      pipe: R
#'      eval: 1
#'  ----
#' ```
#'
#' ## Examples
#' 
#' ### Python examples
#' 
#' Here an example for very simple python code.
#' 
#' ```{.pipe pipe="python3" results="show" terminal=true}
#' x=1
#' print(x)
#' y=x+1
#' print(y)
#' ```
#' 
#' In contrast to the [.cmd filter](filter-cmd.html) the code chunks are
#' in the same session, so we can continue to add more Python code which knows about the existing variables from the session before.
#' 
#' Here an example declaring a function:
#' 
#' ```{.pipe pipe="python3" results="show" terminal=true}
#' def test (x):
#'     return(x+1)
#' 
#' print(test(y))
#' ```
#' 
#' We can as well omit the terminal mode by setting the chunk option "terminal to false". You will then only see the output.
#' 
#' ```{.pipe terminal=false}
#' def test2 (x):
#'     return(x+2)
#' 
#' print(test2(y))
#' ```
#' 
#' Let's finish the Python section with an image created with *matplotlib* (`{.pipe terminal=false results="hide"}`).
#' 
#' ```{.pipe terminal=false results="hide"}
#' import matplotlib.pyplot as plt
#'  
#' # frequencies
#' ages = [2,5,70,40,30,45,50,45,43,40,44,
#'         60,7,13,57,18,90,77,32,21,20,40]
#'  
#' # setting the ranges and no. of intervals
#' range = (0, 100)
#' bins = 10
#'  
#' # plotting a histogram
#' plt.hist(ages, bins, range, color = 'skyblue',
#'         histtype = 'bar', rwidth = 0.8)
#'  
#' # x-axis label
#' plt.xlabel('age')
#' # frequency label
#' plt.ylabel('No. of people')
#' # plot title
#' plt.title('My histogram')
#' 
#' # save the file
#' plt.savefig('images/pyhist.png')
#' ```
#' 
#' We then just display the image file using standard Markdown.
#'  
#' ![](images/pyhist.png)
#' 
#' There is as well the possibility to add inline Python code to display the values of variables or the output of short python commands here an example:
#' 
#' ```{.pipe pipe="python3"}
#' l = [1,2,3,4]
#' g = [1,2,3,4,5]
#' print(len(l))
#' ```
#' 
#' ```{.pipe pipe="python3"}
#' g.append(6)
#' print(len(g))
#' ```
#' 
#' Let's now display the length of the list g, g has a length 
#' of `py print(len(g));`!
#' 
#' Another trial: *py 3+2=* `py 3+2`? Should be five!
#' 
#' Let's finish with Python code containing an error:
#' 
#' ```{.pipe pipe="python3"}
#' y=3
#' # a type
#' print(y00)
#' ```
#' 
#' ### R examples
#' 
#' ```
#'      ```{.pipe pipe="R" results="show"}
#'      source("~/R/dlibs/chords.R")
#'      data(iris)
#'      png("images/testr.png")
#'      boxplot(iris$Sepal.Length ~ iris$Species,col=2:4)
#'      dev.off()
#'      print(2)
#'      1
#'      ```
#' ```
#' 

#' ```{.pipe pipe="R" results="show"}
#' source("~/R/dlibs/chords.R")
#' data(iris)
#' png("images/testr.png")
#' boxplot(iris$Sepal.Length ~ iris$Species,col=2:4)
#' dev.off()
#' print(2)
#' 1
#' ```
#' 
#' ![](images/testr.png)
#' 
#' Now a table example:
#' 
#' ```{.pipe pipe="R" results="asis"}
#' data(mtcars)
#' knitr::kable(head(mtcars[, 1:4]))
#' ```
#' 
#' The filter itself provides a litte R function, without the need
#' to install an additional library,`df2md`, to convert data frames
#' or matrices into Markdown tables. Here an example for its usage:
#' 
#' ```{.pipe pipe="R" results="asis"}
#' data(mtcars)
#' df2md(head(mtcars[, 1:4],n=4))
#' ```
#' 
#' You can as well hide the rownames or give a caption like this.
#' 
#' ```{.pipe pipe="R" results="asis"}
#' df2md(head(mtcars[, 1:4],n=4),rownames=FALSE,caption="**Table 1:** mtcars data")
#' ```
#' 
#' For matrices or data frames without row names or column names just the line
#' and columnnumbers will be displayed:
#' 
#' ```{.pipe pipe="R" results="asis"}
#' M=matrix(round(rnorm(100,mean=10),2),ncol=5)
#' df2md(head(M,n=6),caption="**Table 2:** Matrix example")
#' ```
#' 
#' There is as well the possibility to display inline R code. So for instance we can use the nrow function to 
#' get the number of cars in the dataset. Using code like this:
#' 
#' ```
#'     The mtchars dataset has `r nrow(mtcars)` cars!
#' ```
#' 
#' The mtchars dataset has `r nrow(mtcars)` cars!
#' 
#' Let's now simulate an R error:
#' 
#' ```{.pipe pipe="R"}
#' x=3+2
#' print(ls())
#' x
#' print(y)
#' 2+3
#' ```
#' 
#' ### Octave example
#' 
#' ```{.pipe pipe="oc"}  
#' x=1;
#' disp(x);
#' y=2;
#' disp(y);
#' ```
#' 
#' Now let's do a plot:
#' 
#' ```{.pipe pipe="octave"}
#' aux=figure('visible','off');
#' tx = ty = linspace (-8, 8, 41);
#' [xx, yy] = meshgrid (tx, ty);
#' r = sqrt (xx .^ 2 + yy .^ 2) + eps;
#' tz = sin (r) ./ r;
#' mesh (tx, ty, tz);
#' saveas(aux, 'images/mesh-octave.png', 'png');
#' ```
#' 
#' ![](images/mesh-octave.png)
#' 
#' What about inline code? What is the value of y? 
#' It should be `oc disp(y)`.  Hmm, not yet working.
#' 
#' ```{.pipe pipe="octave"}
#' z=x+y
#' disp(z)
#' ```
#' 
#' Let's now do an Octave error:
#' 
#' ```{.pipe pipe="octave"}
#' z
#' disp(k)
#' ```
#' 
#' ## TODO:
#' 
#' * support Python (done) - inline (done) - error catching (done)
#' * support R (done) - inline (done) - error catching (done)
#' * support Octave (done) - inline (not working) - error catching (done)
#' * support Julia??
#' * terminal mode on/off
#' 
#' ## See also:
#' 
#' * [Pantcl Readme](../../README.html)
#' * [Tcl filter](../../pantcl.html)
#' * [Rplot filter](filter-rplot.html)
#' 

namespace eval ::fpipe {
    variable n 0
    variable pipecode ""
    variable pypipe ""
    variable rpipe ""
    variable opipe ""
    variable show true
    #set n 0
    #set pipecode ""
}
proc piperead {pipe args} {
    if {![eof $pipe]} {
        set got [gets $pipe]
        if {$got ne "flush(stdout)"} {
            # not sure why python does this
            if {[regexp {^>>>} $got]} {
                append ::fpipe::pipecode [regsub {^.*>>> } "$got" ""]
            } else {
                # R and Octave
                if {[regexp "### SHOW OFF" $got]} {
                    set ::fpipe::show false
                } 
                if {$::fpipe::show && $got ni [list "" "> "]} {
                    append ::fpipe::pipecode "$got\n"
                }
                if {[regexp "### SHOW ON" $got]} {
                    set ::fpipe::show true
                }
            }
            
        }
    } else {
        close $pipe
    }
}


# TODO: 
# * namespace vars
# * cleanup pipes if blocking true
# * trace add execution exit enter YourCleanupProc

proc ::fpipe::filter-pipe-R-df2md {} {
    puts $::fpipe::rpipe {### SHOW OFF
        df2md <- function(df,caption='',rownames=TRUE) {
            cn <- colnames(df)
            if (is.null(cn[1])) {
                cn=as.character(1:ncol(df))
            }
            rn <- rownames(df)
            if (is.null(rn[1])) {
                rn=as.character(1:nrow(df))
            }
            if (rownames) {
                headr <- paste0(c("","", cn),  sep = "|", collapse='')
                sepr <- paste0(c('|', rep(paste0(c(rep('-',3), "|"), 
                                                 collapse=''),length(cn)+1)), collapse ='')
            } else {
                headr <- paste0(c("", cn),  sep = "|", collapse='')
                sepr <- paste0(c('|', rep(paste0(c(rep('-',3), "|"), 
                                                 collapse=''),length(cn))), collapse ='')
                
            }
            st <- "|"
            for (i in 1:nrow(df)){
                if (rownames) {
                    st <- paste0(st, "**",as.character(rn[i]), "**|", collapse='')
                }
                for(j in 1:ncol(df)){
                    if (j%%ncol(df) == 0) {
                        st <- paste0(st, as.character(df[i,j]), "|", 
                                     "\n", "" , "|", collapse = '')
                    } else {
                        st <- paste0(st, as.character(df[i,j]), "|", 
                                     collapse = '')
                    }
                }
            }
            fin <- paste0(c("\n \n ",headr, sepr, substr(st,1,nchar(st)-1)), collapse="\n")
            if (caption!='') {
                fin=paste0(fin,'\n',caption,'\n')
            }
            cat(fin)
        }
        lipsum <- function (type=1, paragraphs=1,lang="latin") {
           if (lang == "latin") {
               if (type == 1) {
                   lips=paste(rep("Lorem ipsum dolor sit amet, consectetur adipiscing elit,
                                  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                                  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
                                  nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
                                  reprehenderit in voluptate velit esse cillum dolore eu fugiat
                                  nulla pariatur. Excepteur sint occaecat cupidatat non proident,
                                  sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n",paragraphs),collapse="")
               } else if (type == 2) {
                   lips=paste(rep("Sed ut perspiciatis unde omnis iste natus error sit voluptatem
                                  accusantium doloremque laudantium, totam rem aperiam, eaque ipsa
                                  quae ab illo inventore veritatis et quasi architecto beatae vitae
                                  dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas
                                  sit aspernatur aut odit aut fugit, sed quia consequuntur magni
                                  dolores eos qui ratione voluptatem sequi nesciunt. Neque porro
                                  quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur,
                                  adipisci velit, sed quia non numquam eius modi tempora incidunt
                                  ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim
                                  ad minima veniam, quis nostrum exercitationem ullam corporis
                                  suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
                                  Quis autem vel eum iure reprehenderit qui in ea voluptate velit
                                  esse quam nihil molestiae consequatur, vel illum qui dolorem eum
                                  fugiat quo voluptas nulla pariatur?\n\n",paragraphs),collapse="")
               } else {
                 stop("only type 1 and 2 are supported")
              } 
           } else {
              stop("Only latin supported currently")
           }
           lips=gsub("  +", " ",lips)
           return(lips)
        }
        ### SHOW ON}
    flush $::fpipe::rpipe
}
proc filter-pipe {cont dict} {
    incr ::fpipe::n
    set ::fpipe::pipecode ""
    set def [dict create results show eval false label null \
             include true pipe python3 terminal true wait 100]
    set dict [dict merge $def $dict]
    if {[dict get $dict eval]} {
        if {$::fpipe::pypipe eq "" && [string range [dict get $dict pipe] 0 1] eq "py"} {
            set ::fpipe::pypipe [open "|python3 -qui 2>@1" r+]
            fconfigure $::fpipe::pypipe -buffering line -blocking false
            fileevent $::fpipe::pypipe readable [list piperead $::fpipe::pypipe]
        }
        if {$::fpipe::opipe eq "" && [string range [dict get $dict pipe] 0 1] eq "oc"} {
            set ::fpipe::opipe [open "|octave --interactive --no-gui --norc --silent 2>@1" r+]
            fconfigure $::fpipe::opipe -buffering none -blocking false
            fileevent $::fpipe::opipe readable [list piperead $::fpipe::opipe]
            puts $::fpipe::opipe {PS1("")}
            puts $::fpipe::opipe "page_screen_output(1);"
            puts $::fpipe::opipe "page_output_immediately(1);"
            puts $::fpipe::opipe "fflush(stdout)"
            flush $::fpipe::opipe
            after [dict get $dict wait] [list append wait ""]
            vwait wait
            set ::fpipe::pipecode ""
        }
        #  
        if {$::fpipe::rpipe eq "" && [string range [dict get $dict pipe] 0 0] eq "R"} {
            if {[auto_execok Rterm] != ""} {
                # Windows, MSYS
                set ::fpipe::rpipe [open "|Rterm -q --vanilla 2>@1" r+]
            } else {
                set ::fpipe::rpipe [open "|R -q --vanilla --interactive 2>@1" r+]
            }
            fconfigure $::fpipe::rpipe -buffering line -blocking false
            fileevent $::fpipe::rpipe readable [list piperead $::fpipe::rpipe]
            ::fpipe::filter-pipe-R-df2md
            
        }
        set wait [list]
        set term ">>>"
        if {[string range [dict get $dict pipe] 0 1] eq "oc"} {
            set term "octave>"
        }
        if {[string range [dict get $dict pipe] 0 0] ne "X"} {
            foreach line [split $cont \n] {
                #  && [string range [dict get $dict pipe] 0 0] ne "R"
                if {[dict get $dict terminal] && [string range [dict get $dict pipe] 0 1] in [list "py" "oc"]}  {
                    append ::fpipe::pipecode "$term $line\n" 
                
                }
                if {[string range [dict get $dict pipe] 0 1] eq "py"} {
                    puts $::fpipe::pypipe "$line"
                }
                if {[string range [dict get $dict pipe] 0 1] eq "oc"} {
                    puts $::fpipe::opipe "$line"
                    flush $::fpipe::opipe
                }
                if {[string range [dict get $dict pipe] 0 0] eq "R"} {
                    puts $::fpipe::rpipe "$line"
                    flush $::fpipe::rpipe
                }
                if {[regexp {^[^\s]} $line]} {
                    # delay only if first letter is non-whitespace
                    # to allow to flush output
                    after [dict get $dict wait] [list append wait ""]
                    vwait wait
                }
            }
        }
        after [dict get $dict wait] [list append wait ""]
        vwait wait
        set res $::fpipe::pipecode
    } else {
        set res ""
    }
    # TODO: dict app using
    if {!([dict get $dict results] in [list show asis])} {
        set res ""
    } 
    if {[dict get $dict results] eq "asis" && [string range [dict get $dict pipe] 0 0] in [list "R" "python"]} {
        set nres ""
        set res [regsub -- {\|\|---:} $res "|\n|---:"]
        foreach line [split $res \n] {
            ## not sure where this K comes from ...
            if {![regexp {^[+>]} $line] && ![regexp {^.\[K>} $line]} {
                append nres "$line\n"
            }
        }
        set res $nres
     } else {
        set res [regsub {^.\[K> } $res ""]
    }
    if {[dict get $dict results] in [list show asis] && [string range [dict get $dict pipe] 0 1] eq "oc"} {
        set nres ""
        set i 0
        foreach line [split $res \n] {
            if {![regexp {^.*ans = 0\s*$} $line] && ![regexp {^>\s*$} $line]} {
                append nres "$line\n"
            } elseif {$i == 2  && [regexp {^\s*$} $line]} {
                continue
            } else {
                set i 1
            }
            incr i
        }
        set res $nres
    }
    return [list $res ""]
}
