filter=geasy
default:
	cd .. && tclsh pantcl.tcl user/filter-$(filter).tcl user/filter-$(filter)-out.html \
		-s --css mini.css
	cd .. && htmlark user/filter-$(filter)-out.html -o user/filter-$(filter).html
	rm filter-$(filter)-out.html
	cd .. && tclsh pantcl.tcl user/user-filter.md user/user-filter-out.html \
		-s --css mini.css
	cd .. && htmlark user/user-filter-out.html -o user/user-filter.html
	rm user-filter-out.html
	

