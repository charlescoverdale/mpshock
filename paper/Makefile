# Build the mpshock working paper PDF.
#
# Usage:
#   make         # regenerate figures/tables and render PDF
#   make pdf     # render PDF only (assumes figures are fresh)
#   make clean   # remove generated files

PANDOC ?= /Applications/quarto/bin/tools/pandoc
RSCRIPT ?= Rscript
PDF_ENGINE ?= xelatex

PAPER := paper.md
REFS := refs.bib
OUT  := paper.pdf

FIGURES := figures/coverage_timeline.pdf \
           figures/us_correlations.pdf \
           figures/cumulative_us.pdf \
           figures/cross_country.pdf \
           figures/distribution.pdf

TABLES := tables/us_correlations.tex \
          tables/series_summary.tex

.PHONY: all pdf figures clean

all: figures pdf

figures: $(FIGURES) $(TABLES)

$(FIGURES) $(TABLES): make_figures.R
	cd .. && RSTUDIO_PANDOC=/Applications/quarto/bin/tools $(RSCRIPT) paper/make_figures.R

pdf: $(OUT)

$(OUT): $(PAPER) $(REFS) $(FIGURES) $(TABLES)
	$(PANDOC) $(PAPER) \
	  --pdf-engine=$(PDF_ENGINE) \
	  --citeproc \
	  --bibliography=$(REFS) \
	  --number-sections \
	  --toc \
	  -o $(OUT)

clean:
	rm -f $(OUT) $(FIGURES) $(TABLES)
