#' ---
#' title: "filter-tcrd.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2023-07-14
#' tcrd:
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
#' _filter-tcrd.tcl_ - Pandoc Tcl filter which can be used to display songs with chords
#'   with music chord names above the text where the chords are directly embedded within the song text. Currently only one chord per word can be displayed.
#' 
#' ## Usage
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pandoc input.md --filter pantcl.bin -s -o output.html
#' ```
#' 
#' The file `filter-tcrd.tcl` is not used directly but sourced automatically by the `pantcl.bin` file.
#' If code blocks with the `.tcrd` marker are found, the contents in the code block is 
#' processed via the Tcl interpreter using the embedded Tcl code.
#' 
#' The following options can be given via code chunks options or as defaults in the YAML header.
#' 
#' > - eval - should the code in the code block be evaluated, default: false (0)
#'   - circlecolor - for chords charts the circle color, default: back
#'   - chord - are the code chunk contain chord commands like `C 0003` to display chord charts for fretted instruments, default: false
#'   - ext  - the file extension if chord files are displayed, pdf or png are possible if cairosvg is installed, default: svg
#'   - imagepath - if chord diagrams are generated the path for the stored images in svg format, default: images
#'   - inline - are chords embedded inline within the text like this `Text [C]with [Am]chord!`, default: true (1)
#'   - label - the code chunk label used as well for the image name, default: null
#'   - results - should the output, the song text be show(n) or hid(d)e(n), default: show
#'   - transpose - how many steps up or down to transpose, can be negative or positive, 0 means no transpose default: 0
#'   - width - for chord charts the width of the chart, for Guitar a value of 160  is reasonable, for Ukulele a value of 100, default: 100
#' 
#' Options can be set globally in the YAML header for all chunks. Below is an example which hides per default always the source and
#' only shows the output.
#' 
#' ```
#'  ----
#'  title: "filter-tcrd.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2021-12-22
#'  tcrd:
#'      echo: 0
#'      eval: 1
#'  ----
#' ```
#'
#' ## Examples
#' 
#' Here an example for a song with an intro and verse and chorus:
#' 
#' ```
#'      ```{.tcrd echo=false eval=true}
#'      [Intro]
#'       
#'      [G] - [C] - [G] - [C] - [D7] - [G]
#'       
#'      [Verse]
#'      I'[G]ve been a wild rover for many a ye[C]ar
#'      I [G]spent all me m[C]oney on w[D7]hiskey and b[G]eer
#'      But [G]now I'm returning with gold in great st[C]ore
#'      And [G]I never will p[C]lay the wild r[D7]over no m[G]ore
#'  
#'      [Chorus]
#'      And it's no nay ne[D7]ver, no [G]nay never no m[C]ore
#'      Will I p[G]lay the wild ro[C]ver, no n[D7]ever, no m[G]ore
#'      ```
#' ```
#' 
#' And here is the output:
#' 
#' ```{.tcrd echo=false}
#' [Intro]
#' 
#' [G] - [C] - [G] - [C] - [D7] - [G]
#' 
#' [Verse]
#' I'[G]ve been a wild rover for many a ye[C]ar
#' I [G]spent all me m[C]oney on w[D7]hiskey and b[G]eer
#' But [G]now I'm returning with gold in great st[C]ore
#' And [G]I never will p[C]lay the wild r[D7]over no m[G]ore
#'  
#' [Chorus]
#' And it's no nay ne[D7]ver, no [G]nay never no m[C]ore
#' Will I p[G]lay the wild ro[C]ver, no n[D7]ever, no m[G]ore
#' ```
#'
#' To change the background color you just need to change the used style sheet
#' for your HTML file.
#' 
#' Let's now transpose the song by two steps from G to A. The 
#' chunk options are then just changed to: `{.tcrd echo=false eval=true transpose=2}`. Below the result:
#' 
#' ```{.tcrd echo=false transpose=2}
#' [Intro]
#'       
#' [G] - [C] - [G] - [C] - [D7] - [G]
#'       
#' [Verse]
#' I'[G]ve been a wild rover for many a ye[C]ar
#' I [G]spent all me m[C]oney on w[D7]hiskey and b[G]eer
#' But [G]now I'm returning with gold in great st[C]ore
#' And [G]I never will p[C]lay the wild r[D7]over no m[G]ore
#'  
#' [Chorus]
#' And it's no nay ne[D7]ver, no [G]nay never no m[C]ore
#' Will I p[G]lay the wild ro[C]ver, no n[D7]ever, no m[G]ore
#' ```
#' 
#' Here an other song, Scarborough Fair:
#' 
#' ```{.tcrd}
#' [Dm]Are you going to [C]Scarborough [Dm]Fair? 
#' [F]Parsley, [Dm]sage, rose [F]mary [G]and [Dm]thyme 
#' Remember [F]me to one who [C]lives there 
#' [Dm]He once [C]was a true love of [Dm]mine
#' ``` 
#' 
#' The same but transposed by two halfsteps up:
#'
#' ```{.tcrd transpose=2}
#' [Dm]Are you going to [C]Scarborough [Dm]Fair? 
#' [F]Parsley, [Dm]sage, rose [F]mary [G]and [Dm]thyme 
#' Remember [F]me to one who [C]lives there 
#' [Dm]He once [C]was a true love of [Dm]mine
#' ``` 
#'
#' Obviously in a song book you do not want to show the source code, you can
#' hide the source for the output by applying the chunk option `echo=false`.
#' 
#' Sometimes the chords are displayed above the text already,
#' you then might like to transpose the given chords.
#' You can do this by specifying the chunk option `inline=false` and
#' give again the number of desired halfstep like below with `transpose=2`:
#' 
#' ```{.tcrd transpose=2 inline=false}
#' C           G
#' Dat du mien Leevsten b¸st
#' Am          G  
#' dat du wohl weeﬂ
#' F                C          Am
#' Kumm bi de Nacht kumm bi de Nacht
#' G7         C 
#' segg wo du heeﬂt
#' F                C          Am
#' Kumm bi de Nacht kumm bi de Nacht
#' G7         C 
#' segg wo du heeﬂt
#' ```
#' 
#' ## Harmomics Tabs
#' 
#' You can combine Harmonica Tabs on top with embedded chords, here an example:
#' 
#' ```{.tcrd echo=true}
#' -4  -4  -6    -6 5  -5 5      -4
#' [Dm]Are you going to [C]Scarborough [Dm]Fair? 
#' -6  7    -8    7  -6 -7  6   -6
#' [F]Parsley, [Dm]sage, rose [F]mary [G]and [Dm]thyme 
#' -8 -8 -8  7  -6 -6  6   -5    5
#' Remember [F]me to one who [C]lives there 
#' -4  -6   6  -5  5    -4   4  -4
#' [Dm]He once [C]was a true love of [Dm]mine
#' ```
#'
#' 
#' ## Chord diagrams
#' 
#' Here an example for a chord diagram for some Ukulele chords, chunk options are `{.tcrd chord=true}`:
#' 
#' ```{.tcrd chord=true echo=true}
#' C  0003
#' Dm 2210
#' Em 0321
#' F  2010
#' G  0232
#' Am 2000
#' ```
#' 
#' And here some Guitar chords:
#' 
#' ```{.tcrd chord=true}
#' G   320003
#' Am  x02210
#' Bm  x24432
#' C   x32010
#' D   xx0232
#' Em  022000
#' ```
#' 
#' To hide the input code you would use `{.tcrd chord=true echo=false}` as a code chunk option.
#' 
#' The default output format is svg as this does not require any additional tools. 
#' If you have `cairosvg` installed you can as well create png or pdf files.
#' Here an example of a png file. For Guitar chord diagrams you should as well
#' extend the width of the image by using te width option, here an 
#' example `{.tcrd chord=true ext=png width=160}`: 
#' 
#' ```{.tcrd chord=true ext=png width=160}
#' C   x32010
#' Dm  xx0231
#' Em  022000
#' F   x03211
#' G   320003
#' Am  x02210
#' ```
#' 
#' ## See also:
#' 
#' * [Pantcl Readme](../../README.html)
#' * [https://chordseasy.com](https://chordseasy.com) (just use copy and paste of the chord song texts here)
#' * [https://ozbcoz.com/Songs/index.php](https://ozbcoz.com/Songs/index.php) again just copy and paste
#' * [https://www.mauimadison.com/songs.html](https://www.mauimadison.com/songs.html)
#' * [ABC music notation filter](filter-abc.html)
#' 
#' ## CHANGES
#' 
#' - 2023-07-14 adding non-inline chord transpose
#' - 2023-07-15 adding chord display for fretted instruments
#' 
#' ## TODO:
#' 
#' - chord diagrams
#' - F# vs Gb etc due to key

