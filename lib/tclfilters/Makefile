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

%.html: %.tcl mini.css
	pandoc header.md -o header.html
	# -B header.html 
	tclsh ../../pantcl.tcl $< temp.html -s --css mini.css \
		-M date="`date +"%b %d, %Y"`" 
	htmlark temp.html -o `basename $< .tcl`.html
	rm temp.html
