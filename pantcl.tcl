#!/usr/bin/env tclsh
# pantcl - standalone application and pandoc filter
#          for literate programming
# Author: Detlef Groth, Schwielowsee, Germany
# Version: 0.9.12 - 2023-04-17
# Version: 0.9.13 - 2023-09-07
# Version: 0.9.14 - 2024-11-13 - line filter with single backtick eval for R

package provide pantcl 0.9.14
namespace eval ::pantcl { }

if {[llength $argv] > 0 && ([lsearch -exact $argv -v] >= 0 || [lsearch -exact $argv --version] >= 0)} {
    puts "[package present pantcl]"
    exit 0
}   
if {[llength $argv] > 0 && ([lsearch -regex $argv {-h$}] >= 0 || [lsearch -regex $argv {--help$}] >= 0)} {
    puts {Usage (filter):    pandoc [pandoc arguments] --filter $argv0 [pandoc arguments]
        
      This is the pandoc Tcl filter which should be run as filter for the pandoc document
      converter with a syntax like shown above.  This filter allows you to embed Tcl code 
      and other tools code within Markdown and other Text format documents. 
      For a list of filters which are available see below.
    } 
    puts "Filters: \n"
    puts "       - ```{.abc}    ABC music notation code```"    
    puts "       - ```{.cmd}    Command line application code```"        
    puts "       - ```{.dot}    GraphViz dot/neato code```"
    puts "       - ```{.emf}    MicroEmacs macro code```"    
    puts "       - ```{.eqn}    EQN equations```"    
    puts "       - ```{.julia}  Julia code```"        
    puts "       - ```{.mmd}    Mermaid diagram code```"            
    puts "       - ```{.mtex}   LaTeX equations```"        
    puts "       - ```{.pic}    PIC diagram code```"        
    puts "       - ```{.pik}    Pikchr diagram code```"
    puts "       - ```{.pipe}   Embed Python, R or Octave code```" 
    puts "       - ```{.puml}   PlantUML diagram code```"    
    puts "       - ```{.rplot}  R plot code```"    
    puts "       - ```{.sqlite} SQLite3 code code```"
    puts "       - ```{.tcl}    Tcl code```"
    puts "       - ```{.tcrd}   Songs with embedded chords```"        
    puts "       - ```{.tdot}   Tcl package tdot code```"    
    puts "       - ```{.tsvg}   Tcl package tsvg code```\n"
    
    puts "Usage (standalone): $argv0 \[arguments] infile outfile"
    puts {      
        Converting the given infile to outfile.
        If infile is a source code file ending with.tcl or .py, it is assumed that it
        contains mkdoc documentation. This is embedded Markdown markup after 
        a #' comment. In case pandoc is installed the pantcl application will 
        will be used as filter afterwards.

        Arguments:
    }
    puts "         $argv0 --help                     - display this help page"
    puts "         $argv0 --version                  - display the version"
    puts "         $argv0 infile outfile --no-pandoc - use the standalone converter"
    puts "         $argv0 infile outfile --tangle .tcl - extract all code from .tcl chunks"
    puts "\nUsage (GUI): $argv0 --gui \[infile]\n"
    puts "        Supported infiles: abc, dot, eqn, mmd, mtex, pic, pik, puml, rplot, tdot, tsvg\n"
    puts "Examples:\n"
    puts "         $argv0 pantcl.tcl pantcl.html -s --css mini.css\n"
    puts "         will extract the documentation from the file pantcl.tcl itself"
    puts "         and create a HTML file executing all filters available."
    puts "         All usual pandoc options can be passed after the output file name.\n" 
    puts "         $argv0 --no-pandoc pantcl.tcl pantcl.html --css mini.css\n"
    puts "         Will do the conversion without using pandoc but with its"
    puts "         Markdown to HTML converter. Please note that in this case"
    puts "         only Markdown as input and HTML as output are supported.\n"    
    puts "Version:  [package present pantcl]"
    puts "Homepage: https://github.com/mittelmark/pantcl"
    puts "Author:   Detlef Groth, University of Potsdam, Germany"
    puts "License:  MIT"
    puts "Readme:   http://htmlpreview.github.io/?https://github.com/mittelmark/pantcl/blob/master/pantcl/Readme.html\n"
    exit 0
}


