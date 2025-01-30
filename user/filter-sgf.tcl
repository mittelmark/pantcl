#' ---
#' title: "filter-sgf.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2025-01-14
#' sgf:
#'     app: sgf-render
#'     eval: 1
#'     format: svg
#'     game-number: 1
#'     filter: user/filter-sgf.tcl
#'     width: 800
#' ---
#' 
# A pandoc filter for the [sgf-render](https://lib.rs/crates/sgf-render)  to create Go/Weiqi/Baduko game records from sgf files.
#' 
#' 
#' ## Name
#' 
#' _filter-sgf.tcl_ - Filter which can be used to display Go board images using the [sgf-render] command line 
#' application within a Pandoc processed document using the Tcl filter driver `pantcl` using user 
#' provided filter written in Tcl. 
#' 
#' ## Description
#' 
#' This is a filter supporting an easy to use Go board game image creation tool based on the standard SGF file
#' format. The application can be download for Windows, MacOS and Linux from the Github project page at
#' [https://github.com/julianandrews/sgf-render](https://github.com/julianandrews/sgf-render)
#' 
#' ## Usage
#' 
#' SGF code is embedded into Markup languages like Markdown like this 
#' (remove the spaces at the beginning, they are here just for protecting the evaluation):
#' 
#' ```
#'      # code chunk defaults (must be in fact not given):
#'      ```{.sgf eval=true echo=true}
#'          (;FF[4]GM[1]SZ[13]
#'            AB[bb:dd][di:1]
#'            AW[ee][ff][gg]
#'            LB[dh:a]
#'            LB[gb:b]
#'         )
#'      ```
#' ```
#' 
#' Where `eval` and `echo` are so called chunk options. Please note that this is an external filter,
#' to use the filter your actual need to point in your YAML header to the filter implementation, see below for more informatian.
#' 
#' The conversion of the Markdown documents via pantcl should be then done as follows:
#' 
#' ```
#' pantcl input.md output.html -s 
#' ```
#' 
#' The application file *pantcl* which contains the Tcl filter and all other filters has to be placed in the PATH and the 
#' system has to support the Shebang, on Unix this is standard on Windows you need to use tools like Cygwin, Msys, 
#' Git-Bash or Cygwin (untested).  
#' 
#' The arguments after the output file are delegated to pantcl/pandoc.
#' 
#' If code blocks with the `.sgf` marker are found, the contents in the code 
#' block is processed via the sgf-render command line application.
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - _app_ - the command line application to be called, usually `sgf-render`, default: `sgf-render`
#'   - _format_  - the output format default: svg, other options are png or text
#'   - _echo_ - should the sgf source code been shown, default: true|1
#'   - _eval_ - should the code in the code block be evaluated, default: false|0
#'   - _results_ - should the output of the command line application been shown, should be show or hide, default: "show"
#'   - _width_ - the width of the image, default: 800
#'   - _imagepath_ - the folder name where to store the images, default: images
#'   - _style_ - the board style, default: simple, others: minimalist, fancy
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' default width to 400 which is for instance useful if you display smaller boards like
#' write document about playing on a 9x9 board.
#' 
#' ```
#'  ----
#'  title: "filter-sgf.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2025-01-29
#'  geasy:
#'      app: sgf-render
#'      eval: 1
#'      filter: user/filter-sgf.tcl
#'      format: svg
#'      imagepath: boards
#'      width: 400
#'      style: minimalist
#'  ----
#' ```
#'
#' ## Examples
#' 
#' Here an example for a simple diagram  with chunk options `{.geasy eval=true}`:.
#' 
#' ```{.sgf eval=true}
#' (
#' ;GM[1]FF[4]CA[UTF-8]SZ[19]ST[2]RU[Chinese]KM[7.5]
#' ;B[pd];W[dp];B[cd];W[qp];B[op];W[oq];B[nq];W[pq];B[cn];W[fq];B[mp];W[qn]
#' ;B[ic];W[dj];B[po];W[qo];B[cp];W[cq];B[bq];W[co];B[bp];W[bo];B[do];W[bn]
#' ;B[dq];W[ep];B[dr];W[cm];B[jp];W[cg];B[ed];W[qf];B[qe];W[pf];B[nd];W[pi]
#' ;B[oj];W[oi];B[nj];W[mh];B[gp];W[gq];B[dn];W[dm];B[fo];W[hp];B[ho];W[eo]
#' ;B[en];W[fn];B[em];W[el];B[fm];W[gn];B[fl];W[go];B[ek];W[dk];B[dl];W[cl]
#' ;B[eh];W[di];B[pj];W[qi];B[rf];W[rg];B[kd];W[hn];B[om];W[re];B[rd];W[sf]
#' ;B[fi];W[gk];B[hm];W[in];B[hl];W[ko];B[kp];W[gc];B[df];W[id];B[jc];W[ge]
#' ;B[dg];W[cf];B[ch];W[bh];B[dh];W[bi];B[hd];W[he];B[gd];W[fd];B[hc];W[fe]
#' ;B[ec];W[gh];B[fc];W[gi];B[ii];W[hk];B[ik];W[il];B[im];W[ij];B[jl];W[jj]
#' ;B[if];W[km];B[kl];W[lj];B[lk];W[lo];B[li];W[kj];B[ci];W[cj];B[mj];W[nr]
#' ;B[mr];W[lq];B[lp];W[mq];B[np];W[lr];B[lm];W[kh];B[hg];W[qc];B[qd];W[rc]
#' ;B[pc];W[sd];B[gg];W[ce];B[bd];W[qb];B[hi];W[jg];B[hj];W[ob];B[pb];W[pa]
#' ;B[nb];W[de];B[ee];W[gj];B[hh];W[ej];B[nf];W[mf];B[me];W[rk];B[fh];W[el]
#' ;B[nh];W[ng];B[lg];W[lh];B[mg];W[og];B[kg];W[ni];B[jh];W[na];B[ki];W[mi]
#' ;B[ji];W[nc];B[mb];W[od];B[mc];W[oc];B[kr];W[ms];B[io];W[ip];B[jo];W[jn]
#' ;B[ir];W[hr];B[ql];W[rl];B[qm];W[rm];B[ao];W[bm];B[ln];W[kn];B[mo];W[be]
#' ;B[ae];W[af];B[ad];W[ma];B[la];W[oa];B[dd];W[bg];B[lb];W[pn];B[on];W[er]
#' ;B[cr];W[fp];B[iq];W[hq];B[qj];W[rj];B[ks]
#' )
#' ```
#' 
#' Using the option `{.sgf eval=true results="hide"}` the output of the command line tool can be hidden.
#' 
#' ```{.sgf eval=true results="hide" width=500}
#' (
#' ;GM[1]FF[4]CA[UTF-8]SZ[19]ST[2]RU[Chinese]KM[7.5]
#' ;B[pd];W[dp];B[cd];W[qp];B[op];W[oq];B[nq];W[pq];B[cn];W[fq];B[mp];W[qn]
#' ;B[ic];W[dj];B[po];W[qo];B[cp];W[cq];B[bq];W[co];B[bp];W[bo];B[do];W[bn]
#' ;B[dq];W[ep];B[dr];W[cm];B[jp];W[cg];B[ed];W[qf];B[qe];W[pf];B[nd];W[pi]
#' ;B[oj];W[oi];B[nj];W[mh];B[gp];W[gq];B[dn];W[dm];B[fo];W[hp];B[ho];W[eo]
#' ;B[en];W[fn];B[em];W[el];B[fm];W[gn];B[fl];W[go];B[ek];W[dk];B[dl];W[cl]
#' ;B[eh];W[di];B[pj];W[qi];B[rf];W[rg];B[kd];W[hn];B[om];W[re];B[rd];W[sf]
#' ;B[fi];W[gk];B[hm];W[in];B[hl];W[ko];B[kp];W[gc];B[df];W[id];B[jc];W[ge]
#' ;B[dg];W[cf];B[ch];W[bh];B[dh];W[bi];B[hd];W[he];B[gd];W[fd];B[hc];W[fe]
#' ;B[ec];W[gh];B[fc];W[gi];B[ii];W[hk];B[ik];W[il];B[im];W[ij];B[jl];W[jj]
#' ;B[if];W[km];B[kl];W[lj];B[lk];W[lo];B[li];W[kj];B[ci];W[cj];B[mj];W[nr]
#' ;B[mr];W[lq];B[lp];W[mq];B[np];W[lr];B[lm];W[kh];B[hg];W[qc];B[qd];W[rc]
#' ;B[pc];W[sd];B[gg];W[ce];B[bd];W[qb];B[hi];W[jg];B[hj];W[ob];B[pb];W[pa]
#' ;B[nb];W[de];B[ee];W[gj];B[hh];W[ej];B[nf];W[mf];B[me];W[rk];B[fh];W[el]
#' ;B[nh];W[ng];B[lg];W[lh];B[mg];W[og];B[kg];W[ni];B[jh];W[na];B[ki];W[mi]
#' ;B[ji];W[nc];B[mb];W[od];B[mc];W[oc];B[kr];W[ms];B[io];W[ip];B[jo];W[jn]
#' ;B[ir];W[hr];B[ql];W[rl];B[qm];W[rm];B[ao];W[bm];B[ln];W[kn];B[mo];W[be]
#' ;B[ae];W[af];B[ad];W[ma];B[la];W[oa];B[dd];W[bg];B[lb];W[pn];B[on];W[er]
#' ;B[cr];W[fp];B[iq];W[hq];B[qj];W[rj];B[ks]
#' )
#' ```
#' 
#' ```{.sgf eval=true results="hide" width=500 style=minimalist}
#' (
#' ;GM[1]FF[4]CA[UTF-8]SZ[19]ST[2]RU[Chinese]KM[7.5]
#' ;B[pd];W[dp];B[cd];W[qp];B[op];W[oq];B[nq];W[pq];B[cn];W[fq];B[mp];W[qn]
#' ;B[ic];W[dj];B[po];W[qo];B[cp];W[cq];B[bq];W[co];B[bp];W[bo];B[do];W[bn]
#' ;B[dq];W[ep];B[dr];W[cm];B[jp];W[cg];B[ed];W[qf];B[qe];W[pf];B[nd];W[pi]
#' ;B[oj];W[oi];B[nj];W[mh];B[gp];W[gq];B[dn];W[dm];B[fo];W[hp];B[ho];W[eo]
#' ;B[en];W[fn];B[em];W[el];B[fm];W[gn];B[fl];W[go];B[ek];W[dk];B[dl];W[cl]
#' ;B[eh];W[di];B[pj];W[qi];B[rf];W[rg];B[kd];W[hn];B[om];W[re];B[rd];W[sf]
#' ;B[fi];W[gk];B[hm];W[in];B[hl];W[ko];B[kp];W[gc];B[df];W[id];B[jc];W[ge]
#' ;B[dg];W[cf];B[ch];W[bh];B[dh];W[bi];B[hd];W[he];B[gd];W[fd];B[hc];W[fe]
#' ;B[ec];W[gh];B[fc];W[gi];B[ii];W[hk];B[ik];W[il];B[im];W[ij];B[jl];W[jj]
#' ;B[if];W[km];B[kl];W[lj];B[lk];W[lo];B[li];W[kj];B[ci];W[cj];B[mj];W[nr]
#' ;B[mr];W[lq];B[lp];W[mq];B[np];W[lr];B[lm];W[kh];B[hg];W[qc];B[qd];W[rc]
#' ;B[pc];W[sd];B[gg];W[ce];B[bd];W[qb];B[hi];W[jg];B[hj];W[ob];B[pb];W[pa]
#' ;B[nb];W[de];B[ee];W[gj];B[hh];W[ej];B[nf];W[mf];B[me];W[rk];B[fh];W[el]
#' ;B[nh];W[ng];B[lg];W[lh];B[mg];W[og];B[kg];W[ni];B[jh];W[na];B[ki];W[mi]
#' ;B[ji];W[nc];B[mb];W[od];B[mc];W[oc];B[kr];W[ms];B[io];W[ip];B[jo];W[jn]
#' ;B[ir];W[hr];B[ql];W[rl];B[qm];W[rm];B[ao];W[bm];B[ln];W[kn];B[mo];W[be]
#' ;B[ae];W[af];B[ad];W[ma];B[la];W[oa];B[dd];W[bg];B[lb];W[pn];B[on];W[er]
#' ;B[cr];W[fp];B[iq];W[hq];B[qj];W[rj];B[ks]
#' )
#' ```
#' 
#' ```{.sgf eval=true results="hide" width=300 style=fancy movenumbers=3}
#' (
#' ;GM[1]FF[4]CA[UTF-8]SZ[9]ST[2]RU[Chinese]KM[6.5]
#' B[ee];W[ce];B[eg];W[gc];
#' LB[dd:A][de:b]TR[bb]MA[bc]
#' )
#' ```
#'
#' ## See also:
#' 
#' * [user-filter](user-filter.html) - more information on how to create your own filter using Tcl
#' * [pantcl Readme](../README.html)
#' * [pantcl manual](../pantcl.html)
#' * [pantcl Tutorial](../pantcl-tutorial.html)
#' 


