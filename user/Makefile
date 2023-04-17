
default:
	cd .. && tclsh pantcl.tcl user/filter-geasy.tcl user/filter-geasy-out.html \
		-s --css mini.css
	cd .. && htmlark user/filter-geasy-out.html -o user/filter-geasy.html
	rm filter-geasy-out.html
	cd .. && tclsh pantcl.tcl user/user-filter.md user/user-filter-out.html \
		-s --css mini.css
	cd .. && htmlark user/user-filter-out.html -o user/user-filter.html
	rm user-filter-out.html
	

