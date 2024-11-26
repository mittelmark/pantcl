#' ---
#' title: "filter-cmd.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2022-01-15
#' cmd:
#'     results: show
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
#' _filter-cmd.tcl_ - Filter which can be used to execute terminal
#' applications using the Tcl filter driver `pantcl.bin` and showing or hiding the output. 
#' 
#' ## Usage
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pandoc input.md --filter pantcl.bin -s -o output.html
#' ```
#' 
#' The file `filter-cmd.tcl` is not used directly but sourced automatically by the `pantcl.bin` file.
#' If code blocks with the `.cmd` marker are found, the contents in the code block is processed via standard
#' shell as command line application.
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - cachedir - directory where the files should be stored, default to
#'     `~/.config/pantcl` on Unix systems and  `AppData/Local/pantcl` on
#'     Windows, set to a . (dot) to place the files in the current working directory
#'   - eval - should the code in the code block be evaluated, default: false
#'   - file - the output filename for the code which will be executed using the given shebang line on top, if not given, code will be evaluated line by line, default: null
#'   - results - should the output of the command line application been shown, should be asis, show or hide, default: show
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' default results option to hide.
#' 
#' ```
#'  ----
#'  title: "filter-cmd.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2024-07-23
#'  cmd:
#'      results: hide
#'      eval: 1
#'  ----
#' ```
#'
#' The option 'eval: 1' is required to activate code evaluation in the code
#' chunks for all chunks of type `.cmd`. You can also set this option for every
#' code chunk separately
#' 
#' ## Examples
#' 
#' ### Line by line commands
#' 
#' Here an example for executing the `ls` command on a Unix system for all Tcl files in the current folder:.
#' 
#' ```
#'     ```{.cmd results="show" eval=true}
#'     ls -l *.tcl
#'     ```
#' ```
#' 
#' Please remove the spaces at the beginning, they are just used to avoid the 
#' the code evaluation here. Code chunk options will be given in parenthesis like this
#' (chunk options: `{.cmd results="show"}`) to explain them if necessary. 
#' Below now the output of the code block above:
#' 
#' ```{.cmd results="show"}
#' ls -l *.tcl
#' ```
#' 
#' Here an example to execute the sqlite3 command line application with the 
#' option of Markdown output, using the chunk option `results="asis"` 
#' we can directly embed the result of the created Markdown table 
#' (chunk options: `{.cmd results="asis" eval=true}`).
#' 
#' ```{.cmd results="asis" eval=true}
#' sqlite3 -markdown uni.sqlite "select * from Student limit 5"
#' ```
#' 
#' Let's now demonstrate a more extended example where we first create a 
#' script which can create image buttons. The script uses [PlantUML](https://plantuml.com)  and looks like this:
#' 
#' 
#' ```
#' #!/bin/sh
#' ## file ~/bin/hwbutton.sh
#' if [ -z $2 ] ; then
#'     echo "Usage: hwbutton.sh 'rectangle \" title \" color'" outfile.png
#'     exit
#' fi
#' echo "@startuml" > temp.uml
#' echo "skinparam handwritten true" >> temp.uml
#' echo "<style> " >> temp.uml
#' echo "rectangle { " >> temp.uml
#' echo "    FontSize 20" >> temp.uml
#' echo "    FontStyle bold" >> temp.uml
#' echo "    FontName Purisa" >> temp.uml  
#' echo "}" >> temp.uml
#' echo "</style>" >> temp.uml
#' echo $1 >> temp.uml
#' echo "@enduml" >> temp.uml
#' plantuml -o out temp.uml 
#' mv out/temp.png $2
#' ```
#' 
#' Let's save this script as an executable shell script hwbutton.sh in 
#' a directory belonging to our PATH. We can thereafter create a few image buttons
#' in one go (`{.cmd results="hide"}`):
#' 
#' ```{.cmd results="hide"}
#' hwbutton.sh 'rectangle "  Bob   " #ccddee' hw-bob.png 
#' hwbutton.sh 'rectangle " Alice  " #eeddcc' hw-alice.png
#' hwbutton.sh 'rectangle " <i>E=mc<sup>2</sup></i> " #ffaaaa' hw-emc2.png
#' ```
#' 
#' So we created three png files in this directory (`{.cmd}`):
#' 
#' ```{.cmd eval=true}
#' ls -l hw-*png
#' ```
#' 
#' Let's now display these images side by side using standard Markdown syntax:
#' 
#' ![](hw-bob.png) ![](hw-alice.png) ![](hw-emc2.png)
#' 
#' BTW: The application *plantuml* is a shell script which looks like this:
#' 
#' ```
#' #!/bin/sh
#' java -jar /home/username/.local/bin/plantuml-1.2021.16.jar $@
#' ```
#'  
#' ## Standalone scripts
#' 
#' ### Python scripts
#' 
#' The chunk option *file* allows us as well to embed code for other programming languages
#' and interpret them. Here an example to execute a Python script.
#' 
#' ```
#'      ```{.cmd file="sample.py" eval=true}
#'      #!/usr/bin/env python3
#'      import sys
#'      print ("Hello Python World!")
#'      print (sys.version)
#'      ```
#' ```
#' 
#' This is the output:
#' 
#' ```{.cmd file="sample.py"}
#' #!/usr/bin/env python3
#' import sys
#' print ("Hello Python World!")
#' print (sys.version)
#' ```
#' 
#' ### Gnu Octave scripts
#' 
#' As usually using the code chunk option `echo=false` you can hide the Python code and only show the output.
#' Here an Octave script which does a little plot:
#' 
#' ```
#'     ```{.cmd file="sample.m" eval=true}
#'     #!/usr/bin/env octave
#'     x = -10:0.1:10;
#'     aux=figure('visible','off');
#'     plot (x, sin (x));
#'     saveas(aux, 'octave.png', 'png');
#'     ```
#' ```
#' 
#' And again here its output:
#' 
#' ```{.cmd file="sample.m"}
#' #!/usr/bin/env octave
#' x = -10:0.1:10;
#' aux=figure('visible','off');
#' plot (x, sin (x));
#' saveas(aux, 'octave.png', 'png');
#' ```
#' 
#' ![](octave.png)
#' 
#' To reuse functions etc you can source the created source code files 
#' into subsequent code blocks.
#' 
#' ### R scripts
#' 
#' Now an example for an R-script and how functions created in one code 
#' chunk can be reused in an other code chunk.
#' 
#' ```
#'     ```{.cmd file="plot.R" eval=false results=hide cachedir="."}
#'     #!/usr/bin/env/Rscript
#'     doPlot = function (x,y,pch=19,col="red",...) {
#'        plot(y~x,pch=pch,col=col,...)
#'     }
#'     ```
#' ```
#' 
#' This is the output, just code display:
#' 
#' ```{.cmd file="plot.R" eval=true results=hide cachedir="."}
#' #!/usr/bin/env Rscript
#' doPlot = function (x,y,pch=19,col="red",...) {
#'    plot(y~x,pch=pch,col=col,...)
#' }
#' ```
#' 
#' In the next chunk we use this function by sourcing the file.
#' 
#' ```
#'     ```{.cmd file="doplot.R" results="hide" eval=true cachdir="."}
#'     #!/usr/bin/env Rscript
#'     source('plot.R') # file was created in the previous chunk.
#'     x=seq(0,8,by=0.1)
#'     y=sin(x)
#'     y=y+rnorm(length(y),sd=0.1)
#'     png("plotR.png")
#'     doPlot(x,y)
#'     dev.off()
#'     ```
#' ```
#' 
#' And here the output:
#' 
#' ```{.cmd file="doplot.R" results="hide" cachedir="."}
#' #!/usr/bin/env Rscript
#' source('plot.R') # file was created in the previous chunk.
#' set.seed(123)
#' x=seq(0,8,by=0.1)
#' y=sin(x)
#' y=y+rnorm(length(y),sd=0.1)
#' png("plotR.png",width=900,height=600)
#' par(mfrow=c(1,2))
#' doPlot(x,sin(x),main="y=sin(x)")
#' doPlot(x,y,main="y=sin(x)+noise")
#' dev.off()
#' ```
#' 
#' ![](plotR.png)
#' 
#' There is as well a separate filter for R called *rplot*, see [filter-rplot.html](filter-rplot.html). 
#' This filter supports as well session management, so that separate code chunks share the same 
#' R-session and syntax highlighting.
#' 
#' ### Gnuplot scripts
#' 
#' Next a Gnuplot script (`{.cmd file="sin.gp" eval=true}`):
#' 
#' ```{.cmd file="sin.gp"}
#' #!/usr/bin/env gnuplot
#' # Set the output to a png file
#' set terminal png size 800,500
#' # The file we'll write to
#' set output 'sin-gp.png'
#' # The graphic title
#' set title 'sin(x) - Gnuplot'
#' #plot the graphic
#' plot sin(x)
#' ```
#' 
#' ![](sin-gp.png)
#' 
#' ### Lua Scripts
#'
#' Here a short Lua code example ({.cmd file="factorial.lua" eval=true}):
#'
#' ```{.cmd file="factorial.lua" eval=true}
#' #!/usr/bin/env lua
#' -- defines a factorial function
#' function fact (n)
#'     if n == 0 then
#'         return 1
#'     else
#'         return n * fact(n-1)
#'     end
#' end
#' print(fact(5))
#' ```
#'
#' ### GraphViz dot scripts
#' 
#' Here an example for a standalone dot-script (`{.cmd file="digraph.dot" eval=true}`): 
#' 
#' ```{.cmd file="digraph.dot"}
#' #!/usr/bin/env -S dot -Tpng -odot.png
#' digraph G {
#'   node[style=filled,fillcolor=skyblue];
#'   A -> B ;
#' }
#' ```
#' 
#' And now an example doing plots with Gnuplot:
#'
#' ```{.cmd eval=false file=test-gnuplot.sh}
#' #!/usr/bin/env gnuplot
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
#' ```
#' 
#'
#' ![](images/test.png)

