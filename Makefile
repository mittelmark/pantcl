
default:
	echo "Usage: make pantcl-docu"
	echo "       make pantcl-app"
	echo "       make install"  
	
pantcl-docu:
	tclsh pantcl.tcl pantcl.tcl pantcl.html --css mini.css -s
	htmlark pantcl.html -o pantcl-out.html
	mv pantcl-out.html pantcl.html
	tclsh pantcl.tcl pantcl-tutorial.md pantcl-tutorial.html --css mini.css -s  --toc \
		--lua-filter=lib/tclfilters/smallcaps.lua
	htmlark pantcl-tutorial.html -o pantcl-out.html
	mv pantcl-out.html pantcl-tutorial.html
		
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
install: pantcl-app
	cp pantcl-tapp/pantcl.tapp ~/.local/bin/pantcl
	chmod 755 ~/.local/bin/pantcl
	
