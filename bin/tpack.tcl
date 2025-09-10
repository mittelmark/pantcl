#!/usr/bin/env tclsh
##############################################################################
#
#  Author        : Detlef Groth
#  Created By    : Detlef Groth
#  Created       : Tue Sep 7 17:58:32 2021
#  Last Modified : <250104.1058>
#
#  Description	 : Standalone deployment tool for Tcl apps using uncompressed tar archives.
#
#  Notes         : - tpack application code comes at the end
#                  - no extra package are required, tar package is embedded 
#
#  History       : 2021-09-10 - release 0.1   (two file applications)
#                  2021-11-09 - release 0.2.0 (single file application)
#                  2021-11-26 - release 0.2.1 (tar package fix)
#                  2022-02-16 - release 0.3.0 (lz4 compression support)
#                  2024-03-14 - release 0.3.1 (docu updates, project moved)
#                  2025-01-02 - release 0.4.0/1 Tcl 9 aware
#                  2025-01-03 - release 0.5.0 Tcl 8.5, 8.6, 9.0 aware, switch 
#                                             from tar to base64 wrappping
#                  
#	
##############################################################################
#
#  Copyright (c) 2021-2025 Detlef Groth, University of Potsdam, Germany
# 
#  License:      BSD 3-Clause License
# 
##############################################################################

if {![package vsatisfies [package provide Tcl] 8.5 9]} { return }

## File tpack-b64.tcl
#' ---
#' title: tpack - Tcl application deployment
#' section: 1
#' header: User Manual
#' footer: tpack 0.5.0
#' author: Detlef Groth, University of Potsdam, Germany
#' date: 2025-01-04
#' ---
#' 
#' ## NAME 
#' 
#' _tpack_ - create single or two file Tcl applications based on libraries in tar/lz4 archives
#' 
#' ## SYNOPSIS
#' 
#' ```
#' $ tpack --help               # display usage information
#' $ tpack wrap app.tapp        # wraps app.tcl and app.vfs into app.tapp 
#'                              # where app.vfs is attached as base64 archive
#' $ tpack wrap app.tapp --lz4  # as above but use base64 and lz4 for compression
#' $ tpack init app.tcl app.vfs # creates initial file app.tcl and folder app.vfs
#' $ tpack init app             #            as above
#' $ tpack init app.vfs         # create initial folder app.vfs
#' $ tpack unwrap app.tapp      # extracts app.tcl and app.vfs out of app.tapp
#' ```
#' 
#' ## DESCRIPTION
#' 
#' The _tpack_ application can be used to simplify deployment of Tcl applications to other computers and customers.
#' The application can create single file Tcl applications. 
#' These single file applications, called tapp-files contain at the top the base64 / lz4 extraction code,
#' the main tcl script and an attached base64 archive where all files are encoded using base64 and file separation
#' lines containing the libraries required by this application file. At startup the base64 encoded files are
#' detached from the file and unpacked into a temporary folder from where the libraries are loaded. 
#' The compression with lz4 needs an installed lz4 executable, the decompression of
#' the build executable is embedded into the final application but requires a Tcl installation of at least 8.5.
#' 
#' The single file approach creates _app.tapp_ file out of _app.vfs_ and _app.tcl_.
#'
#' ```
#' tpack wrap app.tapp
#' ```
#' 
#' The file _main.tcl_ in the vfs-folder should contain at least the following line:
#' 
#' ```
#' lappend auto_path [file join [file dirname [info script]] lib]
#' ```
#' 
#' The _tpack_ application provides as well a loader for default starkit layouts, so a fake starkit package so that 
#' as well existing starkits can be packed by _tpack_, here a _main.tcl_ file from the tknotepad application.
#'
#' ```
#' package require starkit
#' if {[starkit::startup] == "sourced"} return
#' package require app-tknotepad
#' ```
#' 
#' In this case the application file tknotepad.tcl which is in the same directoy as _tknotepad.vfs_ can be just an empty file. It can as well contain code to handel command line arguments.
#' Here the file tknotepad.tcl:
#' 
#' ```
#' proc usage {} {
#'     puts "Usage: tknotepad filename"
#' }
#' if {[info exists argv0] && $argv0 eq [info script] && [regexp tknotepad $argv0]} {
#'     if {[llength $argv] > -1 && [lsearch $argv --help] > -1} {
#'         usage
#'     } elseif {[llength $argv] > 0 && [file exists [lindex $argv 0]]} {
#'         openoninit [lindex $argv 0]
#'     }
#' }
#' ```
#' 
#' That way you should be able to use your vfs-folder for creating tpacked applications
#' as well for creating starkits.
#'
#' ## INSTALLATION
#' 
#' Make this file [tpack-b64.tcl](https://raw.githubusercontent.com/mittelmark/tpack/refs/heads/main/tpack-b64.tcl)
#' executable and copy it as _tpack_ into a directory belonging to your
#' PATH environment. There are no other Tcl libraries required to install, just a working installation
#' of Tcl/Tk of at least Tcl 8.5 is required.
#' 
#' ## EXAMPLE
#' 
#' Let's demonstrate a minimal application:
#' 
#' ```
#' ## FILE mini.tcl
#' #!/usr/bin/env tclsh
#' package require test
#' puts mini
#' puts [test::hello]
#' ## FILE mini.vfs/main.tcl
#' lappend auto_path [file join [file dirname [info script]] lib]
#' ## FILE mini.vfs/lib/test/pkgIndex.tcl
#' package ifneeded test 0.1 [list source [file join $dir test.tcl]]
#' ## FILE mini.vfs/lib/test/test.tcl
#' package require Tcl
#' package provide test 0.1
#' namespace eval ::test { }
#' proc ::test::hello { } { puts "Hello World!" }
#' ## EOF's
#' ```
#' There is the possibility to create such a minimal application automatically for you if you start a new project
#' by using the command line options:
#' 
#' ```
#' $ tpack init appname
#' # - appname.tcl and appname.vfs folder with main.tcl and
#' #   lib/test Tcl files will be created automatically for you.
#' ```
#' 
#' The string _appname_ has to be replaced with the name of your application. 
#' If a the Tcl file or the VFS folder does already exists, _tpack_ for your safeness
#' will refuse to overwrite them. 
#' If the files were created, you can overwrite the Tcl file (_appname.tcl_)
#' with your own application and move your libraries into the folder 
#' _appname.vfs_.  If you are ready you call `tpack wrap appname.tcl appname.vfs` and 
#' you end up with two new files, _appname.ttcl_ your application code file, containing 
#' your code as well as some code to encode and decode base64 files.
#' 
#' Attention: if mini.tapp is executed directly in the directory where mini.vfs is 
#' located not the mini.tapp file but the folder will be used for the libraries. That can simplify the development.
#' 
#' You can rename mini.tapp to what every you like so `mini.bin` or even `mini`.
#' 
#' ## CHANGELOG
#' 
#' - 2021-09-10 - release 0.1  - two file applications (ttcl and ttar) are working
#' - 2021-11-10 - release 0.2.0 
#'     - single file applications (ttap = ttcl+ttar in one file) are working as well
#'     - fake starkit::startup to load existing starkit apps without modification
#'     - build sample apps tknotepad, pandoc-tcl-filter, 
#' - 2021-11-26 - release 0.2.1 
#'     - bugfix: adding `package forget tar` after tar file loading to catch users `package require tar`
#' - 2022-02-16 - release 0.3.0
#'     - support for lz4 compression/decompression
#' - 2024-03-14 - release 0.3.1
#'     - docu updates
#'     - project moved to its own repo https://github.com/mittelmark/tpack
#' - 2025-01-01 - release 0.4.0
#'     - making it Tcl 9 aware
#' - 2025-01-02 - release 0.4.1
#'     - making it Tcl 9 aware, anohter fix
#' - 2025-01-03 - rewrite using base64 instead of tar and as well only supporting single file
#'                approach, so tapp files
#' ## TODO
#' 
#' - nsis installer for Windows, to deploy minimal Tcl/Tk with the application
#'
#' ## AUTHOR
#' 
#'   - Copyright (c) 2021-2025 Detlef Groth, University of Potsdam, Germany, dgroth(at)uni(minus)potsdam(dot)de (tpack code)
#'   - Copyright (c) 2017 dbohdan pur Tcl lz4 decompression code
#'   - Copyright (c) 2013 Andreas Kupries andreas_kupries(at)users.sourceforge(dot)net (tar code)
#'   - Copyright (c) 2004 Aaron Faupell afaupell(at)users.sourceforge(sot)net (tar code)
#' 
#' ## LICENSE
#'
#' ```
#' BSD 3-Clause License
#'
#' Copyright (c) 2021-2025 Detlef Groth, University of Potsdam, Germany
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
package require Tcl
package provide tpack 0.5.0

