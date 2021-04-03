# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS) python T2_octave ngspice1 ngspice2 ngspice.log3 ngspice.log4 ngspice.log5 
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
python:
	python2 ../python/t2_datagen.py 95789 > data.txt
	
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
	

ngspice2: ngspice.log2
	$(eval NGSFIGS2=$(shell grep _FIG2 $< | sed 's/_FIG2//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS2=$(addsuffix .ps, $(NGSFIGS2)))
	$(eval NGSTABS2=$(shell grep _TAB2 $< | sed 's/_TAB2//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach l, $(NGSTABS2), sed -n '/^$l_TAB2/,/^$l_END2/{p;/^$l_END2/q}' $< | grep -v $l_TAB2 | grep -v $l_END2 | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $l_tab2.tex;)
	$(foreach l, $(NGSFIGPS2), ps2pdf $l;)
	
	
ngspice.log1: ../sim/T2_Ngspice_1.cir
	ngspice -b $< -o $@
	
ngspice.log2: ../sim/T2_Ngspice_2.cir
	ngspice -b $< -o $@
	
ngspice.log3: ../sim/T2_Ngspice_3.cir
	ngspice -b $< -o $@
	
ngspice.log4: ../sim/T2_Ngspice_4.cir
	ngspice -b $< -o $@

ngspice.log5: ../sim/T2_Ngspice_5.cir
	ngspice -b $< -o $@
			
T2_octave:
	octave ../mat/T2_Octave.m > octave.log


#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof *.txt *.log1 *.log2 *.log3 *.log4 *.log5 *tab2.tex
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.ps ./*.txt
	@rm -rf *_tab.tex octave-workspace *.eps *nos.tex *malhas.tex *_tab1.tex *.txt ../mat/*.txt ../mat/*.eps ../sim/*.ps *theoretical_*

.PHONY: all clean ngspice octave


