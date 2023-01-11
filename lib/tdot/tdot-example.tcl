#!/usr/bin/env tclsh
##############################################################################
#
#  Author        : Dr. Detlef Groth
#  Created By    : Dr. Detlef Groth
#  Created       : Sat Sep 25 19:13:12 2021
#  Last Modified : <210926.0715>
#
#  Description	
#
#  Notes
#
#  History
#	
##############################################################################
#
#  Copyright (c) 2021 Dr. Detlef Groth.
# 
#  License:      MIT
# 
##############################################################################


package require Tcl

source [file join [file dirname [info script]] tdot.tcl]

tdot graph margin=0.3 
tdot graph size="8\;7" ;# semikolon must be backslashed
tdot node shape=box style=filled fillcolor=grey width=1
tdot addEdge 1988  -> 1993 -> 1995 -> 1997 -> 1999 \
      -> 2000 -> 2002 -> 2007 -> 2012 -> future
tdot node fillcolor="#ff9999"
tdot edge style=invis
tdot addEdge  Tk -> Bytecode -> Unicode -> TEA -> vfs -> \
      Tile -> TclOO -> zipvfs
tdot edge style=filled
tdot node fillcolor="salmon"
tdot addEdge "Tcl/Tk" -> 7.3 -> 7.4 -> 8.0  ->  8.1 ->  8.3 \
      -> 8.4  -> 8.5  ->  8.6 -> 8.7;
tdot node fillcolor=cornsilk
tdot addEdge  7.3 -> Itcl -> 8.6
tdot addEdge  Tk -> 7.4 -> Otcl -> XOTcl -> NX 
tdot addEdge  Otcl -> Thingy -> tdot
tdot addEdge  Bytecode -> 8.0 
tdot addEdge  8.0 -> Namespace dir=back
tdot addEdge  Unicode -> 8.1
tdot addEdge  8.1 -> Wiki
tdot addEdge  TEA -> 8.3 
tdot addEdge  8.3 -> Tcllib -> Tklib
tdot addEdge  8.4 -> Starkit -> Snit -> Dict -> 8.5 
tdot addEdge  vfs -> 8.4
tdot addEdge  Tile -> 8.5
tdot addEdge  TclOO -> 8.6  -> TDBC
tdot addEdge  zipvfs -> 8.7 -> Null ;# Null is just a placeholder for the history
tdot block    rank=same 1988 "Tcl/Tk"  group=g1
tdot block    rank=same 1993  7.3      group=g1  Itcl
tdot block    rank=same 1995  Tk       group=g0  7.4 group=g1 Otcl group=g2
tdot block    rank=same 1997  Bytecode group=g0  8.0 group=g1 Namespace
tdot block    rank=same 1999  Unicode  group=g0  8.1 group=g1 Wiki 
tdot block    rank=same 2000  TEA      group=g0  8.3 group=g1 Tcllib \
                              Tklib XOTcl group=g2 
tdot block    rank=same 2002  vfs      group=g0  8.4 group=g1 Starkit Dict Snit
tdot block    rank=same 2007  Tile     group=g0  8.5 group=g1 
tdot block    rank=same 2012  TclOO    group=g0  8.6 group=g1 TDBC NX group=g2
tdot block    rank=same future zipvfs  group=g0  8.7 group=g1 Null group=g2 tdot group=g3

# specific node settings 
tdot node     History label="History of Tcl/Tk\nand  tdot" shape=doubleoctagon color="salmon" penwidth=5 \
      fillcolor="white" fontsize=26 fontname="Monaco"
tdot node     Namespace fillcolor="#ff9999"
tdot node     future label=2021
tdot node     8.7    label="8.7a5"
# arranging the History in the middle
tdot addEdge  8.7 -> Null style=invis
tdot addEdge  Null -> History style=invis
tdot node Null style=invis
tdot write tdot-history.png
