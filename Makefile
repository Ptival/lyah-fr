.SUFFIXES: .mkd .html .tex .pdf

PANDOC := pandoc --no-wrap -s -S -T \
	"Apprendre Haskell vous fera le plus grand bien !"
HSCOLOUR := HsColour -lit
UNLIT1 := sed "s/<pre><span class='hs-varop'>&gt;<\/span> /<pre>/g"
UNLIT2 := sed "s/^<span class='hs-varop'>&gt;<\/span> //g"
UNLIT3 := sed "s/^<span class='hs-varop'>&gt;<\/span>//g"
RMFIRST9 := tail -n +10
RMLAST2 := head -n -2

SOURCE := $(wildcard *.mkd)
TARGET := $(addprefix html/, $(SOURCE:.mkd=.html))

ORDEREDHTML := introduction.html demarrons.html \
	types-et-classes-de-types.html syntaxe-des-fonctions.html \
	recursivite.html fonctions-d-ordre-superieur.html modules.html \
	creer-nos-propres-types-et-classes-de-types.html entrees-et-sorties.html \
	resoudre-des-problemes-fonctionnellement.html \
	foncteurs-foncteurs-applicatifs-et-monoides.html \
	pour-une-poignee-de-monades.html et-pour-quelques-monades-de-plus.html \
	zippeurs.html

HTMLFILES := $(addprefix html/, $(ORDEREDHTML))

all: $(TARGET)

html/%.html:%.mkd
	cat $< | $(HSCOLOUR) -css | $(RMFIRST9) | $(RMLAST2) \
	| $(PANDOC) -t html -c hscolour.css \
	-B before.html -A after.html -H header.html \
	| $(UNLIT1) | $(UNLIT2) | $(UNLIT3) > $@

.PHONY: pdf clean printer_friendly_pdf

pdf:
	cp html/hscolour.css html/hscolour.tmp
	sed -i 's/content {width: 800px; /content {/g' html/hscolour.css
	wkhtmltopdf --toc --toc-depth 2 -s A3 --disable-internal-links \
		--title "Apprendre Haskell vous fera le plus grand bien \!" \
		--cover html/pdfcover.html $(HTMLFILES) \
		apprendre-haskell-vous-fera-le-plus-grand-bien.pdf
	mv html/hscolour.tmp html/hscolour.css

printer_friendly_pdf:
	cp html/hscolour.css html/hscolour.tmp
	cp html/hscolour_printer.css html/hscolour.css
	wkhtmltopdf --toc --toc-depth 2 -s A3 --disable-internal-links \
		--title "Apprendre Haskell vous fera le plus grand bien \!" \
		--cover html/pdfcover.html $(HTMLFILES) \
		apprendre-haskell-vous-fera-le-plus-grand-bien_printer-friendly.pdf
	mv html/hscolour.tmp html/hscolour.css

clean:
	rm $(TARGET)
