.PHONY: clean pdf_normal pdf_printer pdf_grayscale
.SUFFIXES: .mkd .html .tex .pdf

PANDOC := pandoc --wrap=none -s -T \
	"Apprendre Haskell vous fera le plus grand bien !"
HSCOLOUR := HsColour -lit
UNLIT1 := sed "s/<pre><span class='hs-varop'>&gt;<\/span> /<pre>/g"
UNLIT2 := sed "s/^<span class='hs-varop'>&gt;<\/span> //g"
UNLIT3 := sed "s/^<span class='hs-varop'>&gt;<\/span>//g"
RMFIRST9 := tail -n +10
RMLAST2 := head -n -2

SOURCE := $(wildcard *.mkd)
TARGET := $(addprefix html/, $(SOURCE:.mkd=.html))

ORDEREDHTML := chapitres.html introduction.html demarrons.html \
	types-et-classes-de-types.html syntaxe-des-fonctions.html \
	recursivite.html fonctions-d-ordre-superieur.html modules.html \
	creer-nos-propres-types-et-classes-de-types.html entrees-et-sorties.html \
	resoudre-des-problemes-fonctionnellement.html \
	foncteurs-foncteurs-applicatifs-et-monoides.html \
	pour-une-poignee-de-monades.html et-pour-quelques-monades-de-plus.html \
	zippeurs.html

HTMLFILES := $(addprefix html/, $(ORDEREDHTML))

all: clean $(TARGET) pdf pdf_printer pdf_grayscale

html/%.html:%.mkd
	cat $< | $(HSCOLOUR) -css | $(RMFIRST9) | $(RMLAST2) \
	| $(PANDOC) -t html+smart -c hscolour.css \
	-B before.html -A after.html -H header.html \
	| $(UNLIT1) | $(UNLIT2) | $(UNLIT3) > $@

# ${1}: one of {grayscale,normal,printer}
define mkPDF
	cp html/hscolour_pdf_${1}.css html/hscolour.css
	wkhtmltopdf -s A4 --use-xserver \
		--title "Apprendre Haskell vous fera le plus grand bien \!" \
		toc toc.xslt --load-error-handling ignore $(HTMLFILES) \
		apprendre-haskell-vous-fera-le-plus-grand-bien-${1}.pdf
endef

# colorful, black backgrounds for code
pdf_normal:
	$(call mkPDF,normal)

# colorful, white backgrounds for code (saves toner)
pdf_printer:
	$(call mkPDF,printer)

# grayscale, better contrast for black-and-white printers
pdf_grayscale:
	$(call mkPDF,grayscale)

clean:
	rm -f $(TARGET)
