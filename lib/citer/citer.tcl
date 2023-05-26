#!/usr/bin/env tclsh
#' ---
#' title: Tcl application and package dealing with bibtex references.
#' author: Detlef Groth, University of Potsdam, Germany
#' date: <230526.1424>
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
#  License:      MIT
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
#' citer::getReference BIBTEXFILE KEY1 ?KEY2 ...?
#' ```
#' 
#' ## METHODS
#' 

package require Tcl
package require bibtex
package provide citer 0.1

namespace eval citer {
    proc usage { } {
        puts "citer \[BIBTEXFILE\] ref1 ref2 ..."
    }
    
    #' **citer::getKeys** BIBTEXFILE
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
    #' **citer::getReference** BIBTEXFILE KEYLIST
    #' 
    #' > Returns formatted sequences for the given file and keys.
    #' 
    proc getReference {filename identifier} {
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
            foreach key [list author year title journal publisher volume pages] {
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
            if {$type eq "article"} {
                return "$res(author) ($res(year)).\n  $res(title).\n  $res(journal) $res(volume): $res(pages)."
            } else {
                return "$res(author) ($res(year)).\n  $res(title).\n  $res(publisher)."
            }
        } else {
            return "Error: $identifier - reference not found!"
        }
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

