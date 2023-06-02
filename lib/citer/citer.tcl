#!/usr/bin/env tclsh
#' ---
#' title: Tcl application and package dealing with bibtex references.
#' author: Detlef Groth, University of Potsdam, Germany
#' date: <230530.1427>
#' tcl:
#'     eval: 1
#' bibliography: assets/literature.bib
#' ----
##############################################################################
#
#  Notes         : The package is mainly used for the pantcl document processor
#                  which can be as well used as a pandoc filter application
#
#  History       : 2023-05-25: initial version
#                  2023-05-26: first functional version created with aid of ChatGPT
#	
##############################################################################
#
#  Copyright (c) 2023 Dr. Detlef Groth.
# 
#  License:      BSD3
# 
##############################################################################
#' 
#' ## NAME
#'
#' _citer.tcl_ - application and Tcl package to display Bibtex referencess
#' 
#' ## SYNOPSIS - CLI
#' 
#' ```
#' ### show some bibtex references
#' citer.tcl BIBTEXFILE KEY1 ?KEY2 ...?
#' ### show all ids in the bibtex file
#' citer.tcl BIBTEXFILE  
#' ```
#'
#' ## SYNOPSIS - package
#' 
#' ```
#' package require citer
#' citer::bibliography ?BIBTEXFILE?
#' citer::cite KEYLIST
#' citer::getKeys ?BIBTEXFILE?
#' citer::getReference BIBTEXFILE KEY1 ?KEY2 ...?
#' citer::reset
#' citer::style INLINE BIBLIO
#' ```
#' 
#' ## METHODS
#' 

package require Tcl
package require bibtex
package provide citer 0.1.0

namespace eval citer {
    variable style 
    variable cites [list]
    variable bibliography ""
    variable format md
    variable refstyle
    array set style [list inline abbrev biblio APA]
    array set refstyle [list \
                        article {{author} ({year}). {title}. {journal} {volume}: {pages}.} \
                        incollection {{author} ({year}). {title}. In: {booktitle}, {publisher}. {volume}: {pages}.} \
                        misc {{author} ({year}). {title}. {url} {note}} \
                        default {{author} ({year}). {title}. {publisher}.}] 
    proc usage { } {
        puts "citer \[BIBTEXFILE\] ref1 ref2 ..."
    }
    #' **citer::bibliography** *?filename format?*
    #' 
    #' > Returns the citation list. If filename is not given the 
    #'   default filename _references.bib_ is assumed, if the function
    #'   bibliography is called before any cite functions are called simply
    #'   the default bibliography file is configured.
    #' 
    proc bibliography {args} {
        variable cites
        variable style
        variable bibliography
        variable format 
        if {[llength $args] == 0 && $bibliography eq ""} {
            set bibliography references.bib
        } elseif {[llength $args] > 0} {
            if {[file exists [lindex $args 0]]} {
                set bibliography [lindex $args 0]
            } else {
                set format [lindex $args 0]
            }
            if {[llength $args] > 1} {
                set format [lindex $args 1]
            }
        }
        if {[llength $cites] == 0} {
            return
        }
        set filename $bibliography
        set res ""
        set i 1
        if {$style(biblio) eq "APA"} {
            if {$style(inline) eq "abbrev"} {
                set cs [lsort $cites]
                foreach cite $cs {
                    if {$format eq "md"} {
                        append res "* __\[$cite\]__ - [getReference $filename $cite]\n"
                    } else {
                        lappend res [list $cite [getReference $filename $cite]]
                    }
                }
            } else {
                set i 0
                foreach cite $cites {
                    if {$format eq "md"} {
                        append res "* __\[[incr i]\]__ - [getReference $filename $cite]\n"
                    } else {
                        lappend res [list $cite [getReference $filename $cite]]
                    }
                }
            }
        }
        return $res
    }
    #' **citer::cite** *keylist*
    #' 
    #' > Adds the given keys to the citation list.
    #' 
    proc cite {keys} {
        variable cites 
        variable style
        set res [list]
        set idxs [list]
        foreach key $keys {
            set idx [lsearch $cites $key]
            if {$idx == -1} {
                lappend cites $key
                set idx [llength $cites]
            } else {
                incr idx
            }
            lappend res $key
            lappend idxs $idx
        }
        if {$style(inline) eq "abbrev"} {
            return "\[[join $keys ,]\]"
        } else {
            return "\[[join $idxs ,]\]"
        }
    }
        
