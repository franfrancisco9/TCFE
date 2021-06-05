pkg load symbolic;

#PRIMEIRA PARTE

%gain stage

format short e

C1 = 220e-9
R1 = 1e3
C2 = 110e-9
R2 = 1e3
R3 = 150e3
R4 = 1e3

system ("ngspice T4.cir");
cost_opamp = (8.661e-12 + 30e-12)*1000000 + (100000 + 5305 + 5305 + 1836 + 1836 + 13190000 + 50 + 100 + 18160)/1000 + (2*0.1)
cost = cost_opamp + (R1 + R2 + R3 + R4)/1000 + (C1 + C2)*1000000;

dataf = fopen('results.txt','r');
DATA = fscanf(dataf,'%*s = %f')
fclose(dataf);

gaindevdb = DATA(1);
freqdevdb = DATA(2);

gaindev = 10 ^ (gaindevdb/20);
freqdev = 10 ^ (freqdevdb/20);

MERIT = 1/(cost*gaindev*freqdev + 1e-6)