## FILE: b64.tcl
#!/usr/bin/env tclsh
# Partial code from Tcllib for Tcl 8.5
# https://core.tcl-lang.org/tcllib/file?name=modules/base64/base64.tcl&ci=tip
# base64.tcl --
#
# Encode/Decode base64 for a string
# Stephen Uhler / Brent Welch (c) 1997 Sun Microsystems
# The decoder was done for exmh by Chris Garrigues
#
# Copyright (c) 1998-2000 by Ajuba Solutions.
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.

# Version 1.0   implemented Base64_Encode, Base64_Decode
# Version 2.0   uses the base64 namespace
# Version 2.1   fixes various decode bugs and adds options to encode
# Version 2.2   is much faster, Tcl8.0 compatible
# Version 2.2.1 bugfixes
# Version 2.2.2 bugfixes
# Version 2.3   bugfixes and extended to support Trf
# Version 2.4.x bugfixes

package require Tcl 8.5-
namespace eval base64 {
    variable base64 {}
    variable base64_en {}
    
    # We create the auxiliary array base64_tmp, it will be unset later.
    variable base64_tmp
    variable i
    
    variable i 0
    variable char
    foreach char {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
              a b c d e f g h i j k l m n o p q r s t u v w x y z \
              0 1 2 3 4 5 6 7 8 9 + /} {
        set base64_tmp($char) $i
        lappend base64_en $char
        incr i
    }
    
    #
    # Create base64 as list: to code for instance C<->3, specify
    # that [lindex $base64 67] be 3 (C is 67 in ascii); non-coded
    # ascii chars get a {}. we later use the fact that lindex on a
    # non-existing index returns {}, and that [expr {} < 0] is true
    #
    
    # the last ascii char is 'z'
    variable char
    variable len
    variable val
    
