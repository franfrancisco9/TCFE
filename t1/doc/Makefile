# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS)  ngspice
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex

#octave.log:
	#octave ../mat/rc.m > octave.log

ngspice: ngspice.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	
	$(eval NGSFIGS1=$(shell grep _FIG1 $< | sed 's/_FIG1//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS1=$(addsuffix .ps, $(NGSFIGS1)))
	$(eval NGSTABS1=$(shell grep _TAB1 $< | sed 's/_TAB1//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach j, $(NGSTABS1), sed -n '/^$j_TAB1/,/^$j_END1/{p;/^$j_END1/q}' $< | grep -v $j_TAB1 | grep -v $j_END1 | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $j_tab1.tex;)
	$(foreach j, $(NGSFIGPS1), ps2pdf $j;)

ngspice.log: ../sim/t1.cir
	ngspice -b $< -o $@


#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.ps
	@rm -rf *_tab.tex octave-workspace *.eps

.PHONY: all clean ngspice octave


