#' ---
#' title: "filter-emf.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2023-04-15
#' emf:
#'     app: mec
#'     eval: 1
#' ---
#' 
# A simple pandoc filter using the the MicroEmacs Text Editor macro language.
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
#' _filter-emf.tcl_ - Filter which can be used to evaluate Macro code for the MicroEmacs
#' text editor within a Pandoc processed document using the Tcl filter driver `pantcl.tcl`. 
#' The command line mode version of the editor which usually called with the -n arguments
#' is required which can be ususally installed from the website 
#' [http://www.jasspa.com/zeroinst.html](http://www.jasspa.com/zeroinst.html).
#' 
#' ## Usage
#' 
#' MicroEmacs macro language source code is embedded into Markup languages like Markdown like this 
#' (remove the spaces at the beginning, they are here just for protecting the evaluation):
#' 
#' ```
#'      # code chunk defaults (must be in fact not given):
#'      ```{.emf eval=true echo=true}
#'      EMF code
#'      ```
#' ```
#' 
#' Where eval and echo are so called chunk options.
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pantcl input.md output.html  --pantcl-filter filter-emf.tcl --syntax-definition ../../xml/emf.xml -s
#' ```
#' The file `emf.xml` contains syntax highlighting code for the MicroEmacs macro files.
#' The application file *pantcl* which contains the Tcl filter and all other filters has to be placed in the PATH and the 
#' system has to support the Shebang, on Unix this is standard on Windows you need to use tools like Cygwin, Msys, 
#' Git-Bash or Cygwin (untested).  
#' 
#' The arguments after the output file and after the file `filter-emf.tcl` are delegated to pandoc.
#' 
#' If code blocks with the `.emf` marker are found, the contents in the code 
#' block is processed via the MicroEmacs text editor in command line mode.
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - app - the MicroEmacs application to be called, usually me, default: me
#'   - echo - should the EMF source code be shown, default: true
#'   - eval - should the code in the code block be evaluated, default: false
#'   - results - should the output of the command line application been shown, should be show or hide, default: hide
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' default application to an other MicroEmacs executable, an updated MicroEmacs from 2023:
#' You should set eval to 1 as shown as well below, the term true
#' might produce an error, so write `eval: 1`
#' 
#' ```
#'  ----
#'  title: "filter-emf.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2023-04-15
#'  abc:
#'      app: me23
#'      eval: 1
#'  ----
#' ```
#'
#' ## Examples
#' 
#' Here an example for a simple Hello World message chunk just contains  `{.emf eval=true}`:.
#' 
#' ```{.emf}
#' -1 ml-write "Hello MicroEmacs World!"
#' ```
#' 
#' The `-1` at the beginning ensures that we are writing to the terminal, this is required for the embedded code to be shown in our output document but not in the editor 
#' message line.
#'
#' Using the option `{.emf eval=true results="hide"}` the output of the command line tool can be hidden.
#' 
#' ```{.emf eval=true results="hide"}
#' -1 ml-write "Hello MicroEmacs World!"
#' ```
#'
#' Believe me, the code above was evaluated but the results is hidden
#' as we used `results="hide"` as code chunk option.
#'
#' Here a more extensive example:
#' 
#' ```{.emf results="show" echo=true eval=true}
#' ; semicolons start comments
#' ; $version is a system variable 
#' -1 ml-write &cat "This is MicroEmacs " &cat $version "!"
#' ; example for a loop using a global variable %x
#' set-variable %x 1
#' !while &less %x 10
#'    -1 ml-write &cat "x is " %x
#'    set-variable %x &inc %x 1
#' !done
#' ```
#' 
#' ## See also:
#' 
#' * [pantcl Readme](../README.html)
#' 


proc filter-emf {cont dict} {
    global n
    incr n
    set def [dict create results show eval true scriptpath scripts \
             app me label null]
    set dict [dict merge $def $dict]
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    if {[auto_execok [dict get $dict app]] eq ""} {
        return [list "Error: This filter requires the command line tool [dict get $dict app] - please install it!" ""]
    }
    set ret ""
    set owd [pwd] 
    if {[dict get $dict label] eq "null"} {
        set fname [file join $owd [dict get $dict scriptpath] emf-$n]
    } else {
        set fname [file join $owd [dict get $dict scriptpath] [dict get $dict label]]
    }
    if {![file exists [file join $owd [dict get $dict scriptpath]]]} {
        file mkdir [file join $owd [dict get $dict scriptpath]]
    }
    set out [open $fname.sh w 0600]
    puts $out "#!/usr/bin/bash\ntail --lines=+3 \$0 > temp.emf && [dict get $dict app] -n -p \"@temp.emf\" && exit"
    puts $out "; - emf - below follows the MicroEmacs code"
    puts $out "define-macro test-emf"
    puts $out $cont
    puts $out "!emacro"
    puts $out "!force test-emf"
    puts $out "!if &not \$status"
    puts $out "    -1 ml-write \"Error in code chunk!\""
    puts $out "!endif"
    puts $out "quick-exit"
    close $out
    # TODO: error catching
    set res [exec -ignorestderr bash $fname.sh]
    if {[dict get $dict results] eq "show"} {
        # should be usually empty
        set res $res
    } else {
        set res ""
    }
    return [list $res ""]
}