    scan z %c len
    for {set i 0} {$i <= $len} {incr i} {
        set char [format %c $i]
        set val {}
        if {[info exists base64_tmp($char)]} {
            set val $base64_tmp($char)
        } else {
            set val {}
        }
        lappend base64 $val
    }
    
    # code the character "=" as -1; used to signal end of message
    scan = %c i
    set base64 [lreplace $base64 $i $i -1]
    
    # remove unneeded variables
    unset base64_tmp i char len val
    
    namespace export encode decode
}

# ::base64::encode --
#
#	Base64 encode a given string.
#
# Arguments:
#	args	?-maxlen maxlen? ?-wrapchar wrapchar? string
#
#		If maxlen is 0, the output is not wrapped.
#
# Results:
#	A Base64 encoded version of $string, wrapped at $maxlen characters
#	by $wrapchar.

proc ::base64::encode {args} {
    set base64_en $::base64::base64_en
    
    # Set the default wrapchar and maximum line length to match
    # the settings for MIME encoding (RFC 3548, RFC 2045). These
    # are the settings used by Trf as well. Various RFCs allow for
    # different wrapping characters and wraplengths, so these may
    # be overridden by command line options.
    set wrapchar "\n"
    set maxlen 76
    
    if { [llength $args] == 0 } {
        error "wrong # args: should be \"[lindex [info level 0] 0]\
        ?-maxlen maxlen? ?-wrapchar wrapchar? string\""
    }
    
    set optionStrings [list "-maxlen" "-wrapchar"]
    for {set i 0} {$i < [llength $args] - 1} {incr i} {
        set arg [lindex $args $i]
        set index [lsearch -glob $optionStrings "${arg}*"]
        if { $index == -1 } {
            error "unknown option \"$arg\": must be -maxlen or -wrapchar"
        }
        incr i
        if { $i >= [llength $args] - 1 } {
            error "value for \"$arg\" missing"
        }
        set val [lindex $args $i]
        
        # The name of the variable to assign the value to is extracted
        # from the list of known options, all of which have an
        # associated variable of the same name as the option without
        # a leading "-". The [string range] command is used to strip
        # of the leading "-" from the name of the option.
        #
        # FRINK: nocheck
        set [string range [lindex $optionStrings $index] 1 end] $val
    }
    
    # [string is] requires Tcl8.2; this works with 8.0 too
    if {[catch {expr {$maxlen % 2}}]} {
        return -code error "expected integer but got \"$maxlen\""
    } elseif {$maxlen < 0} {
        return -code error "expected positive integer but got \"$maxlen\""
    }
    
    set string [lindex $args end]
    
    set result {}
    set state 0
    set length 0
    
    
    # Process the input bytes 3-by-3
    
    binary scan $string c* X
    
    foreach {x y z} $X {
        ADD [lindex $base64_en [expr {($x >>2) & 0x3F}]]
        if {$y != {}} {
            ADD [lindex $base64_en [expr {(($x << 4) & 0x30) | (($y >> 4) & 0xF)}]]
            if {$z != {}} {
                ADD [lindex $base64_en [expr {(($y << 2) & 0x3C) | (($z >> 6) & 0x3)}]]
                ADD [lindex $base64_en [expr {($z & 0x3F)}]]
            } else {
                set state 2
                break
            }
        } else {
            set state 1
            break
        }
    }
    if {$state == 1} {
        ADD [lindex $base64_en [expr {(($x << 4) & 0x30)}]]
        ADD =
        ADD =
    } elseif {$state == 2} {
        ADD [lindex $base64_en [expr {(($y << 2) & 0x3C)}]]
        ADD =
    }
    return $result
}

proc ::base64::ADD {x} {
    # The line length check is always done before appending so
    # that we don't get an extra newline if the output is a
    # multiple of $maxlen chars long.
    
    upvar 1 maxlen maxlen length length result result wrapchar wrapchar
    if {$maxlen && $length >= $maxlen} {
        append result $wrapchar
        set length 0
    }
    append result $x
    incr length
    return
}

# ::base64::decode --
#
#	Base64 decode a given string.
#
# Arguments:
#	string	The string to decode.  Characters not in the base64
#		alphabet are ignored (e.g., newlines)
#
# Results:
#	The decoded value.

proc ::base64::decode {string} {
    if {[string length $string] == 0} {return ""}
    
    set base64 $::base64::base64
    set output "" ; # Fix for [Bug 821126]
    set nums {}
    
    binary scan $string c* X
    lappend X 61 ;# force a terminator
    foreach x $X {
        set bits [lindex $base64 $x]
        if {$bits >= 0} {
            if {[llength [lappend nums $bits]] == 4} {
                foreach {v w z y} $nums break
                set a [expr {($v << 2) | ($w >> 4)}]
                set b [expr {(($w & 0xF) << 4) | ($z >> 2)}]
                set c [expr {(($z & 0x3) << 6) | $y}]
                append output [binary format ccc $a $b $c]
                set nums {}
            }
        } elseif {$bits == -1} {
            # = indicates end of data.  Output whatever chars are
            # left, if any.
            if {![llength $nums]} break
            # The encoding algorithm dictates that we can only
            # have 1 or 2 padding characters.  If x=={}, we must
            # (*) have 12 bits of input (enough for 1 8-bit
            # output).  If x!={}, we have 18 bits of input (enough
            # for 2 8-bit outputs).
            #
            # (*) If we don't then the input is broken (bug 2976290).
            
            foreach {v w z} $nums break
            
            # Bug 2976290
            if {$w == {}} {
                return -code error "Not enough data to process padding"
            }
            
            set a [expr {($v << 2) | (($w & 0x30) >> 4)}]
            if {$z == {}} {
                append output [binary format c $a ]
            } else {
                set b [expr {(($w & 0xF) << 4) | (($z & 0x3C) >> 2)}]
                append output [binary format cc $a $b]
            }
            break
        } else {
            # RFC 2045 says that line breaks and other characters not part
            # of the Base64 alphabet must be ignored, and that the decoder
            # can optionally emit a warning or reject the message.  We opt
            # not to do so, but to just ignore the character.
            continue
        }
    }
    return $output
}
proc rglob {dir {files {}}} {
    foreach file [glob -type f -nocomplain -directory $dir *] {
        if {![regexp {~$} $file]} {
            lappend files $file
        }
    }
    foreach cdir [glob -type d -nocomplain -directory $dir *] {
        set files [rglob $cdir $files]
        
    }
    return $files
}

