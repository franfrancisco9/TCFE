close all
clear all
format long e
merit = 0;
j = 0;
% inicializar variáveis
for C=0e-6:0.25e-6:6.5e-6
  for n_diodes=15:1:18
    for R_env=0.0e3:0.5e3:6.0e3
      for R_reg=0e3:0.5e3:5e3
                  V_primary = 230;
                  f = 50;
                  w = 2*pi*f;
                  Is = 1* 10^(-14);
                  VT = 0.025; 
                  eta = 1;
                  %n = 1.533;
                  t = linspace(0, 0.2, 1000);

                  vc = zeros(1, length(t));
                  vo_enve = zeros(1, length(t));
                  vo_regac = zeros(1, length(t));

                  vo_reg = zeros(1, length(t));
                  vo_regdc = 0;
                  vo_regac = zeros(1, length(t));

                  % voltage regulator
                  ix = Is * (exp(12/(n_diodes*eta*VT))-1);%equacao do diodo
                  rd = eta * VT / (ix + Is); %resistencia incremental diodo
                  V_r_reg = ix * R_reg; % voltagem nos terminais da resistência
                  Vc = V_r_reg + 12; % lei das malhas -> variável devolve a voltagem que entra no circuito = voltagem (média) no condensador do envelope
                  A_secondary = Vc;
                      if (A_secondary >= 250 || A_secondary < 12)
                          i = 1;
                      else
                          cost = R_env*10^-3 + R_reg*10^-3 + (4 + n_diodes)*0.1 + C*10^6;
                                  
                          filename = 'ngspice_T3.cir';

                          file = fopen(filename, 'w');

                          fprintf(file, "* T3\n* forces current values to be saved\n.options savecurrents\nVin 3 1 DC 0 SIN(0 %f 50 0 0 90)\n\n*Envelop Detector\n\nD1 0 3 default\nD2 3 2 default\nD3 1 2 default\nD4 0 1 default\n\nR1 2 0 %d\n\nC 2 0 %d\n\n*Voltage Regulator\n\nR2 2 4 %d\nDr 4 0 Dmine\n.MODEL Default D\n.MODEL Dmine D (N=%d)\n\n\n\n\n\n* Transient simulation:\n.control\n\nset hcopypscolor=1\nset color0=white\nset color1=black\nset color2=red\nset color3=blue\nset color4=violet\nset color5=rgb:3/8/0\nset color6=rgb:4/0/0\n\nop\n\n\ntran 1e-5 0.2\n\n*plot  v(2)\n*hardcopy venv.ps v(2)\n\n\n*plot  v(4)\n*hardcopy vout.ps v(4)\n\n\n*plot v(4)-12\n*hardcopy vout(ac+dc).ps v(4)-12\n\n\n*plot v(1)-v(3) v(2) v(4)\n*hardcopy vs_vout.ps v(1)-v(3) v(2) 12 v(4) \n*echo vs_vout_FIG\n\nmeas tran Output_average AVG v(4) \nmeas tran Max MAX v(4)\nmeas tran Min MIN v(4) \n\nlet ripple = Max - Min\n\nprint Output_average ripple\n\nprint 1/ (%f * ((maximum(v(4))-minimum(v(4))) + abs(mean(v(4)-12)) + 10e-6))\n\n\nquit\n.endc\n.end\n", A_secondary, R_env, C, R_reg, n_diodes,cost); 

                          fflush(filename);
                          fflush(filename);

                          fclose(filename);
                          [output, text] = system ("cd & ngspice ngspice_T3.cir");
                          text2 = substr(text, -29, -16);
                          if (merit < str2double(text2))
                            disp("Current settings:")
                                merit = str2double(text2)
                                Cf = C
                                Ref = R_env
                                Rrf = R_reg
                                ndf = n_diodes
                                Af = A_secondary
                                cost = R_env*1e-3 + R_reg*1e-3 + (4 + n_diodes)*0.1 + C*1e6
                          endif
                      endif
      endfor
    endfor
  endfor
  j = j + 1;
  format short
  disp("Round number:")
  disp(j)
  format long e
endfor
diary on
format long e
merit
format short e
Cf
format short
Ref
Rrf
ndf
format long
Af
format short
cost = Cf*1e+6 + Ref * 1e-3 + Rrf*1e-3 +0.4 + ndf*0.1
filename = 'ngspice_T3.cir';

file = fopen(filename, 'w');

fprintf(file, "* T3\n* forces current values to be saved\n.options savecurrents\nVin 3 1 DC 0 SIN(0 %f 50 0 0 90)\n\n*Envelop Detector\n\nD1 0 3 default\nD2 3 2 default\nD3 1 2 default\nD4 0 1 default\n\nR1 2 0 %d\n\nC 2 0 %d\n\n*Voltage Regulator\n\nR2 2 4 %d\nDr 4 0 Dmine\n.MODEL Default D\n.MODEL Dmine D (N=%d)\n\n\n\n\n\n* Transient simulation:\n.control\n\nset hcopypscolor=1\nset color0=white\nset color1=black\nset color2=red\nset color3=blue\nset color4=violet\nset color5=rgb:3/8/0\nset color6=rgb:4/0/0\n\nop\n\n\ntran 1e-5 0.2\n\n*plot  v(2)\n*hardcopy venv.ps v(2)\n\n\n*plot  v(4)\n*hardcopy vout.ps v(4)\n\n\n*plot v(4)-12\n*hardcopy vout(ac+dc).ps v(4)-12\n\n\n*plot v(1)-v(3) v(2) v(4)\n*hardcopy vs_vout.ps v(1)-v(3) v(2) 12 v(4) \n*echo vs_vout_FIG\n\nmeas tran Output_average AVG v(4) \nmeas tran Max MAX v(4)\nmeas tran Min MIN v(4) \n\nlet ripple = Max - Min\n\nprint Output_average ripple\n\nprint 1/ (%f * ((maximum(v(4))-minimum(v(4))) + abs(mean(v(4)-12)) + 10e-6))\n\n\nquit\n.endc\n.end\n", Af, Ref, Cf, Rrf, ndf,cost); 

fflush(filename);
fflush(filename);

fclose(filename);
[output, text] = system ("cd & ngspice ngspice_T3.cir");
text2 = substr(text, -29, -16);
diary off