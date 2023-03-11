#' ---
#' title: "filter-kroki.tcl documentation"
#' author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#' date: 2022-02-18
#' kroki:
#'     app: curl
#'     imagepath: images
#'     ext: svg
#'     eval: 1
#' ---
#' 
# a simple pandoc filter using Tcl the script pantcl.tcl 
# must be in the in the parent directory of the filter directory
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
#' _filter-kroki.tcl_ - Filter using the [https://kroki.io](https://kroki.io) webservice to 
#' display diagram images using many diagram generators.
#' 
#' ## Usage
#' 
#' The conversion of the Markdown documents via Pandoc should be done as follows:
#' 
#' ```
#' pandoc input.md --filter pantcl.bin -s -o output.html
#' ```
#' 
#' The file `filter-kroki.tcl` is not used directly but sourced automatically by the `pantcl.bin` file.
#' If code blocks with the `.kroki` marker are found, the contents in the code block is processed to the 
#' Kroki webservices and optionally download locally the file using wget.
#' 
#' The following options can be given via code chunks or in the YAML header.
#' 
#' > - app - the application to do the download, if none images are just displayed inline, 
#'           currently only curl or wget are supported: default: wget
#'   - ext - file file extension, can be svg, png, pdf, default: svg
#'   - dia - the diagram tool, graphviz, plantuml, pikchr, mermaid etc, default: graphviz
#'   - eval - should the code in the code block be evaluated, default: false
#'   - fig - should a figure be created, default: true
#'   - imagepath - output imagepath, default: images
#'   - include - should the created image be automatically included, default: true
#'   - results - should the output of the command line application been shown, should be show or hide, default: hide
#' 
#' To change the defaults the YAML header can be used. Here an example to change the 
#' default layout engine to neato and the image output path to nfigures
#' 
#' ```
#'  ----
#'  title: "filter-kroki.tcl documentation"
#'  author: "Detlef Groth, Caputh-Schwielowsee, Germany"
#'  date: 2022-02-18
#'  dot:
#'      app: wget
#'      imagepath: nfigures
#'      ext: svg
#'      eval: 1
#'  ----
#' ```
#'
#' ## Examples
#' 
#' Below are a few samples for embedding code for the GraphViz tool dot, for Pikchr and for Plantuml.
#' This filter does just need a working Tcl installation and a connection to the internat for rendering the images.
#' 
#' Links: 
#' 
#' * Kroki Homepage: [https://kroki.io/](https://kroki.io/)
#' 
#' ## Dot graph
#' 
#' ```
#'      ```{.kroki label=digraph eval=true echo=true}
#'      digraph G {
#'        main -> parse -> execute;
#'        main -> init [dir=none];
#'        main -> cleanup;
#'        execute -> make_string;
#'        execute -> printf
#'        init -> make_string;
#'        main -> printf;
#'        execute -> compare;
#'      }
#'      ```
#' ```
#' 
#' Which will produce the following output:
#' 
#' ```{.kroki label=digraph echo=true}
#' digraph G {
#'   main -> parse -> execute;
#'   main -> init [dir=none];
#'   main -> cleanup;
#'   execute -> make_string;
#'   execute -> printf
#'   init -> make_string;
#'   main -> printf;
#'   execute -> compare;
#' }
#' ```
#' 
#' Here a ditaa diagram `{.kroki label=ditaa eval=true echo=true dia=ditaa}`:
#' 
#' ```{.kroki label=ditaa echo=true dia=ditaa}
#' +----------------------------------------+
#' | File | Help   cEEE                     |
#' +-------------+--------------------------+
#' |  ttk.Button | ttk.Combobox             |
#' +-------------+--------------------------+
#' |             |                          |
#' | tk.Listbox  | tk.Text                  |
#' |             |                          |
#' |            <+>                         |
#' |             |                          |
#' |             |                          |
#' |             |                          |
#' +-------------+--------+-----------------+
#' | ttk.Label            | ttk.Progressbar | 
#' +----------------------+-----------------+
#' ```
#'
#' Support for UniCode is there as well where the monospaced front has some problems in aligning (`{.kroki label=ditaauc eval=true dia=ditaa}`):
#'
#' ```{.kroki label=ditaauc dia=ditaa}
#' A₀ ---> A₁ ---> A₂ ---> A₃ ---> A₄
#'
#' |       |       |       |       |            
#' | f₀    | f₁    | f₂    | f₃    | f₄    
#' |       |       |       |       |      
#' v       v       v       v       v      
#'
#' B₀ ---> B₁ ---> B₂ ---> B₃ ---> B₄
#' ````
#'
#' A nonoml example `{.kroki label=nomnoml ext=svg eval=true dia=nomnoml}`:
#'
#' ```{.kroki label=nomnoml ext=svg dia=nomnoml}
#' [Pirate|eyeCount: Int|raid();pillage()|
#'   [beard]--[parrot]
#'   [beard]-:>[foul mouth]
#' ]
#' 
#' [<table>mischief | bawl | sing || yell | drink]
#' 
#' [<abstract>Marauder]<:--[Pirate]
#' [Pirate]- 0..7[mischief]
#' [jollyness]->[Pirate]
#' [jollyness]->[rum]
#' [jollyness]->[singing]
#' [Pirate]-> *[rum|tastiness: Int|swig()]
#' [Pirate]->[singing]
#' [singing]<->[rum]
#' 
#' [<start>st]->[<state>plunder]
#' [plunder]->[<choice>more loot]
#' [more loot]->[st]
#' [more loot] no ->[<end>e]
#' 
#' [<actor>Sailor] - [<usecase>shiver me;timbers]
#' ```
#' 
#' ### Svgbob example `{.kroki label=svgbob dia=svgbob eval=true}`:
#' 
#' ```{.kroki label=svgbob dia=svgbob}
#'    0       3                     
#'      *-------*      +y           
#'   1 /|    2 /|       ^           
#'    *-+-----* |       |           
#'    | |4    | |7      | ??        
#'    | *-----|-*     ? +-----> +x  
#'    |/      |/       / ?          
#'    *-------*       v             
#'   5       6      +z              
#'
#' .-------.     .-------.
#' | {red} |     |       |
#' |   A   | --> |   B   | 
#' |       |     |       |
#' '-------'     '-------'
#' 
#' +-------+
#' | {r1}  |
#' |       |
#' +-------+
#' 
#'        "F-Dur"
#' o +---+---+---+---+
#'   +-*-+---+---+---+
#' o +---+---+---+---+
#'   +---+-*-+---+---+
#' 
#'         ^                  .- - - - -  
#'         |                  :
#'         |                  : 
#'     Uin |   .--------------+---------
#'         |   |
#'         |   |
#'         *---'------------------------>
#' 
#'   .-------.   
#'   | ...   |   
#'   | ....  |   
#'   +-------+   
#'  /// ___ \\\  
#' '-----------' 
#'               
#' # Legend:
#' r1 = {
#'    fill: papayawhip;
#' }
#' red = {
#'    fill: salmon;
#'    stroke: crimson;
#' }
#' ```
#'
#' ### ERD example `{.kroki label=erd dia=erd eval=true}`
#' 
#' ```{.kroki label=erd dia=erd}
#' [Person]
#' *name
#' height
#' weight
#' +birth_location_id
#' 
#' [Location]
#' *id
#' city
#' state
#' country
#
#' Person *--1 Location
#' ```
#' 
#' ## Document creation

