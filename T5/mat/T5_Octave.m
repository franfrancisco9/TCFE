%gain stage

C1 = 220e-9
R1 = 1e3
C2 = 110e-9
R2 = 1e3
R3 = 150e3
R4 = 1e3

f = 1000
w = 2*pi*f

Zc1 = 1/j/w/C1
Zc2 = 1/j/w/C2


Zip = abs(Zc1+R1)
Zop = abs(1/(1/R2+1/Zc2))

vm = R1/(R1+Zc1)
Va = (1+R3/R4)*vm
Gainp = abs(Zc2/(Zc2+R2)*Va)
Gainp_db = 20*log10(Gainp)


f = logspace(1, 5, 41);
w = 2*pi*f;

Zc1 = 1./(j*w*C1);
Zc2 = 1./(j*w*C2);


Zi = abs(Zc1+R1);
Zo = abs(1./(1/R2+1./Zc2));

vm = R1./(R1+Zc1);
Va = (1+R3/R4).*vm;
Ts = Zc2./(Zc2+R2).*Va;
Gain = abs(Ts);
Gain_db = 20*log10(Gain);
phase = angle(Ts)*180/pi;


MaxAv = max(Gain_db)
  low = 0;
for i=1:length(Gain_db)
	if (Gain_db(i) >= MaxAv-3 && !low)
	  %lowCOf = (f(i)+f(i-1))/2
	  lowCOf = f(i-1)
	    low = 1;
	endif
	if (Gain_db(i) <= MaxAv-3 && low)
	  %highCOf = (f(i)+f(i-1))/2
	  highCOf = f(i-1)
	    low = 0;
	endif
	if(Gain_db(i) == MaxAv)
	  Maxf = f(i)
	endif
endfor

centralFreq = sqrt(lowCOf*highCOf)	
	
hf = figure ();

plot(log10(f), phase, "-", log10(f), Gain_db, "-")
hold

title("Frequency response")
xlabel ("log10(f) [Hz]")
legend("phase [deg]", "gain [dB]")
print (hf,"gain.eps", "-depsc");
close(hf);



ff = fopen("tabz.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff," & Value\\\\ \\midrule\n");
fprintf(ff,"$LowFreq$ & %g \\\\\n", lowCOf);
fprintf(ff,"$HighFreq$ & %g \\\\\n", highCOf);
fprintf(ff,"$CentralFreq$ & %g \\\\\n", centralFreq);
fprintf(ff,"$Z_{I}$ & %g \\\\\n", Zip);
fprintf(ff,"$Z_{O}$ & %g \\\\\n", Zop);
fprintf(ff,"$Gain$ & %g \\\\\n", Gainp);
fprintf(ff,"$Gain\\ (dB)$ & %g \\\\ \\bottomrule\n", Gainp_db);
fprintf(ff,"\\end{tabular}");
fclose(ff);



ff = fopen("tab-line1.tex","w");
fprintf(ff,"$LowFreq$ & %g \n", lowCOf);
fclose(ff);

ff = fopen("tab-line2.tex","w");
fprintf(ff,"$HighFreq$ & %g \n", highCOf);
fclose(ff);

ff = fopen("tab-line3.tex","w");
fprintf(ff,"$CentralFreq$ & %g \n", centralFreq);
fclose(ff);

ff = fopen("tab-line4.tex","w");
fprintf(ff,"$Z_{I}$ & %g \n", Zip);
fclose(ff);

ff = fopen("tab-line5.tex","w");
fprintf(ff,"$Z_{O}$ & %g \n", Zop);
fclose(ff);

ff = fopen("tab-line6.tex","w");
fprintf(ff,"$Gain$ & %g \n", Gainp);
fclose(ff);

ff = fopen("tab-line7.tex","w");
fprintf(ff,"$Gain\\ (dB)$ & %g \n", Gainp_db);
fclose(ff);