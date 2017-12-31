#
# Makefile for projects using multibib
#
latex=pdflatex

# Function to grep the multibib citation names out
# of a file and quote them
multibib_names = $(shell \
	grep -o '\\bibliography[^{}]*{' $(1) \
	| grep -v style \
	| sort \
	| uniq \
	| sed 's/\\bibliography/"/;s/{/"/')

web_repo=dinatale2.github.io

# Any PDF is a valid target, but this is the default one.
all: giuseppe-cv.pdf

%.pdf: %.tex Sections/*.tex Bibliographies/*.bib
	$(latex) $*
	for qname in $(call multibib_names,$<); do \
		if [ -z $${qname} ]; then \
			bibtex $*; \
		else \
			bibtex $${qname}; \
		fi; \
	done; \
	$(latex) $*
	$(latex) $*

upload:
	cp giuseppe-cv.pdf $(web_repo)/cv/giuseppe-cv.pdf
	cd $(web_repo) && \
		git add cv/giuseppe-cv.pdf && \
		git commit -m "CV update" && \
		git push

clean:
	rm -f *.pdf
	rm -f *.aux *.bbl *.blg *.log *.out *.top *.tui
	rm -f *-mpgraph.mp *synctex.gz*
