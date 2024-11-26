#' ---
#' title: "filter-julia.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2024-11-26 
#' julia:
#'     results: show
#'     eval: 1
#'     wait: 500
#' ---
#' 
#' ------
#' 
#' ```{.tcl eval=true results="asis" echo=false}
#' set t [clock seconds]
#' include header.md
#' ```
#' 
#' ------
#'
#' ## Name
#' 
#' _filter-julia.tcl_ - Filter which can be used to execute Julia code within code chunks (slow!). 
#' 
#' ## Usage
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pandoc input.md --filter pantcl.bin -s -o output.html
#' ```
#' 
#' The file `filter-julia.tcl` is not used directly but sourced automatically by the `pantcl.bin` file.
#' If code blocks with the `.julia` marker are found, the contents in the code block is processed via the 
#' julia interpreter, currently using pipes. Please note that Julia is quite slow at startup, plotting and pipe communication (although it seems that in 2024 it becomes much faster).
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - eval - should the code in the code block be evaluated, default: false (0)
#'   - echo - should the input code been shown, default: true
#'   - plotengine - the plot engine, default: pyplot
#'   - results - should the output of the command line application been shown, should be asis, show or hide, default: show
#'   - wait - the timeout (ms) after every code evaluation to wait for the pipe to
#'            read, try to decrease the time to get a speedup, increase of you
#'            observe output at wrong places, default: 100
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' to evaluate all Julia code chunks per default. Please note that you
#' should write `eval: 1` and not(!) `eval: true`
#' 
#' ```
#'  ----
#'  title: "filter-julia.tcl documentation"
#'  author: "Detlef Groth, University of Potsdam, Germany"
#'  date: 2023-05-24
#'  julia:
#'      eval: 1
#'      wait: 1000
#'  ----
#' ```
#'
#' ## Examples
#' 
#' ### Julia example
#' 
#' ```
#'      ```{.julia eval=true}  
#'      x=1;
#'      l = [1,2,3]
#'
#'      for i in l
#'        println(i)
#'      end
#'
#'      println(x+2);
#'      x=2
#'      ```
#' ```
#'
#' Here the output:
#'
#' ```{.julia eval=true}  
#' x=1;
#' l = [1,2,3]
#'
#' for i in l
#'    println(i)
#' end
#'
#' println(x+2);
#' x=2
#' ```
#' 
#' Now let's create an image try with PyPlot. Creating standard image plots with
#' `using Plots` is quite slow!! Around 20 seconds in 2023 but much faster in 2024!! Julia is probably a fast
#' calculator, but startup and plotting is not ... - chunk options `{.julia fig=true}`
#'
#' ```{.julia fig=true eval=true}
#' t1=time()
#' x = range(0, 1, length=30)
#' y = x .^ 2
#' plot(x, y,linewidth=5,color="salmon")
#' println(round(time()-t1),2)
#' ```
#'
#' Alternatively you can use the cmd-filter - chunk options `{.cmd eval=true file=test.jl}`:
#' 
#' ```{.cmd eval=true file=test.jl}
#' #!/usr/bin/env julia
#' println("Hello Julia World!")
#' ```
#' 
#' Here let's create a plot - chunk options `{.cmd eval=true file=test-plot.jl}`:
#'
#' ```{.cmd eval=true file=test-plot.jl}
#' #!/usr/bin/env julia
#' t1=time()
#' using Plots
#' x = range(0, 10, length=100)
#' y = sin.(x)
#' plot(x, y)
#' savefig("test-plot.png")
#' t2=time()
#' println("running time: ",round(t2-t1))
#' ```
#'
#' ![](test-plot.png)
#'
#'
#' Debugging:
#'
#' ```{.tcl eval=false}
#' puts "time for document compilation: [expr {[clock seconds] - $t}]"
#' ```
#'
#' ## TODO:
#' 
#' * terminal mode on/off
#' 
#' ## See also:
#' 
#' * [Pantcl Readme](../../README.html)
#' * [Tcl filter](../../pantcl.html)
#' * [Rplot filter](filter-rplot.html)
#' 