    #' **citer::getKeys** *BIBTEXFILE*
    #' 
    #' > Returns all available keys for the given file.
    #' 
    proc getKeys {filename} {
        set bibobj [Bibdata $filename]
        set ids [list]
        set i 0
        foreach item $bibobj {
            lappend ids [lindex $bibobj $i 1]
            incr i
        }
        return [lsort $ids]
    }
    #' **citer::getReference** ?BIBTEXFILE KEYLIST?
    #' 
    #' > Returns formatted sequences for the given file and keys.
    #' 
    proc getReference {filename identifier} {
        variable refstyle
        set bibobj [Bibdata $filename]
        set i 0
        set reference ""
        set type article
        if {[llength $identifier] > 1} {
            set res [list]
            foreach id $identifier {
                lappend res [getReference $identifier]
            } 
            return $res
        }
        foreach item $bibobj {
            set type [lindex $bibobj $i 0]
            if {[lindex $bibobj $i 1] eq $identifier} {
                set reference [lindex $bibobj $i]
                break
            }
            incr i
        }
        if {$reference ne ""} {
            dict set ref {*}$reference
            array set res [list]
            foreach key [list author year title journal publisher volume pages booktitle note url] {
                if {[dict exists $ref $type $identifier $key]} {
                    set res($key) [dict get $ref $type $identifier $key]
                    if {$key eq "author"} {
                        set res(author) [regsub -all {, ([A-Z])[a-z]+ and } $res(author) ", \\1. and "]
                        set res(author) [regsub -all { +and +} $res(author) ", "]
                        set res(author) [regsub {, ([A-Z])[a-z]+$} $res(author) ", \\1."]
                    } 
                } else {
                    set res($key) NA
                }
            }
            set res(pages) [regsub -- {--} $res(pages) "-"]
            if {$type ni [list article incollection misc]} {
                set type default
            } 
            set fmt $refstyle($type)
            foreach key [array names res] {
                set fmt [regsub "\{$key\}" $fmt $res($key)]
            }
            set fmt [regsub -all {\.\.}  $fmt "."]
            return $fmt
        } else {
            return "Error: $identifier - reference not found!"
        }
    }
    #' **citer::refstyle** *-type1 formatsting ?-type2 formatstring?*
    #' 
    #' > Create the appropriate format strings for the different reference types
    #'   like journal, book, inproceedings, default etc.
    #' 
    #' > Arguments: 
    #' 
    #' > - *-article FORMATSTRING*
    #'   - *-book FORMATSTRING*
    #' 
    #' > Example:
    #' 
    #' > ```{.tcl eval=true}
    #' citer::refstyle \
    #'   -article "{author} ({year}). {title}. _{journal}_ {volume}: {pages}" \
    #'   -incollection "{author} ({year}). {title}. In: _{booktitle}_, {publisher}. {volume}: {pages}." \
    #'   -default "{author} ({year}). {title}. {publisher}." 
    #' citer::getReference assets/literature.bib Groth2013
    #' > ```
    #' 
    proc refstyle {args} {
        variable refstyle
        foreach {key val} $args {
            set key [string range $key 1 end]
            set refstyle($key) $val
        }
    }
    #' **citer::reset** inline biblio
    #' 
    #' > Clears the list of previously given references.
    #'   Should be given only for debugging usually.
    #' 
    #' > Arguments: None
    #' 
    proc reset {} {
        variable cites 
        set cites [list]
    }
    #' **citer::style** *inline biblio*
    #' 
    #' > Sets the style for inline citations and for the bibliography at the end.
    #' 
    #' > Arguments: - _inline_ - either numeric or abbrev, default: abbrev
    #'              - _biblio_ - the style of the literature list, currently only APA is supported, which is the default
    #' 
    proc style {inline {biblio APA}} {
        variable style
        set style(inline) $inline
        set style(biblio) $biblio
        return ""
    }
    # private functions
    proc Bibdata {filename} {
        if {![file exists $filename]} {
            error "Error: file $filename does not exists"
        }
        # Open the Bibtex file
        set bibfile [open $filename r]
        set bibdata [read $bibfile]
        close $bibfile
        # Parse the Bibtex data
        set bibobj [::bibtex::parse $bibdata]
        return $bibobj
    }
}
#' 
#' ## EXAMPLES
#' 
#' First an example on how to use this package directly within Tcl applications.
#' 
#' ```{.tcl eval=true}
#' citer::bibliography assets/literature.bib
#' citer::cite Groth2013
#' citer::cite Sievers2011
#' citer::cite wiki:blast
#' puts "####### Tcllist like ###########"
#' foreach item [citer::bibliography tcl] {
#'    puts "[lindex $item 0] ---- [lindex $item 1]"
#' }
#' puts "####### Markdown like ###########"
#' foreach item [citer::bibliography] {
#'    puts "* __[lindex $item 0]__ - [lindex $item 1]"
#' }
#' citer::reset ;# remove all keys from citation list
#' ```
#' Now an example with inline text:
#' 
#' Here an example with a few citations. The package should be usually used within
#' Markdown documents processed with the [pantcl](https://github.com/pantcl) document processor.
#'
#' ```{.tcl eval=true}
#' citer::style numeric APA
#' ```
#' 
#' Here some example input:
#' 
#' ```
#' This filter as well supports basic reference management using Bibtex files.
#' Citations should be embedded like this: `tcl citer::cite Sievers2011` where 
#' _Sievers2011_ is a Bibtex key in your Bibtex file. Here is an other citation 
#' `tcl cite Yachdav2016`. And here is a PCA article from my self `tcl cite Groth2013`. 
#' And now a cite command with two citations.
#' The Wilcox comparison of two samples and the Spearman correlation are 
#' non-parametric methods `tcl cite Wilcoxon1945 Spearman1904`.
#'
#' In case we cite the same paper again the numbers should not be updated.
#' So let's cite Sivers2011 `tcl cite Sievers2011` again which should produce
#' again a number 1 citation. Instead of citer the approach embedding references
#' using the at sign should work as well. Here is an example for 
#' Sievers et. al [@Sievers2011].
#' ```
#' 
#' And here the output:
#' 
#' This filter as well supports basic reference management using Bibtex files.
#' Citations should be embedded like this: `tcl citer::cite Sievers2011` where 
#' _Sievers2011_ is a Bibtex key in your Bibtex file. Here is an other citation 
#' `tcl cite Yachdav2016`. And here is a PCA article from my self `tcl cite Groth2013`. 
#' And now a cite command with two citations.
#' The Wilcox comparison of two samples and the Spearman correlation are 
#' non-parametric methods `tcl cite Wilcoxon1945 Spearman1904`.
#'
#' In case we cite the same paper again the numbers should not be updated.
#' So let's cite Sivers2011 `tcl cite Sievers2011` again which should produce
#' again a number 1 citation. Instead of citer the approach embedding references
#' using the at sign should work as well. Here is an example for 
#' Sievers et. al [@Sievers2011].
#' 
#' The citations list can be then finally displayed like this:
#' 
#' ```{.tcl eval=true results="asis"}
#' bibliography assets/literature.bib
#' ```
#' 
#' There is currently only an other style available, 'abbrev':
#' to use the style within the same document we have to call the bibstyle
#' command again.
#' 
#' ```{.tcl eval=true}
#' bibstyle abbrev
#' ```
#' 
#' Let's now write just the same text again.
#' This filter as well supports basic reference management using Bibtex files.
#' Citations should be embedded like this: `tcl cite Sievers2011` where _Sievers2011_ is a
#' Bibtex key in your Bibtex file. Here is an other citation `tcl cite Yachdav2016`.
#' And here is a PCA article from my self `tcl cite Groth2013`.
#'
#' In case we cite the same paper again the numbers should not be updated.
#' So let's cite Sivers2011 `tcl cite Sievers2011` again which should produce
#' again a number 1 citation.
#' 
#' The citations list can be then finally displayed like this:
#' 
#' ```{.tcl eval=true results="asis"}
#' bibliography assets/literature.bib
#' ```