proc filter-sgf {cont dict} {
    # count all code chunk filters
    global n
    global LASTSGF
    incr n
    # default values for the code chunks attributes
    set def [dict create results show eval true format svg \
             app sgf-render label null width 800 imagepath images style simple \
             movenumbers 0 args ""]
    # overwrite them with the current code chunk attributes         
    set dict [dict merge $def $dict]
    # if eval is false return nothing
    if {![dict get $dict eval]} {
        return [list "" ""]
    }
    # check if the application is installed at all
    if {[auto_execok [dict get $dict app]] eq ""} {
        return [list "Error: This filter requires the command line tool [dict get $dict app] - please install it!" ""]
    }
    # intialize return text
    set ret ""
    set owd [pwd]
    # create a filename for the outputs
    if {[dict get $dict label] eq "null"} {
        set fname [file join $owd [dict get $dict imagepath] sgf-$n]
    } else {
        set fname [file join $owd [dict get $dict imagepath] [dict get $dict label]]
    }
    if {![file exists [file join $owd [dict get $dict imagepath]]]} {
        file mkdir [file join $owd [dict get $dict imagepath]]
    }

    # write down the code chunk text
    if {[regexp {LASTSGF} $cont]} {
        set sgffile $LASTSGF
    } else {
        set sgffile [file join [dict get $dict imagepath] $fname.sgf]
        set LASTSGF $sgffile
        set out [open $sgffile w 0600]
        puts $out $cont
        close $out
    }
    set outfile [file join [dict get $dict imagepath] $fname.[dict get $dict format]]
    # run the tool
    # TODO: error catching
    set args [list --format [dict get $dict format] --outfile $outfile --width [dict get $dict width] \
              --style [dict get $dict style]]
    if {[dict get $dict movenumbers] ne "0"} {
        lappend args --move-numbers=[dict get $dict movenumbers]
    }
    if {[dict get $dict args] ne ""} {
        foreach a [split [dict get $dict args] " "] {
            lapend args $a
        }
    }
    #puts stderr $args
    set res [exec -ignorestderr [dict get $dict app] $sgffile {*}$args]
    # initialize the image variable
    set img $outfile
    # do the user like to use the dot tool for image generation?
    # check if results should be shown
    if {[dict get $dict results] eq "show"} {
        set res $res
    } else {
        set res ""
    }
    # return text and image path
    return [list $res $img]
}
