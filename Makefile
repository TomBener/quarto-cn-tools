# `make` or `make all`: Render DOCX, HTML, PDF, ePub and Reveal.js slides at once.
# `make docx`: Render DOCX.
# `make html`: Render HTML.
# `make pdf`: Render PDF.
# `make epub`: Render ePub.
# `make slides`: Render Reveal.js slides.
# `make print`: Render PDF for print.
# `make watermark`: Render PDF with watermark.
# `make citebib`: Extract all bibliographies cited as BibLaTeX file `citebib.bib`.
# `make clean`: Remove auxiliary and output files.

# Render DOCX, HTML, PDF, ePub and Reveal.js slides at once
.PHONY: all
all: docx html pdf epub slides

# Pandoc command for extracting bibliographies
CITE := @pandoc \
	--quiet \
	--file-scope \
	--lua-filter _extensions/get-bib.lua \
	--wrap=preserve \
	contents/[0-9]*.md

# Extract all bibliographies cited as `citebib.bib`
citebib:
	$(CITE) --bibliography bibliography.bib --to biblatex | \
	perl -pe 's/^}$$/}\n/ if !eof' > citebib.bib

# Target for generating and processing QMD files
.PHONY: dependencies
dependencies:
	@python _extensions/format-md.py

QUARTO := @quarto render index.qmd --to
FILTERS := -L _extensions/citation-backlinks.lua \
	-L _extensions/localize-cnbib.lua \
	-L _extensions/cnbib-quotes.lua \
	--filter _extensions/sort-cnbib.py

# Render DOCX
docx: dependencies
	$(QUARTO) $@ $(FILTERS)

# Render HTML
html: dependencies
	$(QUARTO) $@ $(FILTERS) --filter _extensions/auto-correct.py

# Render PDF
pdf: dependencies
	$(QUARTO) $@ $(if $(findstring pdf,$@),--output $(PDF_OUTPUT) $(PDF_OPTION))

# Initial PDF settings
PDF_OUTPUT := index.pdf

# Special handling for print PDF
.PHONY: print
print: PDF_OPTION := -V draft -M biblatexoptions="backend=biber,backref=false,dashed=false, \
gblabelref=false,gblanorder=englishahead,gbnamefmt=lowercase,gbfieldtype=true,doi=false"
print: PDF_OUTPUT := print.pdf
print: pdf

# Special handling for watermark PDF
.PHONY: watermark
watermark: PDF_OPTION := -V watermark=true
watermark: PDF_OUTPUT := watermark.pdf
watermark: pdf

# Render ePub
epub: dependencies
	$(QUARTO) $@ -L _extensions/localize-cnbib.lua -L _extensions/cnbib-quotes.lua \
	--filter _extensions/sort-cnbib.py --filter _extensions/auto-correct.py

# Render Reveal.js slides
slides: dependencies
	@quarto render slides.qmd --to revealjs --filter _extensions/auto-correct.py

# Clean up generated files
.PHONY: clean
clean:
	@$(RM) -r .quarto .jupyter_cache *_cache *_files _freeze contents/*.qmd cite* outputs
