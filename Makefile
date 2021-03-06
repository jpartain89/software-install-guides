# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = _build

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

.PHONY: all
all: install clean linkcheck dummy html
install:
	/bin/bash scripts/install.sh
	@echo
	@echo "Installation Finished."
clean:
	rm -rf $(BUILDDIR)/*
linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."
dummy:
	$(SPHINXBUILD) -b dummy $(ALLSPHINXOPTS) $(BUILDDIR)/dummy
	@echo
	@echo "Build finished. Dummy builder generates no files."
html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

.PHONY: help
help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  build         Runs clean, linkcheck, dummy and builds the documentation"
	@echo "  install       to install needed-python stuff"
	@echo "  clean         Removes any old files, previously built - if present"
	@echo "  local-tests   Removes any old docs and runs local tests "
	@echo "  linkcheck     to check all external links for integrity"
	@echo "  dummy         to check syntax errors of document sources"
	@echo "  html          to make standalone HTML files"
	@echo "  dirhtml       to make HTML files named index.html in directories"
	@echo "  text          to make text files"

.PHONY: build
build: clean linkcheck dummy html

.PHONY: local-tests
local-tests: clean linkcheck dummy

.PHONY: html

.PHONY: dirhtml
dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

.PHONY: text
text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

.PHONY: linkcheck

.PHONY: clean

.PHONY: dummy

.PHONY: install