#' 
## Cleanup Bibtex
## https://flamingtempura.github.io/bibtex-tidy/index.html?opt=%7B%22modify%22%3Atrue%2C%22curly%22%3Atrue%2C%22numeric%22%3Atrue%2C%22months%22%3Afalse%2C%22space%22%3A2%2C%22tab%22%3Atrue%2C%22align%22%3A13%2C%22duplicates%22%3A%5B%22key%22%5D%2C%22stripEnclosingBraces%22%3Afalse%2C%22dropAllCaps%22%3Afalse%2C%22escape%22%3Afalse%2C%22sortFields%22%3A%5B%22title%22%2C%22shorttitle%22%2C%22author%22%2C%22year%22%2C%22month%22%2C%22day%22%2C%22journal%22%2C%22booktitle%22%2C%22location%22%2C%22on%22%2C%22publisher%22%2C%22address%22%2C%22series%22%2C%22volume%22%2C%22number%22%2C%22pages%22%2C%22doi%22%2C%22isbn%22%2C%22issn%22%2C%22url%22%2C%22urldate%22%2C%22copyright%22%2C%22category%22%2C%22note%22%2C%22metadata%22%5D%2C%22stripComments%22%3Afalse%2C%22trailingCommas%22%3Afalse%2C%22encodeUrls%22%3Afalse%2C%22tidyComments%22%3Atrue%2C%22removeEmptyFields%22%3Afalse%2C%22removeDuplicateFields%22%3Afalse%2C%22lowercase%22%3Atrue%2C%22backup%22%3Atrue%7D
set biblio {
@article{Sievers2011,
	title        = {{{F}ast, scalable generation of high-quality protein multiple sequence alignments using {C}lustal {O}mega}},
	author       = {Sievers, F.  and Wilm, A.  and Dineen, D.  and Gibson, T. J.  and Karplus, K.  and Li, W.  and Lopez, R.  and McWilliam, H.  and Remmert, M.  and Soding, J.  and Thompson, J. D.  and Higgins, D. G. },
	year         = 2011,
	month        = {Oct},
	journal      = {Mol. Syst. Biol.},
	volume       = 7,
	pages        = 539
}
@article{Yachdav2016,
	title        = {MSAViewer: interactive JavaScript visualization of multiple sequence alignments},
	author       = {Yachdav, Guy and Wilzbach, Sebastian and Rauscher, Benedikt and Sheridan, Robert and Sillitoe, Ian and Procter, James and Lewis, Suzanna E. and Rost, Burkhard and Goldberg, Tatyana},
	year         = 2016,
	journal      = {Bioinformatics},
	volume       = 32,
	number       = 22,
	pages        = 3501,
	doi          = {10.1093/bioinformatics/btw474},
	url          = {http://dx.doi.org/10.1093/bioinformatics/btw474}
}
}
set biblio [bibtex::parse $biblio]

if {[info exists argv0] && $argv0 eq [info script] && [regexp citer $argv0]} {
    if {[llength $argv] > 0} {
        if {[lindex $argv 0] eq "--help"} {
            citer::usage
        } elseif  {[lindex $argv 0] eq "--version"} {
            puts "[package present citer]"
        } elseif {[lindex $argv 0] eq "--test"} {
            package require tcltest
            set argv [list] 
            tcltest::test dummy-1.1 {
                Calling my proc should always return a list of at least length 3
            } -body {
                set result 1
            } -result {1}
            tcltest::cleanupTests
            catch { destroy . }
        } else {
            set filename [lindex $argv 0]
            set keys [lrange $argv 1 end]
            if {[llength $keys] == 0} {
                foreach key [citer::getKeys $filename] {
                    puts $key
                }
            } else {
                foreach key $keys {
                    puts [citer::getReference $filename $key]
                }
            }
        }
    } else {
        citer::usage
    }   
}
#'
#' ## TODO
#' 
#' - test format strings like "`{author} ({year}). {title}. {volume}:{number} {pages}.`" for different categories, article, book, inprooceedings, etc.
#' 
#' ## AUTHOR
#' 
#' Detlef Groth, University of Potsdam, Germany, dgroth(_at_)uni-potsdam(_dot_).de
#' 
#' ## LICENSE
#' 
#' ```
#' BSD 3-Clause License
#'
#' Copyright (c) 2023, Detlef Groth, University of Potsdam
#' 
#' Redistribution and use in source and binary forms, with or without
#' modification, are permitted provided that the following conditions are met:
#' 
#' 1. Redistributions of source code must retain the above copyright notice, this
#'    list of conditions and the following disclaimer.
#'
#' 2. Redistributions in binary form must reproduce the above copyright notice,
#'    this list of conditions and the following disclaimer in the documentation
#'    and/or other materials provided with the distribution.
#'
#' 3. Neither the name of the copyright holder nor the names of its
#'    contributors may be used to endorse or promote products derived from
#'    this software without specific prior written permission.
#' 
#' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#' IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#' FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#' DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#' SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#' CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#' OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#' OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#' ```
#'
