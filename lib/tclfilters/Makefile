filter-docs: filter-abc.html \
	filter-cmd.html \
	filter-dot.html \
	filter-emf.html \
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
	 -rm -f temp*
	 -rm -f mini*ly mini.p* out.json mini.svg hello* hw* links.md photo*
	 -rm -f barplot* calc* doplot.R digraph* dot.png eqn.png math.eqn mesh*png  file?
	 -rm -f mini*png octave.png plot.R plotR.png pyhist.png sample* sin*
	 -rm -f sqlite-?.sqlite test*
%.html: %.tcl mini.css
	pandoc header.md -o header.html
	# -B header.html 
	tclsh ../../pantcl.tcl $< temp.html -s --css mini.css \
		-M date="`date +"%b %d, %Y"`" --syntax-definition ../../xml/emf.xml
	htmlark temp.html -o `basename $< .tcl`.html
	rm temp.html
	
julia:
	tclsh ../../pantcl.tcl julia-example.md temp.html -s --css mini.css \
		-M date="`date +"%b %d, %Y"`" --syntax-definition ../../xml/emf.xml

