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


f = logspace(1, 8, 1000);
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
print (hf,"theory.eps", "-depsc");
close(hf);

