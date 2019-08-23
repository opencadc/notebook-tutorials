# Makefile for HTML for Jupyter Notebooks

MAKEDIR=build
OUTDIR=$(MAKEDIR)/html
VENVDIR=$(MAKEDIR)/venv
# NOTE: only Python3 notebooks are being built. astroquery_example_sitelle.ipynb
# is a Python2 notebook
NBFILES = $(shell grep -l '"version": 3' astroquery_example_*)

NBCONVERT = jupyter nbconvert --output-dir=./$(OUTDIR) --to html

objects := $(patsubst %.ipynb,$(OUTDIR)/%.html,$(NBFILES))

.PHONY: build clean help


build: $(VENVDIR) $(objects)


$(objects): $(OUTDIR)/%.html: %.ipynb
	@echo $<
	@echo NOTEBOOK FILES: $(NBFILES)
	@echo TARGET: $^

	@echo Converting notebooks to HTML
	$(NBCONVERT) --ExecutePreprocessor.timeout=-1 --execute $<
	@echo DONE


$(VENVDIR): requirements3.txt
	rm -fR $(VENVDIR) ;\
	mkdir $(VENVDIR) ;\
	python3 -m venv ./$(VENVDIR) ;\
	source ./$(VENVDIR)/bin/activate ;\

	@echo Installing requirements
	pip install -U pip ;\
	pip install jupyter jupyter_contrib_nbextensions ;\
	pip install -r requirements3.txt ;



clean:
	rm -rf $(MAKEDIR)/* ;\


help: 
	@echo "make"
	@echo " Convert Jupyter notebooks to html"
	@echo "make clean"
	@echo " Remove html directory"
