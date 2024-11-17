sdx=/home/groth/workspace/delfgroth/mytcl/bin/sdx.kit
default:
	echo "Usage: make pantcl-docu"
	echo "       make pantcl-app"
	echo "       make install"  
	
pantcl-docu:
	pandoc header.md -o header.html
	TCLLIBPATH=lib tclsh pantcl.tcl pantcl.tcl pantcl.md --no-pandoc 
	pandoc pantcl.md -o pantcl.html --css mini.css -s
	htmlark pantcl.html -o pantcl-out.html
	mv pantcl-out.html pantcl.html
	echo done
	tclsh pantcl.tcl pantcl-tutorial.md pantcl-tutorial-out.md --no-pandoc
	pandoc pantcl-tutorial-out.md -o pantcl-tutorial.html -s --css mini.css  --toc \
		--lua-filter=lib/tclfilters/smallcaps.lua
	htmlark pantcl-tutorial.html -o pantcl-out.html
	mv pantcl-out.html pantcl-tutorial.html
	pandoc README.md -o README.html --css mini.css -s --metadata title="Pantcl README" --metadata author="Detlef Groth" --metadata date="`date +%Y-%m-%d`"
	htmlark README.html -o temp.html && mv temp.html README.html
	
		
pantcl-app:
	if [ ! -d pantcl-tapp ] ;  then mkdir pantcl-tapp ; fi
	cp pantcl.tcl pantcl-tapp/
	-rm -rf pantcl-tapp/pantcl.vfs
	if [ ! -d  pantcl-tapp/pantcl.vfs ] ;  then mkdir  pantcl-tapp/pantcl.vfs ; fi
	echo "lappend auto_path [file normalize [file join [file dirname [info script]] lib]]" > pantcl-tapp/pantcl.vfs/main.tcl	
	if [ ! -d  pantcl-tapp/pantcl.vfs/lib ] ;  then mkdir  pantcl-tapp/pantcl.vfs/lib ; fi	
	cp -r lib/* pantcl-tapp/pantcl.vfs/lib/
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*~
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*md
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.ly
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.R
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*lua
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.n	
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.dot	
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.svg
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.png
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.html	
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.css		
	rm -f pantcl-tapp/pantcl.vfs/lib/*/*.pdf			
	rm -rf pantcl-tapp/pantcl.vfs/lib/tclfilters/figures
	rm -rf pantcl-tapp/pantcl.vfs/lib/tclfilters/images
	rm -rf pantcl-tapp/pantcl.vfs/lib/tclfilters/out	
	cd pantcl-tapp && tclsh ../bin/tpack.tcl wrap pantcl.tapp
	ls -lh pantcl-tapp/pantcl.tapp
	cp pantcl-tapp/pantcl.tapp pantcl-tapp/pantcl.bin
install: pantcl-app
	cp pantcl-tapp/pantcl.tapp ~/.local/bin/pantcl
	chmod 755 ~/.local/bin/pantcl

winexe: pantcl-app
	cp pantcl.tcl pantcl-tapp/pantcl.vfs/main.tcl
	cd pantcl-tapp && tclkit $(sdx) wrap pantcl.exe -runtime tclkit-8.6.12.exe

starkit: pantcl-app
	cp pantcl.tcl pantcl-tapp/pantcl.vfs/main.tcl
	cd pantcl-tapp && tclkit $(sdx) wrap pantcl.kit

tests-docs:
	echo "knitr::knit('tests/sample-pandoc-header.Rmd','tests/sample-pandoc-header.md')" | Rscript - 
	pandoc tests/sample-pandoc-header.md -o tests/sample-pandoc-header.html -s --css mini.css 
	tclsh pantcl.tcl tests/sample-pandoc-header.Rmd tests/sample-pandoc-header-pantcl.html --no-pandoc
	tclsh pantcl.tcl tests/sample-yaml-header.Rmd tests/sample-yaml-header.html --no-pandoc