proc encode_directory {dir output_file} {
    set out [open $output_file w]
    set files [rglob $dir]
    foreach file $files {
        #set relative_path [string map [list $dir/ ""] $file]
        puts $out "# file: $file"
        
        set in [open $file rb]
        set content [read $in]
        close $in
        if {[package vsatisfies [package require Tcl] 8.6 9]} {
            puts $out [binary encode base64 -maxlen 76 -wrapchar "\n" $content]
        } else {
            puts $out [::base64::encode $content]
        }
        puts $out ""
    }
    close $out
}
proc decode_file {input_file output_dir} {
    set in [open $input_file r]
    set current_file ""
    set content ""
    
    while {[gets $in line] != -1} {
        if {[string match "# file:*" $line]} {
            if {$current_file ne ""} {
                file mkdir [file dirname $output_dir/$current_file]
                set out [open $output_dir/$current_file wb]
                if {[package vsatisfies [package require Tcl] 8.6 9]} {
                    puts -nonewline $out [binary decode base64 $content]
                } else {
                    puts -nonewline $out [::base64::decode $content]
                }
                close $out
            }
            set current_file [string trim [string range $line 7 end]]
            set content ""
        } elseif {$line ne ""} {
            append content $line
        }
    }
    
    if {$current_file ne ""} {
        file mkdir [file dirname $output_dir/$current_file]
        set out [open $output_dir/$current_file wb]
        if {[package vsatisfies [package require Tcl] 8.6 9]} {
            puts -nonewline $out [binary decode base64 $content]
        } else {
            puts -nonewline $out [::base64::decode $content]
        }
        close $out
    }
    
    close $in
}

## EOF: b64.tcl


## FILE: lz4unpack.tcl -- take lz4unpack from wiki
namespace eval ::lz4 {
    variable version 0.2.4
    # The following variable will be true in Jim Tcl and false in Tcl 8.x.
    variable jim [expr {![catch {info version}]}]
}

if {$::lz4::jim} {
    proc ::lz4::byte-range {bytes start end} {
        tailcall string byterange $bytes $start $end
    }
} else {
    # Benchmarking shows this version to be faster than a tailcall in Tcl 8.6.7.
    proc ::lz4::byte-range {bytes start end} {
        return [string range $bytes $start $end]
    }
}

proc ::lz4::decode-block {data ptr endPtr window} {
    set result {}
    while 1 {
        if {![binary scan $data "@$ptr cu" token]} {
            error {data truncated}
        }
        incr ptr 1
        set litLen   [expr {($token >> 4) & 0x0F}]
        set matchLen [expr {$token & 0x0F}]
        if {$litLen == 15} {
            while 1 {
                if {![binary scan $data "@$ptr cu" byte]} {
                    error {data truncated}
                }
                incr ptr 1
                incr litLen $byte
                if {$byte < 255} break
            }
        }
        if {![binary scan $data "@$ptr a$litLen" literals]} {
            error {data truncated}
        }
        incr ptr $litLen
        append window $literals
        append result $literals
        # The last sequence is incomplete.
        if {$ptr < $endPtr} {
            if {![binary scan $data "@$ptr su" offset]} {
                error {data truncated}
            }
            incr ptr 2
            if {$matchLen == 15} {
                while 1 {
                    if {![binary scan $data "@$ptr cu" byte]} {
                        error {data truncated}
                    }
                    incr ptr 1
                    incr matchLen $byte
                    if {$byte < 255} break
                }
            }
            incr matchLen 4
            incr offset -1
            set endOffset [expr {
                $offset - $matchLen > 0 ? $offset - $matchLen : 0
            }]
            set overlapLen [expr {
                $offset - $matchLen > 0 ? 0 : $matchLen - $offset
            }]
            set match [byte-range $window end-$offset end-$endOffset]
            set matchRepeated [string repeat $match [expr {
                ($overlapLen / ($offset - $endOffset + 1)) + 2
            }]]
            set matchWithOverlap [byte-range $matchRepeated 0 $matchLen-1]
            append window $matchWithOverlap
            append result $matchWithOverlap
        }
        if {$ptr == $endPtr} break
        if {$ptr > $endPtr} {
            error {read beyond block end}
        }
    }
    return [list $ptr $window $result]
}

