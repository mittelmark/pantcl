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
#'   with music chord names above the text where the chords are directly embedded within the song text.
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
#'   - inline - are chords embedded inline within the text like this `Text [C]with [Am]chord!`, default: true (1)
#'   - label - the code chunk label used as well for the image name, default: null
#'   - results - should the output, the song text be show(n) or hid(d)e(n), default: show
#'   - transpose - how many steps up or down to transpose, can be negative or positive, 0 means no transpose default: 0
#' 
#' Options can be set globally in the YAML header for all chunks. Below is an example which shows only the source but not the output.
#' 
#' ```
#'  ----
#'  title: "filter-tcrd.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2021-12-22
#'  tdot:
#'      echo: true
#'      results: hide
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
#' Dat du mien Leevsten b�st
#' Am          G  
#' dat du wohl wee�
#' F                C          Am
#' Kumm bi de Nacht kumm bi de Nacht
#' G7         C 
#' segg wo du hee�t
#' F                C          Am
#' Kumm bi de Nacht kumm bi de Nacht
#' G7         C 
#' segg wo du hee�t
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
#tcrdi eval "package require tdot"

namespace eval tcrd {
    proc transpose {note step} {
        # check for chord
        set note [string map [list A# Bb C# Db D# Eb F# Gb G# Ab] $note]
        set tp [regsub {^[A-G]b?} $note ""]
        set note [regsub {^([A-G]b?).+} $note "\\1"]
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
            if {[regexp {^\s*\[[A-Z][a-z]{3}[ a-z]*\]\s*$} $line]} {
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
                if {[regexp {^\[[A-Za-z0-9]+\].+} $block]} {
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
                } elseif {[regexp {.+\[[A-Za-z0-9]+\].+} $block]} {
                    # te[Chord]xt
                    set chord [transpose [regsub {.+\[(.+)\].+} $block "\\1"] $transpose]
                    set word1  [regsub {(.+)\[.+\].+} $block "\\1"]
                    set word2  [regsub {.+\[.+\](.+)} $block "\\1"]                
                    append txt "$word1$word2 "
                    set nchord [string repeat " " [string length $word1]]
                    append nchord $chord
                    set nspaces [expr {[string length $word2] - [string length $chord] + 1}]
                    append nchord [string repeat " " $nspaces]
                    append chords $nchord
                } elseif {[regexp {^\[[A-Za-z0-9]+\]$} $block]} {
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
            append nsong "$chords\n$txt\n"
        }
        return $nsong
    }
    proc songtranspose {song transpose} {
        set nsong  ""
        foreach line [split $song "\n"] {
            if {[regexp { [a-z]{2}} $line] || [regexp {[,?!]} $line]} {
                append nsong "$line\n"
            } else {
                set nline ""
                foreach chrd [split $line " "] {
                    if {[regexp {^[A-G][#b]?} $chrd letter]} {
                        set tchrd [transpose $letter $transpose]
                        set nblock $tchrd
                        append nblock [string range $chrd [string length $letter] end]
                        append nline $nblock 
                    } else {
                        # whitespace probably
                        append nline " "
                    }
                }
                append nsong "$nline\n"
            }
        }
        return $nsong
    }
}
proc filter-tcrd {cont dict} {
    global n
    incr n
    set def [dict create results show eval true include true label null transpose 0 inline true]
    set dict [dict merge $def $dict]
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    if {[catch {
         if {[dict get $dict inline]} {
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
    return [list $res ""]
}



