default:
	perl -ne "s/^#' ?(.*)/\$$1/ and print " tsvg.tcl > tsvg.md
	pandoc tsvg.md -s  \
	     --metadata title="tsvg package documentation"  \
	     -o tsvg-temp.html  --filter pantcl \
	     --css mini.css --toc
	htmlark -o tsvg.html tsvg-temp.html
	rm tsvg-temp.html

