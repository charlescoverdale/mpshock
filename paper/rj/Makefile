# Build the R Journal version of the mpshock paper.
#
# Requires:
#   * R with rticles + rmarkdown installed
#   * pandoc 2.2+ (quarto-bundled version used here)
#   * TeXLive with RJournal.sty (bundled in this directory)
#
# Usage:
#   make         # regenerate paper.tex then compile RJwrapper.pdf
#   make clean   # remove build artefacts

RSCRIPT ?= Rscript
PANDOC_DIR ?= /Applications/quarto/bin/tools

.PHONY: all clean

all: RJwrapper.pdf

RJwrapper.pdf: paper.Rmd RJreferences.bib RJournal.sty RJwrapper.tex header.tex $(wildcard figures/*.pdf) $(wildcard tables/*.tex)
	RSTUDIO_PANDOC=$(PANDOC_DIR) $(RSCRIPT) -e \
	  'rmarkdown::render("paper.Rmd", output_format = rticles::rjournal_article(), quiet = TRUE)'

clean:
	rm -f RJwrapper.pdf paper.tex paper.R
