.PHONY: clean pdf # pdf_normal pdf_printer pdf_grayscale
.SUFFIXES: .md .html .pdf

PANDOC := pandoc --wrap=none -s -T \
	"Apprendre Haskell vous fera le plus grand bien !"
HSCOLOUR := HsColour -lit
UNLIT1 := sed "s/<pre><span class='hs-varop'>&gt;<\/span> /<pre>/g"
UNLIT2 := sed "s/^<span class='hs-varop'>&gt;<\/span> //g"
UNLIT3 := sed "s/^<span class='hs-varop'>&gt;<\/span>//g"
RMFIRST9  := tail -n +10
RMFIRST16 := tail -n +15
RMLAST2   := head -n -2
RMLAST13  := head -n -13

ORDERED_FILES := \
	introduction \
	demarrons \
	types-et-classes-de-types \
	syntaxe-des-fonctions \
	recursivite \
	fonctions-d-ordre-superieur modules \
	creer-nos-propres-types-et-classes-de-types \
	entrees-et-sorties \
	resoudre-des-problemes-fonctionnellement \
	foncteurs-foncteurs-applicatifs-et-monoides \
	pour-une-poignee-de-monades \
	et-pour-quelques-monades-de-plus \
	zippeurs

MARKDOWN_FILES     := $(addprefix markdown/,     $(addsuffix .md,   chapitres $(ORDERED_FILES)))
HTML_FILES         := $(addprefix html/,         $(addsuffix .html, chapitres $(ORDERED_FILES)))
HTML_FOR_PDF_FILES := $(addprefix html-for-pdf/, $(addsuffix .html, $(ORDERED_FILES)))
PDF_FILES          := $(addprefix pdf/,          $(addsuffix .pdf,  $(ORDERED_FILES)))

PDF_FILE := apprendre-haskell-vous-fera-le-plus-grand-bien.pdf

all: $(HTML_FILES) pdf

html/%.html:markdown/%.md
	cat $< \
	| $(HSCOLOUR) -css | $(RMFIRST9) | $(RMLAST2) \
	| $(PANDOC) -t html+smart -c css/hscolour.css \
	-B before.html -A after.html -H header.html \
	| $(UNLIT1) | $(UNLIT2) | $(UNLIT3) > $@

html-for-pdf/%.html:markdown/%.md
	cat $< \
	| sed -re '2,15d' \
	| $(RMLAST13) \
	| $(HSCOLOUR) -css | $(RMFIRST9) | $(RMLAST2) \
	| $(PANDOC) -t html+smart -c css/hscolour.css \
	-B before.html -A after.html -H header.html \
	| $(UNLIT1) | $(UNLIT2) | $(UNLIT3) > $@

pdf/%.pdf:html-for-pdf/%.html
	weasyprint $< $@

pdf:$(PDF_FILES)
	pdftk $(PDF_FILES) cat output $(PDF_FILE)

# ${1}: one of {grayscale,normal,printer}
# define mkPDF
# 	cp html/hscolour_pdf_${1}.css html/hscolour.css
# 	wkhtmltopdf -s A4 --use-xserver \
# 		--title "Apprendre Haskell vous fera le plus grand bien \!" \
# 		toc toc.xslt --load-error-handling ignore $(HTMLFILES) \
# 		apprendre-haskell-vous-fera-le-plus-grand-bien-${1}.pdf
# endef
#
# # colorful, black backgrounds for code
# pdf_normal:
# 	$(call mkPDF,normal)
#
# # colorful, white backgrounds for code (saves toner)
# pdf_printer:
# 	$(call mkPDF,printer)
#
# # grayscale, better contrast for black-and-white printers
# pdf_grayscale:
# 	$(call mkPDF,grayscale)

clean:
	rm -f $(HTML_FILES) $(HTML_FOR_PDF_FILES) $(PDF_FILES)