#' ![](dot.png)
#' 
#' ### Simple shell scripts
#' 
#' First a mathematical calculation (`{.cmd file="calc.sh" eval=true}`):
#' 
#' ```{.cmd file="calc.sh"}
#' #!/bin/sh
#' x=6
#' y=7
#' echo $(($x+$y))
#' ```
#' 
#' Then a mathematical equation (`{.cmd file="math.eqn" eval=true}`):
#' 
#' ```{.cmd file="math.eqn"}
#' #!/bin/sh
#' echo "x = {-b +- sqrt{b sup 2 - 4ac}} over 2a" \
#'       | eqn2graph -colorspace RGB -density 144 > eqn.png
#' ```
#' 
#' ![](eqn.png)
#' 
#' And here let's use this for the formula of the most important biochemical
#' reaction on planet Earth (`{.cmd file="photo.eqn" eval=true}`):
#' 
#' ```{.cmd file="photo.eqn"}
#' #!/bin/sh
#' echo "6H sub 2 O + 6CO sub 2 + Light -> C sub 6 H sub 12 O sub 6 + 6 O sub 2" \
#'       | eqn2graph -colorspace RGB -density 144 > photo.png
#' ```
#' 
#' Afterwards you can embed the png image using your Markdown code.
#' 
#' ![](photo.png)
#' 
#' For more information on how to typeset equations using the EQN syntax have a look here: 
#' [https://www.oreilly.com/library/view/unix-text-processing/9780810462915/Chapter09.html](https://www.oreilly.com/library/view/unix-text-processing/9780810462915/Chapter09.html).
#'
#' ### Lilypond example
#' 
#' A typical problem are programming languages which do not support the shebang line. 
#' We can create for such languages a wrapper script which pipe the input of a script but not the very first 
#' line into the interpreter. Here an example for the lilypond interpreter, 
#'  a tool to process music notation. Here the wrapper script:
#' 
#' ```
#' #!/usr/bin/env bash
#' # file: lilyscript.sh
#' if [ -z $2 ]; then
#'     out=out.svg
#'     ext=svg
#' else
#'     out=$2
#'     ext=${out##*.}
#'     out=`basename $out .$ext`
#' fi
#' # echo all lines bit not the shebang line and 
#' # pipe this into lilypond
#' # crop page
#' echo "
#' \version \"2.14.1\"
#' " > temp.ly
#' perl -ne '$x++ >= 1 and print' $1 >> temp.ly
#' echo "
#' \paper {
#'   indent = 0\mm
#'   line-width = 110\mm
#'   oddHeaderMarkup = \"\"
#'   evenHeaderMarkup = \"\"
#'   oddFooterMarkup = \"\"
#'   evenFooterMarkup = \"\"
#' }
#' \header { tagline = \"\" }
#' " >> temp.ly
#' lilypond --$ext --output=$out  temp.ly
#' if [ -e "$out-systems.texi" ]; then
#'      rm $out-* 
#' fi     
#' # EOF
#' ```
#' 
#' If we copy this file as lilyscript.sh into a folder belonging to our PATH variable we 
#' can then embed lilypond code into a executable script easily.
#' Here an example (chunk options are: 
#' `{.cmd file="mini.ly" results="hide" eval=true cachdir="."}`):
#' 
#' **Please note** that this script above creates a few intermediate files, so you need
#' to set the cachedir usually to the current folder by adding the option
#' **`cachedir="."`** to your code chunk to get this working.
#'
#' ```{.cmd file="mini.ly" results="hide" cachedir="."}
#' #!/usr/bin/env -S lilyscript.sh mini.ly mini.svg
#' #(set! paper-alist
#'   (cons '("my size" . (cons (* 3 in) (* 0.8 in))) paper-alist))
#' \paper {  #(set-paper-size "my size") }
#' {
#'   % middle tie looks funny here:
#'   <c' d'' b''>8. ~ <c' d'' b''>8
#' }
#' ```
#' 
#' We then embed the image using Markdown syntax. Using the border-style we can
#' as well adapt the width and height of the paper size see if required if we
#' add nore notes later:
#' 
#' ```
#' ![](mini.svg){#id width=240 style="border: 3px solid #ddd;"}
#' ```
#' 
#' Gives:
#' 
#' ![](mini.svg){#id width=240 style="border: 3px solid #ddd;"}
#'
#' Here an example for a PNG image with the settings
#' `{.cmd file="mini2.ly" results="hide" cachedir="."}`.
#' 
#' ```{.cmd file="mini2.ly" results="hide" cachedir="."}
#' #!/usr/bin/env -S lilyscript.sh mini2.ly mini2.png
#' #(set! paper-alist
#'   (cons '("my size" . (cons (* 3 in) (* 0.8 in))) paper-alist))
#' \paper {  #(set-paper-size "my size") }
#' {
#'   % middle tie looks funny here:
#'   <c' d'' b''>8. ~ <c' d'' b''>8
#' }
#' ```
#' 
#' We again include the created image using standard Markdown syntax with setting
#' as well a width to scale the image (`![](mini2.png){#id width=240}`):
#' 
#' ![](mini2.png){#id width=240}
#'
#' ### Text Editors
#' 
#' Some text editors like [Jasspa MicroEmacs](http://www.jasspa.com) can be as well used for using non-interactive at the command line. Here an example for this nice text editor.
#' 
#' ```{.cmd file="me-sample.emf"}
#' #!/usr/bin/bash
#' tail --lines=+3 $0 > temp.emf && me -n -p "@temp.emf" && exit
#' ; below follows the MicroEmacs code
#' -1 ml-write "Hello Jasspa MicroEmacs World!"
#' -1 ml-write &cat "This is MicroEmacs " &cat $version "!"
#' set-variable %x 1
#' !while &less %x 10
#'     -1 ml-write &cat "x is " %x
#'     set-variable %x &inc %x 1
#' !done
#' quick-exit
#' ```
#' 
#' ### C and C++ code
#' 
#' Using the approach with the lilypond examples we can as well embed C code by creating a wrapper for the compiler.
#' Here we are usinfusing a pseudo- shebang line (`{.cmd file="hello2.c" eval=true}`):
#'  
#' ```{.cmd file="hello2.c"}
#' ///usr/bin/cc -o "${0%.c}" "$0" -lm && exec "${0%.c}"
#' 
#' #include <stdio.h>
#' #include <math.h>
#' 
#' int main (int argc, char** argv) {
#'     printf("Hello C Compiler World!\n");
#'     float pi = 3.141492653;
#'     printf("pi is: %f\n",pi);
#'     printf("sin(pi) is: %f\n",sin(pi));
#'     return(0);
#' }
#' ```
#' 
#' The same mechanism can be used for C++ code ({.cmd file="hello.cxx"}):
#' 
#' ```{.cmd file="hello.cxx"}
#' ///usr/bin/g++ -o "${0%.cxx}" "$0" && exec "${0%.cxx}"
#' #include <iostream> 
#' 
#' int main(int argc, char** argv) {
#'   using namespace std;
#'   int ret = 0;
#'   cout << "Hello C++ World!" << endl;
#'   return ret;
#' } 
#' ```
#'
#' Please take care that you need to use the same file extension in your shebang
#' line  and for your file argument, if your file ends in `cpp` as well your
#' shebang has to use not `cxx` but `cpp` in the first line, the compiler line.
#'
#' Sometimes your code required other files in the same directory or in files being
#' in relative order to the current source code, for instance if you include local
#' header files. In this case you should set the `cachedir` property to a `.` (dot) 
#' to indicate the current working directory. Here an example using the `[popl.h](https://github.com/badaix/popl)` 
#' argument parsing library.
#' 
#' ```{.cmd file="poplex.cxx",cachdir="."}
#' ///usr/bin/g++ -o "${0%.cxx}" -I. "$0" && exec "${0%.cxx}"
#' #include <iostream>
#' #include "include/popl.hpp"
#' 
#' void usage (char * appname) {
#'     std::cout << "Usage: " << appname << " [-h, --help | -v, --verbose | -r, --rounding int]\n";
#' }
#' int main (int argc, char * argv[]) {
#'     popl::OptionParser app(
#'           "popl application\nUsage: poplex [options] number\nOptions");
#'     auto help   = app.add<popl::Switch>("h", "help",
#'           "produce help message");
#'     auto verbose   = app.add<popl::Switch>("v", "verbose",
#'           "set verbose on");
#'     auto round = app.add<popl::Value<int>>("r", "round", 
#'           "rounding digits",2);
#'     if (argc == 1) { 
#'         usage(argv[0]); 
#'         return(0);
#'     }
#'     app.parse(argc, argv); 
#'     // print auto-generated help message
#'     if (help->is_set()) {
#'         std::cout << app << "\n";
#'         return(0);
#'     } else if (verbose->is_set()) {
#'         std::cout << "verbose is on\n";
#'     }
#'     return(0);
#' }
#' ```
#' 
#' ## Go, Rust and Vlang
#'
#' Here an example for the Go language (`{.cmd file="hello.go"}`):
#'
#' On Fedora I had to install Go with `sudo dnf install golang`.
#' 
#' ```{.cmd file="hello.go"}
#' ///usr/bin/go run $0 $@  2>&1 && exit 0
#' package main
#' 
#' func main() {
#'     println("Hello Go World!")
#' }
#' ```
#' 
#' Next try is Rust (`{.cmd file="hello-rust.rs"}`), as there is no `run` for
#' rust we need to compile and then to execute the file as in C/C++.
#' On Fedora I had to install Go with `sudo dnf install rust`. 
#'
#'
#' ```{.cmd file="hello-rust.rs"}
#' ///usr/bin/rustc $0 $@  -o ${0%.rs} 2>&1 && exec "${0%.rs}" && exit 0
#' fn main () {
#'   println!("Hello Rust World in 2024!")
#' }
#' ```
#'
#' Now the new programming language [Vlang](https://vlang.io/) (V) (`{.cmd file="hello.v"}`):
#' 
#' ```{.cmd file="hello.v"}
#' ///usr/local/bin/v run $0 $@  2>&1 && exit 0
#' fn main () {
#'   println("Hello V World in 2024!")
#' }
#' ```
#'
#' And now the Java Programming language:
#'
#' ```{.cmd file="hello-java.java"}
#' ////usr/bin/javac $0 $@ 2>&1 && exec java -cp . HelloWorld && exit 0
#' class HelloWorld {
#'    public static void main(String[] args) {
#'        System.out.println("Hello, World!"); 
#'    }
#' }
#' ```
#'
#' ### Other programming languages
#' 
#' I left it as an exercise to embed Perl, Ruby, Julia scripts using the standard Shebang mechanism. 
#' 
#' 
#' ## See also:
#' 
#' * [Pantcl Readme](../../README.html)
#' * [Pantcl docu](../../pantcl.html)
#' * [Pantcl tutorial](../../pantcl-tutorial.html)
#' * [Abc filter](filter-abc.html)
#' * [GraphViz dot filter](filter-dot.html)
#' * [Rplot filter](filter-rplot.html)
#' * [Pipe filter for Python, R, Octave](filter-pipe.html)
#' 