set css {
    html {
        overflow-y: scroll;
    }
    body {
        color: #444;
        font-family: Georgia, Palatino, 'Palatino Linotype', Times, 'Times New Roman', serif;
        line-height: 1.2;
        padding: 1em;
        margin: auto;
        max-width:  1100px;
    }
    h1, h2, h3, h4, h5, h6 {
        color: #111;
        line-height: 115%;
        margin-top: 1em;
        font-weight: normal;
    }
    h1 {
        text-align: center;
    }
    h2.author, h2.date {
        text-align: center;
    }
    a {
        color: #0645ad;
        text-decoration: none;
    }
    a:visited {  color: #0b0080; }
    a:hover   {  color: #06e;    }
    a:active  {  color: #faa700; }
    a:focus   {  outline: thin dotted; }
    
    p {  margin: 0.5em 0;    }
    p.author, p.date {
        font-size: 110%;
        text-align: center;
    }
    img {  max-width: 100%;    }
    figure { text-align: center ; } 
    pre, blockquote pre {
        border-top: 0.1em #9ac solid;
        background: #e9f6ff;
        padding: 10px;
        border-bottom: 0.1em #9ac solid;
    }
    pre, code, kbd, samp {
        color: #000;
        font-family: Monaco, 'courier new', monospace;
        font-size: 90%; 
    }
    pre code.tclinn {
        color: #ff2222;
    }
    pre code.tclout {
        color: #3366ff;
    }
    code.r {
        color: #770000;
    }
    pre.pipeout {
        background: #ffefef;
    }
    pre {
        white-space: pre;
        white-space: pre-wrap;
        word-wrap: break-word;
    }
    code span.kw { color: #007020; font-weight: normal; }
    pre.sourceCode {  background: #fff6f6;  } 
    blockquote {
        margin: 0;
        padding-left: 3em; 
    }
    hr {
        display: block;
        height: 2px;
        border: 0;
        border-top: 1px solid #aaa;
        border-bottom: 1px solid #eee;
        margin: 1em 0;
        padding: 0;
    }
    table {    
        border-collapse: collapse;
        border-bottom: 2px solid;
    }
    table thead tr th { 
        background-color: #fde9d9;
        text-align: left; 
        padding: 10px;
        border-top: 2px solid;
        border-bottom: 2px solid;
    }
    table td { 
        background-color: #fff9e9;
        text-align: left; 
        padding: 10px;
    }
}    
# some helper functions
# some generic helper functions

proc ::pantcl::luniq {L} {
    # removes duplicates without sorting the input list
    set t {}
    foreach i $L {if {[lsearch -exact $t $i]==-1} {lappend t $i}}
    return $t
}
proc ::pantcl::getCacheDir {} {
    if {[info exists ::env(HOME)]} {
        set path [file join $::env(HOME) .cache pantcl]
    } elseif {[info exists ::env(APPDATALOCAL)]} {
        set path  [file join $::env(APPDATALOCAL) pantcl]
    } else {
        set path pantcl
    } 
    if {![file exists $path]} {
        file mkdir $path
    }
    return $path
}

# allow loading Tcl packages and filters
set appdir [file dirname [info script]]
if {[file exists  [file join $appdir lib]]} {
    lappend auto_path [file normalize [file join $appdir lib]]
    package require tsvg
}

# interp create mdi
# 
# mdi eval "set auto_path \[list [luniq $auto_path]\]"

catch {
    # if available load filters
    package require tclfilters
}

# load other tcl based filters
foreach file [glob -nocomplain [file join [file dirname [info script]] filter filter*.tcl]]  {
    catch {
        source $file
    }
}
if {[lsearch $argv --pantcl-filter] >= 0} {
    # TODO: check if this works in standalone mode
    # should not work in pandoc mode (yet)
    set index [lsearch $argv --pantcl-filter]
    incr index
    if {![file exists [lindex $argv $index]]} {
        puts "Error: File [lindex $argv $index] does not exists!"
        exit 0
    } else {
        set fname [lindex $argv $index]
        source $fname
        set argv [lreplace $argv [expr {$index-1}] $index]
    }  
}   
proc ::pantcl::debug {jsonData} {
    puts [::rl_json::json keys $jsonData]
}

proc ::pantcl::tangle {args} {
    set outfile [lindex $args 0]
    set idx 0
    set infile ""
    set outfile ""
    set type ""
    foreach arg $args {
        if {[lindex $args $idx] eq "--tangle"} {
            # nop
        } elseif {$infile eq ""} {
            set infile [lindex $args $idx]
        } elseif {$outfile eq ""} {
            set outfile [lindex $args $idx]
        } elseif {$type eq ""} {
            set type [lindex $args $idx]
        }
        incr idx
    }
    if {$type eq ""} {
        set type [string range [string tolower [file extension $outfile]] 1 end]
    } else {
        set type [regsub --  {^\.} $type ""]
    }
    if {$outfile ni [list stdout -]} {
        set out [open $outfile w 0600]
    } else {
        set out stdout
    } 
    if [catch {open $infile r} infh] {
        return -code error "Cannot open $infile: $infh"
    } else {
        set flag false
        while {[gets $infh line] >= 0} {
            set line [regsub {^\s*#' } $line ""]
            if {[regexp "^\[> \]{0,2}```\{\.?$type\[^a-zA-Z\]" $line]} {
                set flag true
                continue
            } elseif {$flag && [regexp {^[> ]{0,2}```} $line]} {
                set flag false
                continue
            } elseif {$flag} {
                puts $out $line
            }
        }
        close $infh
        if {$outfile ni [list stdout -]} {
            close $out
        }
    }

}

set lineFilter false
proc ::pantcl::lineFilter {argv} {
    global lineFilter 
    set lineFilter true
    if {[info exists ::env(FILTEREVAL)]} {
        set evalvar  $::env(FILTEREVAL)
    } else {
        set evalvar false
    }
    set args [split $argv " "]
    set infile [lindex $args 0]
    set outfile [lindex $args 1]
    set mode md
    set yamldict [dict create]
    if {![regexp {.+\.[a-zA-Z]*md$} $outfile] && ![regexp -nocase {.+\.html} $outfile]} {
        error "Error: currently only conversion from Markdown to Markdown or to HTML is possible!"
    }
    if {[regexp -nocase {.+\.html} $outfile]} {
        set mode html
        set outfile [regsub {\.html} $outfile "-out.md"]
    }
    if {![file exists $infile]} {
        error  "Error: $infile does not exists"
    }
    if {[lsearch $argv "--metadata-file"] > -1} {
        set idx [lsearch $argv "--metadata-file"]
        incr idx 
        #puts "metafile $idx"
        if {[file exists [lindex $argv $idx]]} {
            set metafile [lindex $argv $idx]
            set fin [open $metafile r]
            set txt [read $fin]
            close $fin
            #puts $txt
            set yamldict [yaml::yaml2dict $txt]
        }
    }
    if [catch {open $infile r} infh] {
        error "Cannot open $infile: $infh"
    } else {
        set out [open $outfile w 0600]
        set i 0
        set n 0
        set flag false
        set yamlflag false
        set yamltext ""
        set filt "xxx"
        set ind ""
        # TODO: should be default false??
        set ddef [dict create echo true results show eval $evalvar] 
        set pre false
        while {[gets $infh line] >= 0} {
            incr n
            if {$n < 5 && !$yamlflag && [regexp {^---} $line]} {
                set yamlflag true
            } elseif {$yamlflag && [regexp {^---} $line]} {
                set yamldict [dict merge [yaml::yaml2dict $yamltext] $yamldict]
                set yamlflag false
                set yamltext ""
                dict for {key val} $yamldict {
                    if {[dict exists $yamldict $key filter]} {
                        set fname [dict get $yamldict $key filter]
                        if {[file exists $fname]} {
                            source $fname
                        } else {
                            puts stderr "Error: File `$fname` does not exists!"
                        }
                    }
                }
                if {[dict exists $yamldict bibliography]} {
                    package require citer
                    citer::bibliography [dict get $yamldict bibliography]
                }
            } elseif {$yamlflag} {
                foreach key [list title author date] {
                    if {[regexp "^${key}:" $line]} {
                        if {[dict exists $yamldict $key]} {
                                                  
                            if {$key eq "date" && [dict exists $yamldict date] && \
                                [regexp {^[0-9]{10,}} [dict get $yamldict date]]} {
                                dict set yamldict date [clock format [dict get $yamldict  date] -format "%Y-%m-%d"]
                            }
                            set line "${key}: [dict get $yamldict $key]"
                        }
                    }
                }
                append yamltext "$line\n"
            }
            if {!$pre && [regexp @ $line]} {
                if {[regexp {\[@references ([^ ]+)\]} $line -> bibfile]} {
                    set line [lindex [filter-tcl "bibliography $bibfile\n" {eval true results asis}] 0]
                } else {
                    set line [regsub {\[@references ([^ ]+)\]} $line "tcl bibliography \\1"]
                    set line [regsub -all {\[@([-A-Z0-9a-z]+)\]} $line "`tcl cite \\1`"]
                    set line [regsub -all {\[@([-A-Z0-9a-z]+);([-A-Z0-9a-z]+)\]} $line "`tcl cite \\1 \\2`"]
                    set line [regsub -all {\[@([-A-Z0-9a-z]+)\s*;\s*([-A-Z0-9a-z]+)\s*;\s*([-A-Z0-9a-z]+) \]} $line "`tcl cite \\1 \\2 \\3`"]
                }
            }
            set x 0
            while {!$pre && [regexp {`(r|py) +([^`]+)`} $line -> lang code]} {
                
                if {$lang eq "r"} { set lang R }
                if {$lang eq "py"} { set lang python }                    
                set res [filter-pipe $code [dict create pipe $lang eval true]]
                set res [regsub {.*>>>} [lindex $res 0] ""]
                set res [string range $res [expr {[string length $code]+2}] end]
                set res [regsub {.+\[1\] } $res ""]
                set res [regsub {^ +} $res ""]
                set line [regsub {`(r|py) +([^`]+)`} $line $res]
                # to avoid endless loops
                if {[incr x] > 10} {
                    break
                }   
            }       
            # translate r-chunks into pipe chunks
            if {[regexp {``` ?\{.*\}} $line]} {
                set line [regsub {\{r(.*)\}} $line "{.pipe pipe=\"R\"\\1}"]
                set line [regsub {\{py(.*)\}} $line "{.pipe pipe=\"python\"\\1}"]                
                set line [regsub -all {TRUE} $line true]
                set line [regsub -all {FALSE} $line false]                
                set line [regsub -all {,} $line " "]
            }
            # TODO: simple YAML parsing

            if {[regexp {^>? ?\s{0,2}```} $line]} {
                if {$pre} {
                    set pre false
                } else {
                    set pre true
                }
            }
            if {[regexp {^>? ?\s{0,2}``` ?\{\.} $line]} {
                set dchunk [dict create]    
                set dchunk [dict merge $ddef $dchunk]
                set ind ""
                if {[regexp {^> } $line]} {
                    set ind "> "
                }
                regexp {``` ?\{\.([a-zA-Z0-9]+)\s*(.*).*\}.*} $line -> filt options
                if {[dict exists $yamldict $filt]} {
                    set dchunk [dict merge $dchunk [dict get $yamldict $filt]]
                }
                # enable as well options with comma instead of space:
                # like results="show",wait=1
                set options [regsub {,([^ ])} $options " \\1"]
                foreach {op} [split $options " "] {
                    foreach {key val} [split $op "="] {
                        set val [regsub -all {"} $val ""] ;#"
                        dict set dchunk $key $val         
                    }
                }
                set flag true
                set cont ""
            } elseif {$flag && [regexp {^>? ?\s{0,2}```} $line]} {
                set flag false
                if {[info command filter-$filt] ne ""} {
                    set res [filter-$filt $cont $dchunk]
                    if {[dict get $dchunk echo]} {
                        # TODO: indentation adding if was there"
                        puts $out "$ind```${filt}inn\n$cont$ind```"
                    }
                    if {[lindex $res 0] ne ""} {
                        if {[dict get $dchunk results] eq "show"} {
                            # TODO: indentation adding if was there"
                            # remove trailing newline as we add our own
                            set r [regsub {\n$} [lindex $res 0] ""]
                            set r [string map  {&amp;gt; &gt;} $r] ;#BUG in markdown lib?
                            puts $out "\n$ind```${filt}out\n$r\n$ind```"
                        } elseif {[dict get $dchunk results] eq "asis"} {
                            set ores [regsub {^```} [lindex $res 0] "\n"]
                            puts $out "$ores\n"
                        }
                    }
                    if {[lindex $res 1] ne ""} {
                        set title ""
                        if {[dict exists $dchunk title]} {
                            set title [dict get $dchunk title]
                        }
                        puts $out "\n!\[$title\]([lindex $res 1])"
                    }
                    
                }
                set cont ""
            } elseif {$flag} {
                append cont "$line\n"
            } else {
                # TODO: more than one inline code per line
                if {!$pre} {
                    while {[regexp {`\.?[A-Za-z]{1,4} .+`} $line]} {
                        set cont false
                        set eval false
                        set pipe python
                        set filt [regsub {.*?`\.?([A-Za-z]{1,4}) [^`]+`.*$} $line "\\1"]
                        if {$filt in [list "r" "R"]} {
                            set filt pipe
                            set pipe R
                        }
                        if {$filt in [list "py"]} {
                            set filt pipe
                            set pipe python
                        }
                        if {[dict exists $yamldict $filt eval]} {
                            if {[dict get $yamldict $filt eval]} {
                                set eval true
                            } 
                        }
                        if {[info command filter-$filt] eq "filter-$filt" && $eval} {
                            set code [regsub {.*?`\.?[A-Za-z]{1,4} ([^`]+)`.*$} $line "\\1"]
                            if {[dict exists $yamldict $filt]} {
                                if {[dict exists $yamldict $filt]} {
                                    set d [dict create {*}[dict get $yamldict $filt]] 
                                    dict set d pipe $pipe
                                    dict set d terminal false
                                    if {[dict exists $d eval] && [dict get $d eval]} {
                                        set res [lindex [filter-$filt $code $d] 0]
                                        set res [regsub -all "\n" $res " "]
                                        set res [regsub {.+ ([^\s]+) ?$} $res "\\1"]
                                        set line [regsub {(.*?)`\.?[A-Za-z]{1,4} ([^`]+)`(.+)} $line "\\1$res\\3"]
                                        set cont true
                                    }
                                }
                            }
                        }
                        if {!$cont} {
                            break
                        }
                    }
                }
                puts $out $line
            }
        }
        close $infh
    }
    close $out
    if {$mode eq "html"} {
        mkdoc::mkdoc $outfile [regsub -- {-out.md} $outfile ".html"] {*}[lrange $argv 2 end]
        file delete $outfile
    }
}

set runGui false
proc ::pantcl::runGui {argv} {
    package require fview
    fview::gui
    set file false
    foreach arg $argv {
        if {[file exists $arg]} {
            set ext [string range [file extension $arg] 1 end]
            #puts $ext
            fview::fileOpen $arg
            fview::fileSave $arg
            set file true
            break
        }
    }
    if {!$file} {
        set ftemp [file temp].tsvg
        set out [open $ftemp w 0600]
        puts $out {package require tsvg
tsvg set code "" ;
tsvg set width 400
tsvg set height 400

tsvg rect -x 10 -y 10 -width 380 -height 380 \
        -fill cornsilk
tsvg circle -cx 200 -cy 200 -r 120 -stroke black -stroke-width 2 -fill #eeffee
tsvg text -x 155 -y 180 "Hello TSVG"
tsvg text -x 135 -y 220 "Filter View World!"
}
        close $out
        fview::fileOpen $ftemp
        fview::fileSave $ftemp
        file delete $ftemp
    }
}
# Gui mode
if {[llength $argv] > 0 && [lsearch $argv --gui] > -1} {
    ::pantcl::runGui $argv
    set runGui true
}
# Standalone processing 
# calling pandoc eventually itself

if {[info exists argv] && [llength $argv] > 1 && [file exists [lindex $argv 0]]} {
    set pandoc true
    if {[lsearch $argv --tangle] >= 0} {
        pantcl::tangle {*}$argv
        return
    }
    if {[lsearch $argv --no-pandoc] > 1 || [auto_execok pandoc] eq ""} {
        package require yaml
        package require mkdoc::mkdoc
        set idx [lsearch $argv --no-pandoc] 
        if {$idx > 0} {
            set argv [lreplace $argv $idx $idx {}]
        }
        set pandoc false
    } 
    if {[file extension [lindex $argv 1]] eq ".html" && [lsearch [lrange $argv 1 end] --css] == -1} {
        if {![file exists pandoc-filter.css]} {
            set out [open pandoc-filter.css w 0600]
            puts $out $css
            close $out
        }
        lappend argv --css
        lappend argv pandoc-filter.css
    }
    if {[file extension [lindex $argv 0]] in [list .tcl .tm .py .R .r .c .cxx .cpp .m .pl .pm .h .hpp .hxx]} {
        set tempfile [file tempfile].md 
        set filename [lindex $argv 0]
        set infile [lindex $argv 0]
        set out [open $tempfile w 0600]
        if [catch {open $filename r} infh] {
            puts stderr "Cannot open $filename: $infh"
            exit
        } else {
            while {[gets $infh line] >= 0} {
                if {[regexp {^\s*#' ?} $line]} {
                    set line [regsub {^\s*#' ?} $line ""]
                    puts $out $line
                }
                
            }
            close $infh
        }
        close $out
        if {$pandoc} {
            exec pandoc $tempfile --filter $argv0 -o {*}[lrange $argv 1 end] 
        }  else {
            set argv [lset argv 0 $tempfile]
            pantcl::lineFilter $argv
        }
        file delete $tempfile
        puts "converting $infile to [lindex $argv 1] done"
        exit 0
    } else {
        if {$pandoc} {
            exec pandoc [lindex $argv 0] --filter $argv0 -o {*}[lrange $argv 1 end]
        }  else {
            pantcl::lineFilter $argv
        }
        #puts "converting [lindex $argv 0] to [lindex $argv 1] done"
    }
    exit 0
}

#' ---
#' title: pantcl filter documentation - 0.9.12
#' author: Detlef Groth, Schwielowsee, Germany
#' date: 2023-09-13
#' tcl:
#'    echo: "true"
#'    results: show
#'    eval: 1
#' ---
#'
#' ------
#' 
#' ```{.tcl results="asis" echo=false}
#' include header.md
#' ```
#' ------
#'
#' ## NAME
#' 
#' _pantcl.tcl_ - filter application for the pandoc command line 
#' application to convert Markdown files into other formats. The filter allows you to embed Tcl code into your Markdown
#' documentation and offers a plugin architecture to add other command line filters easily using Tcl
#' and the `exec` command. As examples are given in the filter folder of the project:
#'
#' * Tcl filter {.tcl}: `filter-tcl.tcl` [filter/filter-tcl.html](filter/filter-tcl.html)
#' * ABC music filter {.abc}: `filter-abc.tcl` [filter/filter-abc.html](filter/filter-abc.html)
#' * command line application filter {.cmd}: `filter-cmd.tcl` [filter/filter-abc.html](filter/filter-cmd.html)
#' * Graphviz dot filter {.dot}: `filter-dot.tcl` [filter/filter-dot.html](filter/filter-dot.html)
#' * EQN filter plugin for equations written in the EQN language {.eqn}: `filter-eqn` [filter/filter-eqn.html](filter/filter-eqn.html)
#' * Julia filter plugin for Julia clode {.julia}: `filter-julia` [filter/filter-julia.html](filter/filter-julia.html)
#' * Math TeX filter for single line equations {.mtex}: `filter-mtex.tcl` [filter/filter-mtex.html](filter/filter-mtex.html)
#' * Mermaid filter for diagrams {.mmd}: `filter-mmd.tcl` [filter/filter-mmd.html](filter/filter-mmd.html)
#' * Pikchr filter plugin for diagram creation {.pikchr}: `filter-pik.tcl` [filter/filter-pik.html](filter/filter-pik.html)
#' * PIC filter plugin for diagram creation (older version) {.pic}: `filter-pic.tcl` [filter/filter-pic.html](filter/filter-pic.html)
#' * pipe filter for R, Python and Octave {.pipe}: `filter-pipe.tcl` [filter/filter-pipe.html](filter/filter-pipe.html)
#' * PlantUMLfilter plugin for diagram creation {.puml}: `filter-puml.tcl` [filter/filter-puml.html](filter/filter-puml.html)
#' * R plot filter plugin for displaying plots in the R statistical language {.rplot}: `filter-rplot.tcl` [filter/filter-rplot.html](filter/filter-rplot.html)
#' * sqlite3 filter plugin to evaluate SQL code {.sqlite}: `filter-sqlite.tcl` [filter/filter-sqlite.html](filter/filter-sqlite.html)
#' * tcrd filter for music songs with chords {.tcrd}: `filter-tcrd.tcl` [filter/filter-tcrd.html](filter/filter-tcrd.html)
#' * tdot package filter {.tsvg}: `filter-tdot.tcl` [filter/filter-tdot.html](filter/filter-tdot.html)
#' * tsvg package filter {.tsvg}: `filter-tsvg.tcl` [filter/filter-tsvg.html](filter/filter-tsvg.html)
#'
#' ## SYNOPSIS 
#' 
#' We assume that you renamed the standalone file `pantcl.tapp` to `pantcl` and
#' that this file is in your path.
#' 
#' ```
#' # standalone application
#' pantcl infile outfile ?options?
#' # as filter
#' pandoc infile --filter pantcl ?options?
#' # as graphics user interface
#' pantcl --gui [filename]
#' ```
#' 
#' Where options for the filter and the standalone mode
#' are the usual pandoc options. For HTML conversion you should use for instance:
#' 
#' ```
#' pantcl infile.md outfile.html --css style.css -s --toc
#' ```
#'
#' Please note, that you can rename as well the file `pantcl.tapp` into other names like 
#' `pantcl.bin`, however the basename `pantcl` must stay the same.
#' 
#' ## Code embedding
#'
#' Embed code either inline or in form of code chunks like here (triple ticks):
#' 
#' ``` 
#'     ```{.tcl}
#'     set x 4
#'     incr x
#'     set x
#'     ```
#'   
#'     Hello this is Tcl `tcl package provide Tcl`!
#' ```
#' 
#' ## Filter Overview 
#' 
#' The markers for the other filters are:
#' 
#' `{.abc}, `{.dot}`, `{.eqn}`, `{.julia}`, `{.mmd}`, `{.mtex}`, `{.pic}`,
#' `{.pikchr}, `{.puml}`, `{.rplot}`,`{.sqlite}` and `{.tsvg}`. 
#' 
#' For details on how to use them have a look at the manual page links on top.
#' 
#' You can combine all filters in one document  just by using the appropiate markers. 
#' 
#' Here an overview about the required tools to use a filter:
#' 
#' <center>
#' 
#' | filter | tool | svg | png | pdf | comment |
#' | ------ | ----- | ---- | ---- | ---- | ---- |
#' | .tcl   | tclsh   | tsvg | cairosvg | cairosvg | programming | 
#' | .abc   | abcm2ps | abcm2ps | cairosvg | cairosvg | music |
#' | .dot   | dot   | native | native | native | diagrams |
#' | .emf   | jasspa microemacs | no | no | no | editor | 
#' | .eqn   | eqn2graph | no | convert | no | math | 
#' | .julia | julia  | native | native | native | statistics | 
#' | .mmd   | mermaid-cli (mmdc) | native | native | native | diagrams |
#' | .mtex  | latex  | dvisgm | dvipng | dvipdfm | math, diagrams, games |
#' | .pic   | pic2graph | no | convert | no | diagrams |
#' | .pik   | fossil    |  native | cairosvg | cairosvg | diagrams |
#' | .pipe  | R / python / octave |  native | native | native | Statistics, Programming |
#' | .puml  | plantuml  |  native | native | native | diagrams |
#' | .rplot | R         | native  | native | native | statistics, graphics |
#' | .tcrd  | tclsh       | no      | no    |  no | music, songs with chords |
#' | .tdot  | tclsh/dot   | native  | native |  native | diagrams |
#' | .tsvg  | tclsh       | native  | cairosvg | cairosvg | graphics |
#' 
#' </center>
#' 
#' The Markdown document within this file could be extracted and converted as follows:
#' 
#' ```
#'  pantcl pantcl.tcl pantcl.html \
#'    --css mini.css -s
#' ```
#'
#' ## Example Tcl Filter
#' 
#' #### Tcl-filter
#' 
#' ```
#'     ```{.tcl}
#'     set x 1
#'     puts $x
#'     ```
#' ```
#'
#' And here the output:
#' 
#' ```{.tcl}
#' set x 1
#' puts $x
#' ```
#'
#' Does indented code blocks works as well?
#' 
#' > ```{.tcl}
#'   set x 2
#'   puts $x
#' >  ```
#' 
#' > Yes, since version 0.7.0!!
#' 
#' There is as well the possibility to inline Tcl code like here:
#' 
#' ```
#' This document was processed using Tcl `tcl set tcl_patchLevel`!
#' ```
#' 
#' will produce:
#' 
#' This document was processed using Tcl `tcl set tcl_patchLevel`!
#' 
#' This works as well in nested structures like lists or quotes.
#' 
#' > This document was processed using Tcl `tcl set tcl_patchLevel`!
#' 
#' > - This document was processed using Tcl `tcl set tcl_patchLevel`!
#'
#' ## Filter - Plugins
#' 
#' The pantcl.tcl application allows to create custom filters for other 
#' command line application quite easily. The Tcl files has to be named `filter-NAME.tcl`
#' where NAME hast to match the code chunk marker. Below an example:
#' 
#' ```
#'    ` ``{.dot label=dotgraph}
#'    digraph G {
#'      main -> parse -> execute;
#'      main -> init;
#'      main -> cleanup;
#'      execute -> make_string;
#'      execute -> printf
#'      init -> make_string;
#'      main -> printf;
#'      execute -> compare;
#'    }
#' 
#'    ![](dotgraph.svg)
#'    ` ``
#' ```
#' 
#' The main script `pantcl.tcl` evaluates if in the same folder as the script is,
#' if there any other files named `filter/filter-NAME.tcl` and sources them. In case of the dot
#' filter the file is named `filter-dot.tcl` and its filter function `filter-dot` is 
#' executed. Below is the simplified code: of this file `filter-dot.tcl`:
#' 
#' ```{.tcl eval=false results="hide"}
#' # a simple pandoc filter using Tcl
#' # the script pantcl.tcl 
#' # must be in the same filter directoy of the pantcl.tcl file
#' proc filter-dot {cont dict} {
#'     global n
#'     incr n
#'     set def [dict create app dot results show eval true fig true 
#'              label null ext svg width 400 height 400 \
#'              include true imagepath images]
#'     # fuse code chunk options with defaults
#'     set dict [dict merge $def $dict]
#'     set ret ""
#'     if {[dict get $dict label] eq "null"} {
#'         set fname dot-$n
#'     } else {
#'         set fname [dict get $dict label]
#'     }
#'     # save dot file
#'     set out [open $fname.dot w 0600]
#'     puts $out $cont
#'     close $out
#'     # TODO: error catching
#'     set res [exec [dict get $dict app] -Tsvg $fname.dot -o $fname.svg]
#'     if {[dict get $dict results] eq "show"} {
#'         # should be usually empty
#'         set res $res
#'     } else {
#'         set res ""
#'     }
#'     set img ""
#'     if {[dict get $dict fig]} {
#'         if {[dict get $dict include]} {
#'             set img $fname.svg
#'         }
#'     }
#'     return [list $res $img]
#' }
#' ```
#'
#' Using the label and the option `include=false` we could create an image link manually using Markdown syntax. The 
#' The image filename should be then images/label.svg for instance.
#' 
#' ## Dot Example
#' 
#' Here a longer dot-example where the code is include in 
#' 
#' ```{.dot}
#' digraph G {
#'   margin=0.1;
#'   node[fontname="Linux Libertine";fontsize=18];
#'   node[shape=box,style=filled;fillcolor=skyblue,width=1.2,height=0.9];    
#'   { rank=same; Rst[group=g0,fillcolor=salmon] ; 
#'     Docx [group=g1,fillcolor=salmon]
#'   }
#'   { rank=same; Md[group=g0,fillcolor=salmon]  ; 
#'     pandoc ; AST1 ; filter[fillcolor=cornsilk] ; AST2 ; pandoc2;  
#'     Html[group=g1,fillcolor=salmon] 
#'   }
#'   { rank=same; Tex[group=g0,fillcolor=salmon] ; 
#'     Pdf[group=g1,fillcolor=salmon]; filters[fillcolor=cornsilk]; 
#'   }
#'   node[fillcolor=cornsilk]; 
#'   { rank=same; dot ; eqn; mtex; pic; pik; rplot; tsvg;}
#'   Rst -> pandoc -> AST1 -> filter -> AST2 -> pandoc2 -> Html ;
#'   Md -> pandoc;
#'   Tex -> pandoc;
#'   Rst -> Md -> Tex -> dot[style=invis] ;
#'   pandoc2 -> Docx;
#'   pandoc2 -> Pdf ;
#'   Docx -> Html -> Pdf -> tsvg[style=invis];
#'   pandoc2[label=pandoc];
#'   filter[label="pantcl\nfilter"];
#'   filter->filters;
#'   filters -> dot ;
#'   filters -> eqn ;
#'   filters -> mtex;
#'   filters -> pic ;
#'   filters -> pik ; 
#'   filters -> rplot;
#'   filters -> tsvg; 
#' }
#' ```
#' 
#' ## Creating Markdown Code
#' 
#' Since version 0.5.0 it is as well possible to create Markup code within code blocks and to return it. 
#' To achieve this you to set use code chunk option results like this: `results="asis"` -
#' which should be usually used together with `echo=false`. Here an example:
#' 
#' ``` 
#'      ```{.tcl echo=false results="asis"}
#'      return "**this is bold** and _this is italic_ text!"
#'      ```    
#' ```
#' 
#' which gives this output:
#' 
#' ```{.tcl echo=false results="asis"}
#' return "**this is bold** and _this is italic_ text!"
#'
#' ``` 
#' 
#' This can be as well used to include other Markup files. Here an example:
#' 
#' ```
#'     ```{.tcl results="asis"}
#'     include tests/inc.md
#'     ```
#' ```
#'
#' And here is the result:
#' 
#' ```{.tcl results="asis"}
#' include tests/inc.md
#' ```
#' 
#' Please note, that currently no filters are applied on the included files. 
#' You should process them before using the pandoc filters and choose output format Markdown to include them later
#' in your master document.
#' 
#' To just show some file content as it is, remove the results="asis", 
#' this can be as well useful to display some source code, let's here simply show here the content of *tests/inc.md* without interpreting it as Markdown in a source code block:
#' 
#' ```
#'     ```{.tcl results="show"}
#'     include tests/inc.md
#'     ```
#' ```
#'
#' And here is the result:
#' 
#' ```{.tcl results="show"}
#' include tests/inc.md
#' ```
#' 
#' ## Documentation
#' 
#' To use this pipeline and to create pantcl.html out of the code documentation 
#' in pantcl.tapp your command in the terminal is still just:
#' 
#' ```
#' pantcl.tapp pantcl.tcl pantcl.html -s --css mini.css
#' ```
#' 
#' The result should be the file which you are looking currently.
#' 
#' ## ChangeLog
#' 
#' * 2021-08-22 Version 0.1
#' * 2021-08-28 Version 0.2
#'     * adding custom filters structure (dot, tsvg examples)
#'     * adding attributes label, width, height, results
#' * 2021-08-31 Version 0.3
#'     * moved filters into filter folder
#'     * plugin example mtex
#'     * default image path _images_
#' * 2021-11-03 Version 0.3.1
#'     * fix for parray and "puts stdout"
#' * 2021-11-15 Version 0.3.2
#'     * --help argument support
#'     * --version argument support
#'     * filters for Pikchr, PIC and EQN
#' * 2021-11-30 Version 0.3.3
#'     * filter for R plots: `.rplot`
#' * 2021-12-04 Version 0.4.0
#'     * pandoc-tcl-filter can be as well directly used for conversion 
#'       being then a frontend which calls pandoc internally with 
#'       itself as a filter ...
#' * 2021-12-12 Version 0.5.0
#'    * support for Markdown code creation in the Tcl filter with results="asis"
#'    * adding list2mdtab proc to the Tcl filter
#'    * adding include proc to the Tcl filter with results='asis' other Markdown files can be included.
#'    * support for `pandoc-tcl-filter.tcl infile --tangle .tcl`  to extract code chunks to the terminal
#'    * support for Mermaid diagrams
#'    * support for PlantUML diagrams 
#'    * support for ABC music notation
#'    * bug fix for Tcl filters for `eval=false`
#'    * documentation improvements for the filters and for the pandoc-tcl-filter
#' * 2022-01-09 - version 0.6.0
#'    * adding filter-cmd.tcl for shell scripts for all type of programming languages and tools
#'    * filter-mtex.tcl with more examples for different LaTeX packages like tikz, pgfplot, skak, sudoku, etc.
#'    * adding filter-tdot.tcl for tdot Tcl package
#'    * adding filter-tcrd.tcl for writing music chords above song lyrics
#' * 2022-02-05 - version 0.7.0
#'    * graphical user interface to the graphical filters (abc, dot, eqn, mmd, mtex, pic, pikchr, puml, rplot, tdot, tsvg) using the command line option *--gui*
#'    * can now as well work without pandoc standalone for conversion of Markdown with code chunks into 
#'      Markdown with evaluated code chunks and HTML code using the
#'      Markdown library of tcllib
#'    * that way it deprecates the use of tmdoc::tmdoc and mkdoc::mkdoc as it contains now the same functionality
#'    * support for inline code evaluations for Tcl, Python (pipe filter) and R (pipe filter) statements as well in nested paragraphs, lists and headers
#'    * support for indented code blocks with evaluation
#'    * new - filter-pipe:
#'        * initial support for R code block features and inline evaluation and error catching
#'        * initial support for Python with code block features and inline evaluation and error catching
#'        * initial support for Octave with code block features and error checking
#'    * more examples filter-mtex, filter-puml, filter-pikchr 
#'    * fix for filter-tcl making variables chunk and res namespace variables, avoiding variable collisions
#' * 2023-01-10 - version 0.9.0
#'    * renamed to pantcl.tcl and creating it's own repository
#' * 2023-03-05 - fixing a problem with the @symbol in text
#' * 2023-03-11 - version 0.9.11
#'    * eval is now per default `false` for all filters
#'    * support for Rst and LaTeX as input if pantcl is used as a filter
#' * 2023-04-06 - version 0.9.12
#'    * adding filter-emf.tcl for MicroEmacs macro language
#'    * adding external Tcl filter support via YAML declaration
#'    * adding example user/filter-geasy.tcl as example for the latter
#'    * standalone mode now with Unicode support 
#'    * fix for standalone mode
#'    * standalone check and working now as well for pipes and inline single backticks, tested with R
#'    * filter for Julia code, however Julia is slow at startup and even slower at plotting
#'    * support for pandoc single percent title, author, date at the beginning of documents
#'    * extending support for tangle for non Tcl code chunks
#' * 2023-09-07 - version 0.9.13
#'    * support for --inline option to allow inlining of images and css files
#'    * bug fix for image/img-tag
#'    
#' ## SEE ALSO
#' 
#' * [Readme.html](Readme.html) - more information and small tutorial
#' * [Examples](examples/example-eqn.html) - more examples for the filters 
#' * [Tclers Wiki page](https://wiki.tcl-lang.org/page/pandoc%2Dtcl%2Dfilter) - place for discussion
#' * [Pandoc filter documentation](https://pandoc.org/filters.html) - more background and information on how to implement filters in Haskell and Lua
#' * [Lua filters on GitHub](https://github.com/pandoc/lua-filters)
#' * [Plotting filters on Github](https://github.com/LaurentRDC/pandoc-plot)
#' * [Github Pandoc filter list](https://github.com/topics/pandoc-filter)
#' 
#' ## AUTHOR
#' 
#' Detlef Groth, Caputh-Schwielowsee, Germany, detlef(_at_)dgroth(_dot_).de
#'  
#' ## LICENSE
#' 
#' 
#' Copyright (c) 2021-2023 Detlef Groth, Caputh-Schwielowsee, Germany
#' 
#' Permission is hereby granted, free of charge, to any person obtaining a copy
#' of this software and associated documentation files (the "Software"), to deal
#' in the Software without restriction, including without limitation the rights
#' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#' copies of the Software, and to permit persons to whom the Software is
#' furnished to do so, subject to the following conditions:
#' 
#' The above copyright notice and this permission notice shall be included in all
#' copies or substantial portions of the Software.
#' 
#' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#' SOFTWARE.
#' 
## proc filter-NAME function in a file filter/filter-NAME.tcl

# parse Meta data
#puts stderr $jsonData
#exit
proc getMetaDict {meta fkey} {
    set d [dict create]
    if {[rl_json::json exists $meta $fkey c]} {
        foreach key [rl_json::json keys $meta $fkey c] {
            dict set d $key [rl_json::json get $meta $fkey c $key c 0 c]
        }
    }
    if {[dict exists $d filter]} {
        if {[info proc filter-$fkey] eq ""} {
            source [dict get $d filter]
        }
    }
    return $d    
}

# walk and search for inlineCodes
set inlineCodes [list]
proc walk {key {ind 1}} {
    global jsonData
    global inlineCodes
    #puts "key: {*}$key"
    set sind [string repeat " " [expr {$ind*4}]] 
    set type [::rl_json::json type $jsonData blocks {*}$key]
    set l 0 
    if {$type eq "array"} {
        set l [llength [rl_json::json get $jsonData blocks {*}$key]]
    } elseif {$type eq "object"} {
        set l [llength [rl_json::json get $jsonData blocks {*}$key]]
    } 
 
    #puts "$sind type: $type length $l"
    #puts "$sind cnt:   [::rl_json::json get $jsonData blocks {*}$key]"
    incr ind
    if {$type eq "array"} {
        for {set j 0} {$j < $l} {incr j} {
            set nkey $key
            lappend nkey $j
            walk $nkey $ind
        }
    }
    if {$type eq "object"} {
        set tkey $key
        set ckey $key
        if {$l > 2} {
            lappend tkey t
            lappend ckey c
            if {[::rl_json::json exists $jsonData blocks {*}$tkey]} {
                 set t [::rl_json::json get $jsonData blocks {*}$tkey]
                 if {$t eq "Code"} {
                    lappend ckey 1
                    #lappend ckey
                    set code [::rl_json::json get $jsonData blocks {*}$ckey]
                    #puts "$sind  code: $code" 
                    if {[regexp {^[a-zA-Z0-9]{1,3} .+} $code]} {
                        lappend inlineCodes [list $ckey $code]
                    }
                }
            } else {
                walk $ckey $ind 
            }
        }
    }
    return
}

proc codeBlock {} {
    uplevel 1 {
        set type [rl_json::json get $jsonData blocks {*}$tkey] ;#type
        set attr [rl_json::json get $jsonData blocks {*}$akey] ;# attributes
        set a [dict create echo true results show eval $evalvar filter none] 
        set d [getMetaDict $meta $type]
        set a [dict merge $a $d]
        if {[llength $attr] > 0} {
            foreach el $attr {
                dict set a [lindex $el 0] [lindex $el 1]
            }
            #puts [dict keys $a]
        }

        if {$type eq "" && [dict get $a filter] ne "none"} {
            set type [dict get $a filter]
        }
        #puts stderr "type: $type dict $a"
        set cont [rl_json::json get $jsonData blocks {*}$ckey]
        set cblock "[::rl_json::json extract $jsonData blocks {*}$bkey]"
        
        if {[dict get $a echo]} {
            append blocks "[::rl_json::json extract $jsonData blocks $i]\n"
        } else {
            #rl_json::json unset jsonData blocks $i
            # add an empty paragraph instead
            append blocks {{"t":"Para","c":[{"t":"Str","c":""}]}}
            #append blocks [::rl_json::json extract $jsonData blocks $i]\n"
        }
        if {$type ne ""} {
            if {[info command filter-$type] eq "filter-$type"} {
                set res [filter-$type $cont $a]
                
                if {[llength $res] >= 1} {
                    set code [lindex $res 0]
                    if {$code ne ""} {
                        if {[dict get $a results] ne "asis"} {
                            if {$blockType eq "CodeBlock"} {
                                rl_json::json set cblock c 0 1 [rl_json::json array [list string ${type}out]]
                                rl_json::json set cblock c 1 [rl_json::json string $code]
                                append blocks ",[::rl_json::json extract $cblock]"
                            } elseif {$blockType eq "BlockQuote"} {
                                rl_json::json set cblock c 0 c 0 1 [rl_json::json array [list string ${type}out]]
                                rl_json::json set cblock c 0 c 1 [rl_json::json string $code]
                                append blocks ",[::rl_json::json extract $cblock]"
                            }
                        } else {
                            set cres $code
                            set mdfile [file tempfile].md
                            set out [open $mdfile w 0600]
                            puts $out $code
                            close $out
                            set cres [exec pandoc -t json $mdfile]
                            file delete $mdfile
                            # pandoc 2.9 (block first then meta)
                            set cres [regsub {^.+"blocks":\[(.+)\],"pandoc-api-version".+} $cres "\\1"]
                            # pandoc 2.12++ (meta first, then block)
                            #set cres [regsub {^\{"pandoc-api-version".+"blocks":\[(.+)\]\}} $cres "\\1"]                                
                            append blocks ,
                            append blocks $cres
                        }
                    }
                    if {[llength "$res"] == 2} {
                        set img [lindex $res 1]
                        if {$img ne ""} {
                            rl_json::json set jsonImg c 0 c 2 0 "$img"
                            append blocks ",[::rl_json::json extract $jsonImg]"
                        }
                    }
                    
                }
            }
        }
    }
}
# the main method parsing the json data
proc main {jsonData} {
    package require rl_json
    
    if {[info exists ::env(FILTEREVAL)]} {
        set evalvar $::env(FILTEREVAL)
    } else {
        set evalvar false
    }
    set blocks ""
    set jsonImg {
       {
            "t": "Para",
            "c": [
                {
                    "t": "Image",
                    "c": [
                        [
                            "",
                            [],
                            []
                        ],
                        [],
                        [
                            "image.svg",
                            ""
                        ]
                    ]
                }
            ]
      }
    }
    set meta  [rl_json::json extract $jsonData meta] 
    set len  [llength [::rl_json::json get $jsonData blocks]]
    for {set i 0} {$i < $len} {incr i} {
        if {$i > 0} {
            append blocks ","
        }
        set blockType [::rl_json::json get $jsonData blocks $i t]
        if {$blockType eq "CodeBlock"} {
            set tkey [list $i c 0 1]
            set akey [list $i c 0 2]
            set ckey [list $i c 1]
            set bkey [list $i]
            codeBlock
        } elseif {$blockType in [list BulletList Header Para BlockQuote]}  {
            if {$blockType eq "BlockQuote" && [::rl_json::json get $jsonData blocks $i c 0 t] eq "CodeBlock"} {
                set tkey [list $i c 0 c 0 1]
                set akey [list $i c 0 c 0 2]
                set ckey [list $i c 0 c 1]
                set bkey [list $i]
                codeBlock
                continue
            }
            set ::inlineCodes [list]
            set k [llength [::rl_json::json get $jsonData blocks $i c]]
            if {$blockType eq "Header" && $k == 3} {
                walk [list $i c 2]
            } else {
                for {set j 0} {$j < $k} {incr j} {
                    walk [list $i c [regsub -all @ $j "\\@"]]
                }
            }
            foreach item $::inlineCodes {
                foreach {key code} $item {
                    set ckey [lrange $key 0 end-1]
                    set tkey [lrange $key 0 end-2]
                    lappend tkey t
                    set c [regsub {^[^ ]+} $code ""]
                    # puts stderr $code

                    if {[regexp {^\.?tcl } $code]} {

                        set dm [getMetaDict $meta tcl]
                        set dict [dict merge [dict create eval false] $dm]
                        if {[dict get $dict eval]} {
                            if {[catch {
                                 set ::errorInfo {}
                                set res [interp eval mdi $c]
                            }]} {
                                    set res "error: $c"
                                    set res "Error: [regsub {\n +invoked.+} $::errorInfo {}]"
                            }
                            set jsonData [rl_json::json set jsonData blocks {*}$ckey [rl_json::json string "$res"]]
                            set jsonData [rl_json::json set jsonData blocks {*}$tkey Str]
                        }
                     } elseif {[regexp -nocase {^\.?R } $code]} {
                         set dm [getMetaDict $meta pipe]
                         #puts stderr "R inline"
                         set d [dict merge [dict create results show echo false pipe R] $dm]
                         set res [lindex [filter-pipe $c $d] 0]
                         set res [regsub {^>.+\[1\]} $res ""]
                         set jsonData [rl_json::json set jsonData blocks {*}$ckey [rl_json::json string "$res"]]
                         set jsonData [rl_json::json set jsonData blocks {*}$tkey Str]
                     } elseif {[regexp -nocase {^\.?oc } $code]} {
                         # octave does not work
                         set dm [getMetaDict $meta pipe]
                         set d [dict merge [dict create results show echo false pipe octave] $dm]
                         set res [regsub {.+?> } [lindex [filter-pipe "$c\n" $d] 0] ""]
                         set jsonData [rl_json::json set jsonData blocks {*}$ckey [rl_json::json string "$res"]]
                         set jsonData [rl_json::json set jsonData blocks {*}$tkey Str]
                     } elseif {[regexp {^\.?py } $code]} {
                         set dm [getMetaDict $meta pipe]
                         #puts stderr "python chunk inline: $dm"
                         set d [dict merge [dict create pipe python3 terminal true eval false] $dm]
                         if {[dict get $d eval]} {
                            set res [regsub {.+> } [lindex [filter-pipe [string trim $c] $d] 0] ""]
                            set res [lindex [split $res "\n"] 1]
                            #puts stderr "res $res"
                             #set res [regsub {^>.+\[1\]} $res ""]
                             set jsonData [rl_json::json set jsonData blocks {*}$ckey [rl_json::json string "$res"]]
                             set jsonData [rl_json::json set jsonData blocks {*}$tkey Str]
                         } 
                     }
                 }
            }
            append blocks "[::rl_json::json extract $jsonData blocks $i]\n"
        } else  {
            append blocks "[::rl_json::json extract $jsonData blocks $i]\n"
        }
    }
    set ret "\"blocks\":\[$blocks\]"
    
    append ret ",\"pandoc-api-version\":[::rl_json::json extract $jsonData pandoc-api-version]"
    
    append ret ",\"meta\":[::rl_json::json extract $jsonData meta]"
    #set out [open out.json w 0600]
    #puts $out "{$ret}"
    #close $out
    return "{$ret}"
}

# just demo code from the Tclers wiki (not used): 
proc incrHeader {jsonData} {
    for {set i 0} {$i < [llength [::rl_json::json get $jsonData blocks]]} {incr i} {
        set blockType [::rl_json::json get $jsonData blocks $i t]
        if {$blockType eq "Header"} {
            set headerLevel [::rl_json::json get $jsonData blocks $i c 0]
            set jsonData [::rl_json::json set jsonData blocks $i c 0 [expr {$headerLevel + 1}]]
        } 
    }
    return $jsonData
}

## Global variables

proc ::pantcl::pipe { } {
    global n
    global lineFilter 
    global runGui
    global jsonData
    if {!$lineFilter && !$runGui} {
        set n 0
        set jsonData {}
        while {[gets stdin line] > 0} {
            append jsonData $line
        }
        
        # give the modified document back to Pandoc again:
        puts -nonewline [main $jsonData]
    }
}

pantcl::pipe
