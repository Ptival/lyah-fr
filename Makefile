.SUFFIXES: .mkd .html .tex .pdf

PANDOC := pandoc --no-wrap -s -S -T "Apprenez Haskell pour le meilleur !"
HSCOLOUR := HsColour -lit
UNLIT1 := sed "s/<pre><span class='hs-varop'>&gt;<\/span> /<pre>/g"
UNLIT2 := sed "s/^<span class='hs-varop'>&gt;<\/span> //g"
UNLIT3 := sed "s/^<span class='hs-varop'>&gt;<\/span>//g"
RMFIRST9 := tail -n +10
RMLAST2 := head -n -2

SOURCE := $(wildcard *.mkd)
TARGET := $(SOURCE:.mkd=.html)

all: $(TARGET)

.mkd.html:
	cat $< | $(HSCOLOUR) -css | $(RMFIRST9) | $(RMLAST2) \
	| $(PANDOC) -t html -c hscolour.css \
	| $(UNLIT1) | $(UNLIT2) | $(UNLIT3) > $@

.mkd.tex:
	cat $< | $(HSCOLOUR) -latex | $(PANDOC) -t latex> $@

.tex.pdf:
	pdflatex $< && pdflatex $< && pdflatex $<

.PHONY: clean

clean:
	rm $(TARGET)