proc filter-cmd {cont dict} {
    global n
    incr n
    set def [dict create results asis eval true label null file null \
             include true app sh cachedir [pantcl::getCacheDir]]
    # TODO: dict app using
    ## fixing , issues in dict and TRUE==true etc
    if {$dict ne ""} {
        set d [regsub -nocase -all FALSE $dict false]
        set d [regsub -nocase -all TRUE  $d    true]
        set d [regsub -nocase -all ,     $d    " "]
        set d [regsub -nocase -all =     $d    " "]  ;#
        set d [regsub -nocase -all {\\"} $d    ""]   ;#"
        set dict [dict create {*}$d]
    }
    dict for {key value} $dict {
        if {[regexp {,.+=} $value]} {
            set val [regsub {,.+} $value ""]
            set rest [regsub {.+?,} $value ""]
        }
    }
    set dict [dict merge $def $dict]
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    set res ""
    if {[dict get $dict file] eq "null"} {
        if {[dict get $dict eval]} {
            foreach line [split $cont "\n"] {
                if { [ catch {set resl [exec echo $line | sh] } ] } {
                    append res "Error in line `$line`\n"
                } else {
                    append res "$resl\n"
                }
            }
        }
    } else {
        #puts stderr $cont
        set out [open [file join [dict get $dict cachedir] [dict get $dict file]] w 0755]
        puts $out $cont
        close $out
        if {[dict get $dict eval]} {
            if {[catch { set res [exec [file join [dict get $dict cachedir] [dict get $dict file]]] }] } {
                set res $::errorInfo
            } 
        }
    }
    if {!([dict get $dict results] in [list show asis])} {
        set res ""
    }
    return [list $res ""]
}