interp create tcrdi
set apath [tcrdi eval { set auto_path } ]
foreach d $auto_path {
    if {[lsearch $apath $d] == -1} {
        tcrdi eval  "lappend auto_path $d"
    }
}
# TODO

namespace eval tcrd {
    proc transpose {note step} {
        if {![regexp {^[A-G]} $note]} {
            return $note
        }
        # check for chord
        set note [string map [list A# Bb C# Db D# Eb F# Gb G# Ab] $note]
        set tp [regsub {^[A-G]b?} $note ""]
        set note [regsub {^([A-G]b?).*} $note "\\1"]
        set notes [list Ab A Bb B C Db D Eb E F Gb G]
        set idx [lsearch $notes $note]
        if {$idx == -1} {
            error "Error: Invalid idx=$idx note $note, valid ones are $notes!"
        }
        incr idx $step
        if {$idx < 0} {
            set idx [expr {12+$idx}]
        } elseif {$idx > 11} {
            set idx [expr {$idx-12}]
        }
        return [lindex $notes $idx]$tp
    }
    proc chords {song {transpose 0}} {
        set nsong  ""
        foreach line [split $song "\n"] {
            set chords ""
            set txt    ""
            if {[regexp {^\s*\[[A-Z0-9][a-z]{3}[ a-z]*\]\s*$} $line]} {
                append nsong "$line\n"
                continue
            }
            if {[regexp {^\s*[^a-zA-Z]+$} $line]} {
                append nsong "$line\n"
                continue
            }
            if {[regexp {^\s*\[[A-H][a-z0-9]*\]\s+-\s+\[[A-H][a-z0-9]*\].+} $line]} {
                set line [regsub -all {[\[\]]} $line ""]
                
                foreach crd [split $line " "] {
                    if {[regexp {^[A-G]} $crd]} {
                        append nsong [transpose $crd $transpose]
                    } else {
                        append nsong $crd
                    }
                    append nsong " "
                }
                append nsong "\n"
                continue
            }
            foreach block [split $line " "] {
                if {[regexp {^\[[-A-Za-z0-9]+\](.+)} $block]} {
                    # [Chord]text
                    set chord [transpose [regsub {\[(.+)\].+} $block "\\1"] $transpose]
                    set word  [regsub {\[.+\](.+)} $block "\\1"]
                    append txt $word
                    append chords $chord
                    set diff [expr {[string length $chord] - [string length $word]}]
                    if {$diff >= 0} {
                        append txt [string repeat " " [expr {$diff+1}]]
                        append chords " "
                    } elseif {$diff < 0} {
                        append chords [string repeat " " [expr {-$diff+1}]]
                        append txt " "
                    }
                } elseif {[regexp {.+\[[-A-Za-z0-9]+\](.+)} $block -> nblock]} {
                    # te[Chord]xt
                    set chord [transpose [regsub {.+\[(.+?)\].+} $block "\\1"] $transpose]
                    set word1  [regsub {(.+)\[.+?\].+} $block "\\1"]
                    set word2  [regsub {.+\[.+?\](.+)} $block "\\1"]                
                    append txt "$word1$word2 "
                    set nchord [string repeat " " [string length $word1]]
                    append nchord $chord
                    set nspaces [expr {[string length $word2] - [string length $chord] + 1}]
                    append nchord [string repeat " " $nspaces]
                    append chords $nchord
                    set block $word2
                    
                } elseif {[regexp {^\[[-A-Za-z0-9]+\]$} $block]} {
                    # [Chord]
                    set chord [transpose [regsub {\[(.+)\]} $block "\\1"] $transpose]
                    append chords "$chord "
                    append txt [string repeat " " [string length $chord]]
                    append txt " "
                } else {
                    # text only
                    set word $block
                    append chords [string repeat " " [string length $word]]
                    append chords " "
                    append txt "$word "
                }
            }
            if {[regexp {[a-zA-Z]} $txt]} {
                append nsong "$chords\n$txt\n"
            } else {
                append nsong "$chords\n"
            }
        }
        return $nsong
    }
    proc songtranspose {song transpose} {
        set nsong  ""
        foreach line [split $song "\n"] {
            if {[regexp { [a-z]{2}} $line] || [regexp {[,?!]} $line] || [regexp {[a-zA-Z][a-z]{4,}} $line]} {
                append nsong "$line\n"
            } else {
                set ochords [split $line " "]
                set nchords [list]
                foreach chrd  $ochords {
                    if {[regexp {^[A-G][#b]?} $chrd letter]} {
                        set tchrd [transpose $letter $transpose]
                        lappend nchords "$tchrd[string range $chrd [string length $letter] end]"
                    } else {
                        # whitespace probably
                        lappend nchords " "
                    }
                }
                set lag 0
                set nline ""
                for {set i 0} {$i < [llength $ochords]} {incr i 1} {
                    set o [lindex $ochords $i]
                    if {$o eq ""} {
                        if {$lag > 0}  {
                            append nline ""
                            incr lag -1
                        } else {
                            append nline " "
                        }
                        continue
                    }
                    set n [lindex $nchords $i]
                    set lag [expr {[string length $n] - [string length $o]}] 
                    if {$lag < 0} {
                        append nline "$n  "
                        set lag 0
                    } else {
                        append nline "$n "
                    }
                }
                append nsong "$nline\n"
            }
        }
        return $nsong
    }
    proc svgchords {name cstring args} {
        array set arg [list -circlecolor maroon -width 100]
        if {[llength $args] == 1} {
            set outfile [lindex $args 0]
        } elseif {[llength $args] > 1}  {
            array set arg $args
            if {[info exists arg(-outfile)]} {
                set outfile $arg(-outfile)
            } else {
                set outfile ""
            }
        } else {
            set outfile ""
        }
        tsvg set code ""
        tsvg set width $arg(-width)
        tsvg set height 255
        set ystart 48
        tsvg text x [expr {($arg(-width)/2)}] y 20 style "font: bold 24px sans-serif;" text-anchor middle $name 
        tsvg line x1 5 y1 $ystart x2 [expr {$arg(-width)-5}] y2 $ystart stroke-width 5 stroke black
        set inc [expr {($arg(-width)-20)/([string length $cstring]-1)}]
        for { set x 0 } { $x < [string length $cstring] } { incr x } {
            tsvg line x1 [expr {10+($x*$inc)}] y1 $ystart x2 [expr {10+($x*$inc)}] y2 248 stroke-width 2 stroke black
        }
        if {[string length $cstring] > 4} {
            set r 9
        } else {
            set r 9
        } 
        set mx 5
        for { set x 0 } { $x < $mx } { incr x } {    
            tsvg line x1 10 y1 [expr {$ystart+40+($x*40)}] x2 [expr {$arg(-width)-10}] y2 [expr {$ystart+40+($x*40)}] stroke-width 2 stroke black
            for {set y 0} { $y < [string length $cstring] } { incr y } {
                if {[string range $cstring $y $y] == $x} {
                    if {$x > 0} {
                        tsvg circle cx [expr {10+1+($y*$inc)}] cy [expr {$ystart-20+($x*40)}] r $r stroke $arg(-circlecolor) fill $arg(-circlecolor)
                    }
                }
                if {$x == 0 && [string range $cstring $y $y] == "x"} {
                    tsvg text x [expr {10+1+($y*$inc)}] y 42 style "font: 20px sans-serif;" text-anchor middle X
                } elseif {$x == 0 && [string range $cstring $y $y] == "0"} {
                    tsvg text x [expr {10+1+($y*$inc)}] y 42 style "font: 20px sans-serif;" text-anchor middle O
                }

                
                
            }
        }
        if {$outfile ne ""} {
            tsvg write $outfile
        } else {
            return [tsvg inline false]
        }
    }
}
proc filter-tcrd {cont dict} {
    global n
    incr n
    set def [dict create results show eval true include true label null transpose 0 inline true \
             chord false chordname "" imagepath images fig false ext svg \
             circlecolor black width 100]
    set dict [dict merge $def $dict]
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    if {[dict get $dict chord]} {
        dict set dict fig true
    }
        
    set owd [pwd] 
    if {[dict get $dict label] eq "null"} {
        set fname [file join $owd [dict get $dict imagepath] chord-$n].svg
    } else {
        set fname [file join $owd [dict get $dict imagepath] [dict get $dict label]].svg
    }

    if {[catch {
         set width [dict get $dict width]
         if {[dict get $dict chord]} {
             set ext .[dict get $dict ext]
             set svgall ""
             set x 0
             foreach line [split $cont "\n"] {
                 set line [string trim $line]
                 set line [regsub -all { +}  $line " "]
                 foreach {key frets} [split $line " "] {
                     append svgall "<g transform=\"translate([expr {$x*($width+20)}], 0)\">\n"
                     append svgall [tcrd::svgchords $key $frets -circlecolor [dict get $dict circlecolor] -width $width]
                     append svgall "\n</g>\n"
                 }
                 incr x

             }
             set out [open $fname w 0600]
             puts $out "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>"
             puts $out "   <svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" height=\"255\" width=\"[expr {($width+20)*$x}]\">"
             puts $out $svgall
             puts $out "</svg>"
             close $out
             if {$ext in [list .pdf .png]} {
                 if {[auto_execok cairosvg] eq ""} {
                     error "Conversion to $ext needs the cairosvg tool!"
                 }
             } elseif {$ext ne ".svg"}  {
                 error "Unkown file extension, know file extensions are: .svg, .pdf, .png"
             }
             set outfile [regsub {.svg$} $fname $ext]
             if {$ext in [list .pdf .png]} {
                 exec cairosvg $fname -o $outfile -W [expr {($width+20)*$x}] -H 255
                 set fname $outfile
             } 
             set res $cont
         } elseif {[dict get $dict inline]} {
             set res [tcrd::chords $cont [dict get $dict transpose]] 
         } elseif {[dict get $dict transpose] == 0}  {
             set res $cont
         } else {
             set res [tcrd::songtranspose $cont [dict get $dict transpose]] 
         }
     }]} {
         set res "Error: [regsub {\n +invoked.+} $::errorInfo {}]"
     }

    if {[dict get $dict results] eq "hide"} {
        set res ""
    }
    if {![dict get $dict fig]} {
        set fname ""
    } else {
        set res ""
    }
    return [list $res $fname]
}