namespace eval ::jpipe {
    variable n 0
    variable pipecode ""
    variable jpipe ""    
    variable juliacode ""
    variable debug ""
    variable pengine ""
}

proc ::jpipe::piperead {pipe args} {
    variable debug
    if {![eof $pipe]} {
        set got [gets $pipe]
        append debug "got: $got"
        if {$got ne ""} {
            append ::jpipe::pipecode "$got\n" 
        }
    } elseif {[fblocked $pipe]} {
        # No output
        break
    } else {
        close $pipe
    }
}

proc ::jpipe::pipeputs {msg} {
    append ::jpipe::juliacode "\n$msg"
    puts $::jpipe::jpipe $msg
    flush $::jpipe::jpipe
}

# * trace add execution exit enter YourCleanupProc
proc ::jpipe::run-julia {args} {
    set out [open julia.jl w 0600]
    puts $out "$::jpipe::juliacode"
    close $out
    #exec julia --threads 1 2>@1 > julia.out
}

proc filter-julia {cont dict} {
    
    incr ::jpipe::n
    set ::jpipe::pipecode ""
    set def [dict create results show eval false label null imagepath images \
             include true terminal true wait 1000 fig false plotengine pyplot]
    set dict [dict merge $def $dict]
    set img ""
    if {[dict get $dict label] eq "null"} {
        dict set dict label jpipe-$::jpipe::n
    }
    append ::jpipe::debug "wait: [dict get $dict wait]"
    if {[dict get $dict eval]} {
        set wait [list]
        if {$::jpipe::jpipe eq ""} {
            set ::jpipe::debug ""
            set ::jpipe::jpipe [open "|julia 2>@1" r+]
            append ::jpipe::debug "running julia"
            fconfigure $::jpipe::jpipe -buffering none -blocking false
            fileevent $::jpipe::jpipe readable [list ::jpipe::piperead $::jpipe::jpipe]
            trace add execution exit enter ::jpipe::run-julia
            set ::jpipe::pipecode ""
        }
        if {[dict get $dict fig] && $::jpipe::pengine eq ""} {
            if {[dict get $dict plotengine] eq "pyplot"} {
                ::jpipe::pipeputs "using PyPlot;\nioff();"
                after 1000 [list append wait ""] 
            } elseif {[dict get $dict plotengine] eq "plots"} {
                ::jpipe::pipeputs "using Plots;"
                after 5000 [list append wait ""] 
            }
            vwait wait
            set ::jpipe::pengine [dict get $dict plotengine]
        }
        set term "julia> "
        foreach line [split $cont \n] {
            #  && [string range [dict get $dict pipe] 0 0] ne "R"
            if {[dict get $dict terminal]}  {
                append ::jpipe::pipecode "$term $line\n" 
            } 
            ::jpipe::pipeputs "$line"
            if {[regexp {^[^\s]} $line]} {
                # delay only if first letter is non-whitespace
                # to allow to flush output
                ::jpipe::pipeputs ""
                after [dict get $dict wait] [list append wait ""]
                vwait wait
            }
        }
        after [dict get $dict wait] [list append wait ""]
        vwait wait
        if {[dict get $dict fig]} {
            set img [file join [dict get $dict imagepath] [dict get $dict label].png]
            ::jpipe::pipeputs "savefig(\"$img\");\n"

        }
        after [dict get $dict wait] [list append wait ""]
        vwait wait
        set out [open julia-[dict get $dict label].jl w 0600]
        puts $out "$jpipe::juliacode"
        close $out
        after [dict get $dict wait] [list append wait ""]
        vwait wait
        set res $::jpipe::pipecode 
    } else {
        set res ""
    }
    if {!([dict get $dict results] in [list show asis])} {
        set res ""
    } 
    return [list $res $img]
}
