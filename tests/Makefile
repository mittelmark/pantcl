rst:
	pandoc sample.rst --filter ../pantcl.tcl -o sample-rst.html -s \
		--metadata-file sample.yaml
	htmlark sample-rst.html -o sample-out.html
	mv sample-out.html sample-rst.html
	pandoc sample.rst --filter ../pantcl.tcl -o sample-rst.pdf --metadata documentclass=scrartcl \
		--metadata-file sample.yaml
tex:
	 pandoc sample.tex --filter ../pantcl.tcl -o sample-tex.pdf \
		 --metadata documentclass=scrartcl
rst-standalone:
	pandoc sample.rst -o sample-rst.md
	tclsh ../pantcl.tcl sample-rst.md sample-rst.html -s --css mini.css \
		--metadata-file sample.yaml --no-pandoc
