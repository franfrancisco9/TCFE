pkg load symbolic;

format short e

C1 = 0;
R1 = 1e3;
C2 = 220e-9;
C3 = 220e-9;
Ceq = 110e-9;
R2 = 1e3;
R3 = 100e3;
R3b = 100e3;
R3c = 100e3;
R4 = 1e3;

filename = 'values.txt'
file = fopen(filename, 'w');
fprintf(file, ".subckt uA741    1  2  3  4  5\n  c1   11 12 8.661E-12\n  c2    6  7 30.00E-12\n  dc    5 53 dx\n  de   54  5 dx\n  dlp  90 91 dx\n   dln  92 90 dx\n   dp    4  3 dx\n  egnd 99  0 poly(2) (3,0) (4,0) 0 .5 .5\n  fb    7 99 poly(5) vb vc ve vlp vln 0 10.61E6 -10E6 10E6 10E6 -10E6\n  ga    6  0 11 12 188.5E-6\n  gcm   0  6 10 99 5.961E-9\n  iee  10  4 dc 15.16E-6\n  hlim 90  0 vlim 1K\n  q1   11  2 13 qx\n  q2   12  1 14 qx\n  r2    6  9 100.0E3\n  rc1   3 11 5.305E3\n  rc2   3 12 5.305E3\n  re1  13 10 1.836E3\n  re2  14 10 1.836E3\n  ree  10 99 13.19E6\n  ro1   8  5 50\n  ro2   7 99 100\n  rp    3  4 18.16E3\n  vb    9  0 dc 0\n  vc    3 53 dc 1\n  ve   54  4 dc 1\n  vlim  7  8 dc 0\n  vlp  91  0 dc 40\n  vln   0 92 dc 40\n .model dx D(Is=800.0E-18 Rs=1)\n .model qx NPN(Is=800.0E-18 Bf=93.75)\n .ends \n\n\n .options savecurrents\n Vcc vcc 0 10.0\n Vee vee 0 -10.0\n Vin vin 0 0 ac 1.0 sin(0 700m 1k)\n X1 in_p inv_in vcc vee out uA741 \n\n C1 vin in_p %.11e \n R1 in_p 0 %.11e \n\n R3 inv_in r3b %.11e\n R3b r3b out %.11e\n R3c r3b out %.11e\n R4 inv_in 0 %.11e\n\n R2 out vo %.11e\n C2 vo 0 %.11e\n \n.op \n.end\n\n.control\n\nac dec 10 10 100k\n\nlet Av_db = vdb(vo)-vdb(vin)\nmeas ac voltGainDB MAX Av_db\nlet Av_m = vm(vo)/vm(vin)\nmeas ac voltGain MAX Av_m\nlet voltG3 = voltGainDB-3\n\nmeas ac lowCOf WHEN Av_db=voltG3\nmeas ac Maxf MAX_AT Av_db\nmeas ac highCOf WHEN Av_db=voltG3 CROSS=LAST\n\nlet avgCOf = sqrt(lowCOf*highCOf)\nprint avgCOf\n\n\nlet in_m = vm(in_p)/vm(vin)\nmeas ac inGain MAX in_m\nlet out_m = vm(out)/vm(vin)\nmeas ac outGain MAX out_m\n\n\nlet gain_deviation = abs(voltGainDB - 40)\nlet f_deviation = abs(avgCOf - 1k)\nprint gain_deviation f_deviation > results.txt\n", C1, R1, R3, R3b, R3c, R4, R2, Ceq); 
fflush(filename);
fclose(filename);

system ("ngspice /home/mcarvalho2001/Desktop/Optimizing_v2/T5.cir");
cost_opamp = (8.661e-12 + 30e-12)*1000000 + (100000 + 5305 + 5305 + 1836 + 1836 + 13190000 + 50 + 100 + 18160)/1000 + (2*0.1);
cost = cost_opamp + (R1 + R2 + R3 + R3b + R3c + R4)/1000 + (C1 + C2 + C3)*1000000;

dataf = fopen('results.txt','r');
DATA = fscanf(dataf,'%*s = %f')
fclose(dataf);

gaindevdb = DATA(1);
freqdevdb = DATA(2);

gaindev = 10 ^ (gaindevdb/20);
freqdev = 10 ^ (freqdevdb/20);

MERIT = 1/(cost*gaindev*freqdev + 1e-6)