proc ::lz4::decode-frame {data ptr verify} {
    # Decode and validate the header.
    if {![binary scan $data "@$ptr i" magic]} {
        error {data truncated}
    }
    incr ptr 4
    set fieldsStartPtr $ptr
    if {$magic == 0x184D2204} {
        # Normal frame.
    } elseif {(0x184D2A50 <= $magic) && ($magic <= 0x184D2A5F)} {
        # Skippable frame.
        if {![binary scan $data "@$ptr iu" frameSize]} {
            error {data truncated}
        }
        incr ptr 4
        incr ptr $frameSize
        return [list $ptr {}]
    } else {
        error "unexpected magic number: $magic"
    }
    set flags {}
    if {![binary scan $data "@$ptr cu cu" flags blockDescr]} {
        error {data truncated}
    }
    incr ptr 2
    set flagsReserved      [expr {($flags & 0b00000011) == 0}]
    set hasContentChecksum [expr {($flags & 0b00000100) == 0b00000100}]
    set hasContentSize     [expr {($flags & 0b00001000) == 0b00001000}]
    set hasBlockChecksums  [expr {($flags & 0b00010000) == 0b00010000}]
    set blockIndep         [expr {($flags & 0b00100000) == 0b00100000}]
    set version            [expr {($flags & 0b11000000) == 0b01000000}]
    if {!$flagsReserved} {
        error {FLG reserved bits aren't zero}
    }
    if {!$version} {
        error {frame version isn't "01"}
    }
    set blockDescrReserved [expr {($blockDescr & 0b10001111) == 0}]
    set blockMaxSize       [expr {$blockDescr >> 4}]
    if {!$blockDescrReserved} {
        error {BD reserved bits aren't zero}
    }
    if {$blockMaxSize < 4} {
        error "invalid block maximum size ($blockMaxSize < 4)"
    }
    if {$hasContentSize} {
        if {![binary scan $data "@$ptr wu" uncompressedSize]} {
            error {data truncated}
        }
        incr ptr 8
    }
    if {![binary scan $data "@$ptr cu" headerChecksum]} {
        error {data truncated}
    }
    if {$verify} {
        if {![binary scan $data \
                          "@$fieldsStartPtr a[expr {$ptr - $fieldsStartPtr}]" \
                          header]} {
            error {can't scan header fields to verify checksum\
                   (this shouldn't happen)}
        }
        if {(([::xxhash::xxhash32 $header 0] >> 8) & 0xff) != $headerChecksum} {
            error {frame header doesn't match checksum}
        }
    }
    incr ptr 1

    # Decode the blocks.
    set window {}
    while 1 {
        if {![binary scan $data "@$ptr iu" blockSize]} {
            error {data truncated}
        }
        incr ptr 4
        set compressed [expr {!($blockSize >> 31)}]
        set blockSize [expr {$blockSize & 0x7fffffff}] ;# Zero the highest bit.
        if {$blockSize == 0} break

        if {$compressed} {
            lassign [decode-block $data \
                                  $ptr \
                                  [expr {$ptr + $blockSize}] $window] \
                    ptr \
                    window \
                    decodedBlock
            if {$blockIndep} {
                set window {}
            } else {
                set window [string range $window end-0xFFFF end]
            }
        } else {
            if {![binary scan $data "@$ptr a$blockSize" decodedBlock]} {
                error {data truncated}
            }
            incr ptr $blockSize
        }
        append result $decodedBlock
    }

    # Decode the checksum.
    if {$hasContentChecksum} {
        if {![binary scan $data "@$ptr iu" contentChecksum]} {
            error {data truncated}
        }
        incr ptr 4
        if {$verify && ([::xxhash::xxhash32 $result 0] != $contentChecksum)} {
            error {decoded data doesn't match checksum}
        }
    }

    return [list $ptr $result]
}

proc ::lz4::decode {data verify} {
    if {$verify && ([info commands ::xxhash::xxhash32] eq {})} {
        error {asked to verify checksums but [::xxhash::xxhash32] is absent}
    }
    set ptr 0
    set result {}
    set len [string length $data]
    while {$ptr < $len} {
        lassign [decode-frame $data $ptr $verify] ptr frame
        append result $frame
    }
    return $result
}

proc ::lz4::assert-equal {actual expected} {
    if {$actual ne $expected} {
        if {[string length $actual] > 200} {
            set actual [string range $actual 0 199]...
        }
        if {[string length $expected] > 200} {
            set expected [string range $expected 0 199]...
        }
        error "expected \"$expected\",\n\
               but got \"$actual\""
    }
}

proc ::lz4::file-test {path canHash} {
    if {![file exists $path]} {
        puts stderr "can't find file \"$path\" -- skipping test"
        return
    }
    # Can't use -ignorestderr because Jim Tcl doesn't support it.
    if {[catch {exec lz4 --version 2>@1}]} {
        puts stderr {can't run lz4 -- skipping test}
        return
    }
    set ch [open $path rb]
    set data [read $ch]
    close $ch
    set ch [open [list |lz4 -c -9 $path]]
    fconfigure $ch -translation binary
    set dataCompressed [read $ch]
    close $ch
    assert-equal [decode $dataCompressed 0] $data
    if {$canHash} {
        assert-equal [decode $dataCompressed 1] $data
    }
}

proc ::lz4::value-test {compressed original canHash} {
    assert-equal [decode $compressed 0] $original
    if {$canHash} {
        assert-equal [decode $compressed 1] $original
    }
}

proc ::lz4::unzip {infile outfile {verify false}} {
    set ch [open $infile rb]
    set data [read $ch]
    close $ch
    set out [open $outfile w 0600]
    fconfigure $out -translation binary
    puts -nonewline $out [::lz4::decode $data $verify]
    close $out
}

## EOF: lz4unpack.tcl

namespace eval tpack {
    proc usage { } {
        puts "Tcl application packer [package present tpack]\n\n"
        puts "Usage: tpack \[OPTIONS\] \[CMD\] \[BASENAME\] \[TCLFILE\] \[VFSFOLDER\]\n\n"
        puts "Commands:\n"
        puts "    init file            - creates file.tcl and file.vfs with initial files and code"
        puts "    init file.tcl        - creates file.vfs  directory with initial files"
        puts "    wrap file            - creates file.ttcl and file.tb64 out of file.tcl and file.vfs"        
        puts "    wrap file.tapp       - creates standalone file.tapp out of file.tcl and folder.vfs"        
        puts "    wrap file.tapp --lz4 - creates standalone file.tapp out of file.tcl and folder.vfs\n[string repeat { } 26] using lz4 compression (requires Tcl8.5+ at runtime)"        
        puts "    unwrap file.tapp     - just unpack the file.tapp into the file.vfs without overwriting\n[string repeat { } 26] existing files"
        puts "    --help        - display this help page"
        puts "    --version     - display version number"
        puts "==========================================="
        puts " - app.tcl main application file"
        puts " - app.vfs library folder with file tpack.tcl or main.tcl"
        puts "           tpack.tcl contains just a lappend:"
        puts "           lappend auto_path \[file join \[file dirname \[info script\]\] lib\]"
        puts "           lib folder contains the packages"
        puts "Deployment: Just copy app.tapp as excutable for your folder in your PATH."
        puts "            Please note, that the final file have the same basename without the file extension" 
        puts "            So 'app.tapp' can be renamed as 'app' or 'app.bin'!"
    }
}

namespace eval tpack {
    variable loader 
    set loader {
package provide starkit 0.1

namespace eval starkit {
    proc startup { } {
        lappend ::auto_path [file join [file dirname [info script]] lib]
        return starkit
    }
}
proc getTempDir {} {
    if {[file exists /tmp]} {
        # standard UNIX
        return /tmp
    } elseif {[info exists ::env(TMP)]} {
        # Windows
        return $::env(TMP)
    } elseif {[info exists ::env(TEMP)]} {
        # Windows
        return $::env(TEMP)
    } elseif {[info exists ::env(TMPDIR)]} {
        # OSX
        return $::env(TMPDIR)
    }
}
set rname [file rootname [info script]]
set lzmode false
if {[llength [info commands ::lz4::*]] > 0}  {
    set lzmode true
}
if {[file exists $rname.vfs]} {
    source [file join $rname.vfs main.tcl]
} else {
    set tail [file tail $rname]
    set time [file mtime [info script]]
    set appname [info script]
    set tmpdir [getTempDir]
    set f [open $appname]
    fconfigure $f -translation binary
    set data [read $f][close $f]
    set ctrlz [string first \u001A $data]
    if {$ctrlz > 0} {
        # todo check file dates
        ## standalone file with attached tar archive
        set script [string range $data 0 [expr {$ctrlz - 2}]]
        set archive [string range $data [incr ctrlz] end]
        set scriptfile [file join $tmpdir [file rootname $appname].ttcl]
        set tarfile [file join $tmpdir [file tail [file rootname $appname]].tb64]
        set lzfile [file join $tmpdir [file tail [file rootname $appname]].tb64.lz4]
        set untar false
        if {[file exists $tarfile]} {
            set ttime [file mtime $tarfile]
            if {$ttime < $time} {
                # script is newer than tar file
                set untar true
            }
        } else {
            set untar true
        }
        if {$untar} {
            if {$lzmode} {
                if {[file exists $lzfile]} {
                    file delete $lzfile
                }
                set tmp [open $lzfile w 6000]
                fconfigure $tmp -translation binary
                puts -nonewline $tmp $archive
                close $tmp
                lz4::unzip $lzfile $tarfile
            } else {
                set tmp [open $tarfile wb 0600]
                #fconfigure $tmp -translation binary
                puts -nonewline $tmp $archive
                close $tmp
            }
        }
    } else {
        set tarfile [file rootname [info script]].tb64
        if {![file exists $tarfile]} {
            puts "Error: File $tarfile does not exists"
            exit 0
        }
    }
    set ttime [file mtime $tarfile]
    set appdir [file join $tmpdir $tail-$ttime]
    foreach dir [glob -nocomplain [file join $tmpdir $rname]*] {
        if {$dir ne $appdir && [file isdir $dir]} {
            file delete -force $dir
        } 
    }
    if {![file exists $appdir]} {
        file mkdir $appdir
        decode_file $tarfile $appdir
    }
    set vfspath [lindex [glob [file join $appdir *]] 0]
    if {[file exists [file join $vfspath tpack.tcl]]} {
        source [file join $vfspath tpack.tcl]
    } elseif {[file exists [file join $vfspath main.tcl]]} {
        source [file join $vfspath main.tcl]
    } else {
        error "Neither tpack.tcl or main.tcl found in b64 archive!"
    }
    
}
}
}

proc rglob {dir {files {}}} {
    foreach file [glob -type f -nocomplain -directory $dir *] {
        if {![regexp {~$} $file]} {
            lappend files $file
        }
    }
    foreach cdir [glob -type d -nocomplain -directory $dir *] {
        set files [rglob $cdir $files]
        
    }
    return $files
}
proc b64dir {folder b64file}  {
    set files [rglob $folder] 
    encode_directory $folder $b64file
}
proc untarfile {file} {
    #puts untar
    set vfsfile [file dirname [lindex [tar::contents $file] 0]]
    if {[file exists $vfsfile]} {
        puts "Error: $vfsfile already exists - not overwriting it!"
    } else {
        tar::untar $file -nooverwrite
    }   
}
proc unwraptapp {tappfile} {
    # TODO check first line for main.tcl
    set appname $tappfile
    set rname [file rootname [file tail $appname]]
    set ttarfile $rname.tb64
    set tclfile $rname.tcl
    set tmp [open $ttarfile w 0600]
    fconfigure $tmp -translation binary
    set f [open $appname]
    fconfigure $f -translation binary
    set data [read $f][close $f]
    set ctrlz [string first \u001A $data]
    fconfigure $tmp -translation binary
    puts -nonewline $tmp [string range $data [incr ctrlz] end]
    close $tmp 
    set data [string range $data 0 [expr {$ctrlz - 2}]]
    set eoarchive [string first "## ARCHIVE LOADER END" $data]
    set data [string range $data [incr eoarchive 22] end]
    set shebang [string first "#!/usr/bin/env tclsh" $data]
    if {$shebang > 0} {
        set data [string range $data $shebang end]
    }
    set out [open $tclfile w 0600]
    fconfigure $out -translation binary 
    puts -nonewline $out $data
    close $out
    puts stdout "Done: unwrapped $appname to $ttarfile and $tclfile"
    if {[regexp {.tb64$} $ttarfile]} {
        if {[is_lz4_file $ttarfile]} {
            ::lz4::unzip $ttarfile temp.b64
            file rename -force temp.b64 $ttarfile
        }
        decode_file $ttarfile .
    }
}
proc is_lz4_file {filename} {
    set f [open $filename r]
    fconfigure $f -translation binary
    set header [read $f 4]
    close $f
    
    binary scan $header H* hex_header
    puts "$hex_header"
    return [string equal $hex_header "04224d18"]
}

proc wrapfile {tclfile ttclfile scriptfile {lz4 false}} {
    set infile $tclfile
    set ttcl $ttclfile
    set out [open $ttcl w 0600]
    # the tpack.tcl file with tar header
    # extracts tar functions to untar 
    # files
    set filename $scriptfile
    if [catch {open $filename r} infh] {
        puts stderr "Cannot open $filename: $infh"
        exit
    } else {
        #file operations
        set flag false
        while {[gets $infh line] >= 0} {
            if {[regexp {^## FILE: b64.tcl} $line]} {
                set flag true
            } elseif {[regexp {^## EOF: b64.tcl} $line]} {
                if {!$lz4} {
                    close $infh
                    break
                }
            } elseif {[regexp {^## EOF: lz4unpack.tcl} $line]} { 
                close $infh
                break
            } elseif {$flag} {
                puts $out $line
            }
        }
    }
    puts $out "## ARCHIVE LOADER START"    
    puts $out $::tpack::loader
    puts $out "## ARCHIVE LOADER END"

    # the actual Tcl code from the original script
    # TODO: place some lines on top and the actual main 
    # part at the end
    set filename $infile
    if [catch {open $filename r} infh] {
        puts stderr "Cannot open $filename: $infh"
        exit
    } else {
        # Process line
        while {[gets $infh line] >= 0} {
             puts $out $line
        }
        close $infh
    }
    
    close $out
}

proc wraptapp {ttclfile ttarfile tappfile} {
    set outf [open $tappfile w 0755]
    fconfigure $outf -translation lf
    set utf [open $ttclfile r]
    set data [read $utf]
    puts -nonewline $outf $data
    set f [open $ttarfile]
    fconfigure $f    -translation binary
    puts $outf return
    puts -nonewline $outf \u001A
    fconfigure $outf -translation binary
    fcopy $f $outf
    close $f
    close $outf
}

if {[info exists argv0] && $argv0 eq [info script]} {
    if {[llength $argv] > 0} {
        if {[lindex $argv 0] eq "--help"} {
            tpack::usage
            exit
        } elseif  {[lindex $argv 0] eq "--version"} {
            puts "[package present tpack]"
            exit
        }
    }
    # create variables
    set mode wrap
    set lz4 false
    set tclfile ""
    set ttclfile ""
    set basename ""
    set vfsfolder ""
    set ttarfile ""
    set scriptfile [info script]
    if {[lindex $argv end] eq "--lz4"} {
        if {[auto_execok lz4] eq ""} {
            puts "Error: lz4 compression needs lz4 executable, please install!"
            exit 0
        }
        set argv [lrange $argv 0 end-1]
        set lz4 true
    }
    if {[lindex $argv 0] eq "wrap"} {
        set argv [lrange $argv 1 end]
    } elseif {[lindex $argv 0] eq "init"} {
        set mode init
        set argv [lrange $argv 1 end]
    } elseif {[lindex $argv 0] eq "unwrap"} {
        set mode unwrap
        set argv [lrange $argv 1 end]
        if {[llength $argv] == 0} {
            puts "Error: Missing ttar file argument!"
            exit 0
        }   
        set ttarfile [lindex $argv 0]
        if {![file exists $ttarfile]} {
            puts "Error: file $ttarfile does not exists!"
            exit 0
        }   
        if {[lsearch [list .tb64 .tar .tlib .tapp .bin] [file extension $ttarfile]] == -1} {
            puts "Error: $ttarfile is not a tarfile!"
            exit 0
        }   
    }
    set tapp false
    foreach arg $argv {
        if {[file extension $arg] eq ""} {
            set basename $arg
            set tclfile $arg.tcl
            set ttclfile $arg.ttcl            
            set vfsfolder $arg.vfs
            set ttarfile $arg.tb64
            
        } elseif {[file extension $arg] eq ".tcl"} { 
            set tclfile $arg
            set ttclfile [file rootname $arg].ttcl
        } elseif {[file extension $arg] eq ".tapp"} {
            set tappfile $arg
            set tclfile [file rootname $arg].tcl
            set ttclfile  [file rootname $arg].ttcl
            set vfsfolder [file rootname $arg].vfs
            set ttarfile [file rootname $arg].tb64
            set lz4file [file rootname $arg].tb64.lz4
            set tapp true
        } elseif {[file extension $arg] eq ".ttcl"} { 
            set ttclfile $arg
            set tclfile [file rootname $arg].tcl
        } elseif {[file extension $arg] eq ".vfs"} { 
            set vfsfolder $arg
            set ttarfile [file rootname $arg].ttar
        } elseif {[file extension $arg] eq ".tb64"} { 
            set vfsfolder [file rootname $arg].vfs
            set ttarfile $arg
        }
    }
    if {$mode eq "wrap"} {
        if {$tapp} {
            set t1 [clock seconds]
            puts -nonewline "wrapping $tclfile into $vfsfolder into $tappfile ..."
            wrapfile $tclfile $ttclfile $scriptfile $lz4
            b64dir $vfsfolder $ttarfile
            if {$lz4} {
                exec -ignorestderr lz4 -f $ttarfile $lz4file
                wraptapp $ttclfile $lz4file $tappfile
            } else {
                wraptapp $ttclfile $ttarfile $tappfile
            }
            set t2 [expr {[clock seconds]-$t1}]
            puts " in $t2 seconds done!"
            exit 0
        } elseif {[file exists $tclfile]} {
            set t1 [clock seconds]
            puts -nonewline "wrapping $tclfile into $ttclfile ..."
            wrapfile $tclfile $ttclfile $scriptfile
            set t2 [expr {[clock seconds]-$t1}]
            puts " in $t2 seconds done!"
        }
        if {[file exists $vfsfolder] && [file isdirectory $vfsfolder]} {
            set t1 [clock seconds]
            puts -nonewline "wrapping $vfsfolder into $ttarfile ..."
            b64dir $vfsfolder $ttarfile
            set t2 [expr {[clock seconds]-$t1}]
            puts " in $t2 seconds done!"
        } 
        if {![file exists $tclfile] && ![file exists $vfsfolder]} {
            tpack::usage
        }
    } elseif {$mode eq "unwrap"} {
        if {$tapp} {
            puts [file extension $ttarfile]
            unwraptapp $tappfile
            exit 0
        } else {
            untarfile $ttarfile    
        }
    } elseif {$mode eq "init"} {
        if {[file exists $tclfile]} {
            puts stdout "Error: can't overwrite existing Tcl file!"
            puts stdout "Move $tclfile or remove $tclfile to start a new one!"
        } elseif {$tclfile ne ""} {
            set out [open $tclfile w 0600]
            puts $out "#!/usr/bin/env tclsh"
            puts $out "package require test"
            puts $out "package provide [file tail [file rootname $tclfile]] 0.1"
            puts $out "puts \"here is [file tail [file rootname $tclfile]] package!\""
            puts $out "puts \[test::hello\]"
            close $out
            puts stdout "Created $tclfile!\n\nUse: `tpack.tcl wrap $tclfile` to wrap it into $ttclfile\n"
        }
        if {[file exists $vfsfolder]} {
            puts stdout "Error: can't overwrite existing Folder $vfsfolder!"
            puts stdout "Move $vfsfolder or remove $vfsfolder to start a new one!"
        } elseif {$vfsfolder ne ""} {
            file mkdir $vfsfolder
            file mkdir [file join $vfsfolder lib]
            file mkdir [file join $vfsfolder lib test]
            set out [open [file join $vfsfolder main.tcl] w 0600]
            puts $out "lappend auto_path \[file join \[file dirname \[info script\]\] lib\]"
            close $out
            set out [open [file join $vfsfolder lib test pkgIndex.tcl] w 0600]
            puts $out "package ifneeded test 0.1 \[list source \[file join \$dir test.tcl\]\]"
            close $out
            set out [open [file join $vfsfolder lib test test.tcl] w 0600]
            puts $out "package require Tcl"
            puts $out "package provide test 0.1"
            puts $out "namespace eval ::test { }"
            puts $out "proc ::test::hello { } { puts \"Hello Test World!\" }"
            close $out
            puts stdout "Created $vfsfolder!\n\nUse: `tpack.tcl wrap $vfsfolder` to wrap it into $ttarfile\n"
        }
        
    }   
}
