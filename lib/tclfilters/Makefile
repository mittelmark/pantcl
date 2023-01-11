filter-docs: filter-abc.html \
	filter-cmd.html \
	filter-dot.html \
	 filter-eqn.html \
	 filter-kroki.html \
 	 filter-mmd.html \
 	 filter-mtex.html \
	 filter-pic.html \
	 filter-pik.html \
	 filter-pipe.html \
 	 filter-puml.html \
	 filter-sqlite.html \
	 filter-tdot.html \
	 filter-tcrd.html \
	 filter-tsvg.html \
	 filter-rplot.html \
 	 filter-tcl.html
	 -rm temp*
	 -rm mini*ly mini.p* out.json mini.svg hello* hw* links.md photo*
	 -rm barplot* calc* doplot.R digraph* dot.png eqn.png math.eqn mesh*png  file?
	 -rm mini*png octave.png plot.R plotR.png pyhist.png sample* sin*
	 -rm sqlite-?.sqlite test*
%.html: %.tcl mini.css
	pandoc header.md -o header.html
	# -B header.html 
	tclsh ../../pantcl.tcl $< temp.html -s --css mini.css \
		-M date="`date +"%b %d, %Y"`" 
	htmlark temp.html -o `basename $< .tcl`.html
	rm temp.html
	
