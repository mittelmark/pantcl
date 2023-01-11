
default:
	echo "Usage: make pantcl-docu"
	
pantcl-docu:
	tclsh pantcl.tcl pantcl.tcl pantcl.html --css mini.css -s
