#' ---
#' title: "filter-julia.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2023-05-24 
#' julia:
#'     results: show
#'     eval: 1
#'     wait: 1000
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
#' julia interpreter, currently using pipes. Please note that Julia is slow at startup, plotting and pipe communication.
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
#' `using Plots` is much too slow!! Around 20 seconds!! Julia is probably a fast
#' calculator, but startup and plotting is not ... - chunk options `{.julia fig=true}`
#'
#' ```{.julia fig=true}
#' x = range(0, 1, length=30)
#' y = x .^ 2
#' plot(x, y,linewidth=5,color="salmon")
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
#' So plotting in Julia is extremly slow. Let's as well measure also the startup.
#' Here a little script which should produce the same plot.
#'
#' ```{.cmd eval=true file=julia-time.sh}
#' #!/usr/bin/env bash
#' start=`date +%s.%N`
#' ( 
#' cat << EOF
#' using Plots;
#' x = range(0, 10, length=100);
#' y = sin.(x);
#' plot(x, y);
#' savefig("images/julia-time.png");
#' EOF
#' ) | julia > /dev/null
#' end=`date +%s.%N`
#' echo $(printf "time: %.3f" $( echo "$end - $start" | bc -l ))
#' ```
#'
#' Let's compare this with R:
#'
#' ```{.cmd eval=true file=R-time.sh}
#' #!/usr/bin/env bash
#' start=`date +%s.%N`
#' ( 
#' cat << EOF
#' ```{.cmd eval=true file=test-plot.R}
#' x=seq(0,10,0.1)
#' y=sin(x)
#' png("images/R-time.png",width=900,height=600)
#' plot(x,y,type="l", xlab="time", ylab="Sine wave",col="blue",lwd=2)
#' grid()
#' dev.off()
#' ) | R > /dev/null
#' end=`date +%s.%N`
#' echo $(printf "time: %.3f" $( echo "$end - $start" | bc -l ))
#' ```
#'
#' ![](images/R-time.png)
#'
#'
#' So R is much faster!
#' 
#' And now an example with Gnuplot:
#'
#' ```{.cmd eval=true file=test-gnuplot.sh}
#' #!/usr/bin/env bash
#' start=`date +%s.%N`
#' ( 
#' cat << EOF
#' # Set the title for the graph.
#' set title "Gnuplot Sine against Phase"
#' 
#' # We want the graph to cover a full sine wave.
#' set xrange [0:6.28]
#' 
#' # Set the label for the X axis.
#' set xlabel "Phase (radians)"
#' # Unicode for pi
#' set xtics ("0" 0,"0.5\U+03C0" pi/2, "\U+03C0" pi, \
#' 	"1.5\U+03C0" 1.5*pi, "2\U+03C0" 2*pi)
#' 
#' # Draw a horizontal centreline.
#' set xzeroaxis
#' 
#' # Pure sine wave amplitude ranges from +1 to -1.
#' set yrange [-1:1]
#' 
#' # No tick-marks are needed for the Y-axis .
#' unset ytics
#' 
#' set terminal png 
#' set output 'images/test.png'
#' # Plot the curve.
#' plot sin(x)
#' 
#' EOF
#' 
#' ) | gnuplot
#' 
#' end=`date +%s.%N`
#' echo $(printf %.3f $( echo "$end - $start" | bc -l ))
#' ```
#'
#' ![](images/test.png)
#'
#' Debugging:
#'
#' ```{.tcl eval=true}
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
