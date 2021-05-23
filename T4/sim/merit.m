pkg load symbolic;

#PRIMEIRA PARTE

%gain stage
format short e
Vcc = 12
Vinm = 1
Vinf = 1000
Rin = 100
Ci = 1e-3
R1 = 105e3
R2 = 20e3
Rc = 0.8e3
Re = 100
Cb = 2.5e-3
Rout = 100
Co = 1e-3
RL = 8
system ("ngspice T4.cir");
cost = Rin/1000 + Ci*1e6 + R1/1000 + R2/1000 + Rc/1000 + Re/1000 + Cb*1e6 + Rout/1000 + Co*1e6 + 2*0.1

dataf = fopen('results.txt','r');
DATA = fscanf(dataf,'%*s = %f')
fclose(dataf);

uco = DATA(2);
lco = DATA(1);
gain = DATA(6)
bandwidth = uco-lco

MERIT = gain*bandwidth/(cost*lco)
