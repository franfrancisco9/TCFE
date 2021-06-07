pkg load symbolic;

format short e

C1 = 220e-9;
R1 = 11e3;
C2 = 220e-9;
C3 = 3e-6;
R2 = 11e3;
R3 = 100e3;
R3b = 110e3;
R3c = 100e3;
R4 = 1e3;

system ("ngspice /home/mcarvalho2001/Desktop/TCFE/T5/sim/Optimizing/T5.cir");
cost_opamp = (8.661e-12 + 30e-12)*1000000 + (100000 + 5305 + 5305 + 1836 + 1836 + 13190000 + 50 + 100 + 18160)/1000 + (2*0.1);
cost = cost_opamp + (R1 + R2 + R3 + R3b + R3c + R4)/1000 + (C1 + C2 + C3)*1000000;

dataf = fopen('results.txt','r');
DATA = fscanf(dataf,'%*s = %f')
fclose(dataf);

gaindev = DATA(1);
freqdev = DATA(2);

MERIT = 1/(cost*(abs(gaindev)+abs(freqdev) + 1e-6))
