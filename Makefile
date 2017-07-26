all: dir pdf html word odt

dir:
	mkdir -p /out/out

pdf:
	pandoc --number-sections --smart --filter pandoc-citeproc --variable documentclass=templates/sig-alternate --csl=templates/acm-sig-proceedings.csl --highlight-style=haddock -f markdown -t latex -o /out/out/paper.pdf paper.md
html:
	pandoc --number-sections --smart --filter pandoc-citeproc --standalone --css=pandoc.css --toc --highlight-style=haddock -f markdown -t html -o /out/out/index.html paper.md
	cp templates/pandoc.css /out/out/pandoc.css

word:
	pandoc --number-sections --smart --filter pandoc-citeproc --variable documentclass=templates/sig-alternate --csl=templates/acm-sig-proceedings.csl --highlight-style=haddock -f markdown -o /out/out/paper.docx paper.md
odt:
	pandoc --number-sections --smart --filter pandoc-citeproc --variable documentclass=templates/sig-alternate --csl=templates/acm-sig-proceedings.csl --highlight-style=haddock -f markdown -o /out/out/paper.odt paper.md