#' Assuming that the file pantcl.bin is in your PATH, 
#' this document, a Tcl file with embedded Markdown and kroki code
#' can be converted into a HTML file for instance using the command line:
#' 
#' ```
#' pantcl.bin filter-kroki.tcl filter-kroki.html -s --css mini.css
#' ```
#' 
#' Standard Markdown files with embedded kroki code can be converted with the same command line:
#' 
#' ```
#' pantcl.bin sample.md sample.html -s 
#' ```
#' 
#' ## See also:
#' 
#' * [Pantcl Readme](../../README.html)
#' * [Pantcl documentation](../../pantcl.html)
#' * [Mermaid filter](filter-mmd.html)
#' * [Pikchr filter](filter-pik.html)
#' * [PlantUML filter](filter-puml.html)
#' * [GraphViz filter](filter-dot.html)
#' 

proc dia2kroki {text {dia graphviz} {ext svg}} {
    set b64 [string map {+ - / _ = ""}  [binary encode base64 [zlib compress [encoding convertto utf-8 $text]]]]
    set uri https://kroki.io//$dia/$ext/$b64
}



proc filter-kroki {cont dict} {
    global n
    incr n
    set def [dict create results show eval true fig true dia graphviz width 400 height 400 \
             include true imagepath images app wget label null ext svg]
    set dict [dict merge $def $dict]
    set ret ""
    set owd [pwd] 
    if {[dict get $dict label] eq "null"} {
        set fname [file join $owd [dict get $dict imagepath] kroki-$n]
    } else {
        set fname [file join $owd [dict get $dict imagepath] [dict get $dict label]]
    }
    if {![file exists [file join $owd [dict get $dict imagepath]]]} {
        file mkdir [file join $owd [dict get $dict imagepath]]
    }
    set url [dia2kroki $cont [dict get $dict dia] [dict get $dict ext]]
    if {[dict get $dict app] eq "wget"} {
        set res [exec -ignorestderr wget -q $url -O $fname.[dict get $dict ext]]
    } elseif {[dict get $dict app] eq "curl"} {
        set res [exec -ignorestderr curl $url -s --output $fname.[dict get $dict ext]]
    }
    if {[dict get $dict results] eq "show"} {
        # should be usually empty
        set res $res
    } else {
        set res ""
    }
    set img ""
    if {[dict get $dict fig]} {
        if {[dict get $dict include]} {
            if {[dict get $dict app] in [list wget curl]} {
                set img $fname.[dict get $dict ext]
            } else {
                set img $url
            }
        }
    }
    return [list $res $img]
}
