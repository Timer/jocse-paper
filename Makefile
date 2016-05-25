all: dir pdf html

# Build a number of formats into the `out/` directory. These will get published via Github pages.
dir:
	mkdir -p out

pdf:
	pandoc -H templates/tables.tex --smart --filter pandoc-citeproc --variable documentclass=templates/sig-alternate --csl=templates/acm-sig-proceedings.csl --highlight-style=haddock -f markdown -t latex -o out/paper.pdf paper.md
html:
	pandoc -H templates/tables.tex --smart --filter pandoc-citeproc --standalone --css=pandoc.css --toc --highlight-style=haddock -f markdown -t html -o out/index.html paper.md
	cp templates/pandoc.css out/pandoc.css
