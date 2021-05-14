# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS) ngspice1 T4_octave
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex

	
ngspice1: ngspice.log1 
	$(eval NGSFIGS1=$(shell grep _FIG1 $< | sed 's/_FIG1//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS1=$(addsuffix .ps, $(NGSFIGS1)))
	$(eval NGSTABS1=$(shell grep _TAB1 $< | sed 's/_TAB1//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach j, $(NGSTABS1), sed -n '/^$j_TAB1/,/^$j_END1/{p;/^$j_END1/q}' $< | grep -v $j_TAB1 | grep -v $j_END1 | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $j_tab1.tex;)
	$(foreach j, $(NGSFIGPS1), ps2pdf $j;)
	
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	
ngspice.log1: ../sim/T4.cir
	ngspice -b $< -o $@
	

T4_octave:
	octave ../mat/T4_Octave.m > octave.log


#convert libreoffice draw figures to pdf
%.pdf: %.odg 
	soffice --headless --convert-to pdf $<


clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof *.txt *.log1 *.log2 *.log3 *.log4 *.log5 *tab2.tex
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.ps ./*.txt
	@rm -rf *_tab.tex octave-workspace *.eps *nos.tex *malhas.tex *_tab1.tex *.txt ../mat/*.txt ../mat/*.eps ../sim/*.ps *theoretical_*

.PHONY: all clean ngspice octave


