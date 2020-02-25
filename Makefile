LANGS=fr en
OUTPUT:=output
OUTFILES=$(foreach l,$(LANGS),$(OUTPUT)/guide_$(l).ext)

all: html docbook pdf
html: $(OUTFILES:.ext=.html)
docbook: $(OUTFILES:.ext=.xml)
pdf: $(OUTFILES:.ext=.pdf)

IMAGES=images/*

prep:
	mkdir -p $(OUTPUT)
	ln -sf $(shell pwd)/images $(OUTPUT)/images

$(OUTPUT)/guide_%.html: guide_%.adoc prep $(IMAGES)
	@echo $@
	asciidoctor -o $@ $<

$(OUTPUT)/guide_%.xml: guide_%.adoc prep $(IMAGES)
	asciidoctor -o $@ -b docbook5 $<

$(OUTPUT)/guide_%.pdf: $(OUTPUT)/guide_%.xml prep dblatex.xsl
	dblatex --pdf -p dblatex.xsl -O $(OUTPUT) $<

clean:
	-rm $(OUTPUT)/*.html
	-rm $(OUTPUT)/*.xml
	-rm $(OUTPUT)/*.pdf
	-rm $(OUTPUT)/images

.PHONY: clean
