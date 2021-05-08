close all
clear all
format short e
pkg load symbolic
pkg load control
pkg load signal
#--------------------  DADOS  -----------------------          

Vin_A = 230;
f=50;
w=2*pi*f;

R1 = 26000;
C =  3.3750e-05;

R2 = 10000;

#------------------------Transformador-----------------------------------

n = 1.352941176;
A = 14.64891221288435;

#------------------------Envelope Detector---------------------------------
t=linspace(0, 0.2, 1000);

vS=A*cos(w*t);

vOhr = zeros(1, length(t));
vO = zeros(1, length(t));

tOFF = 1/w * atan(1/w/R1/C);

vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/(R1*C));



for i=1:length(t)
	  vOhr(i) = abs(vS(i));
	endfor

for i=1:length(t)
  if t(i) < tOFF
    vO(i) = vOhr(i);
  elseif vOnexp(i) > vOhr(i)
    vO(i) = vOnexp(i);
  else 
    tOFF = tOFF + 1/(2*f) ;
    vOnexp = A*abs(cos(w*tOFF))*exp(-(t-tOFF)/(R1*C));
    vO(i) = vOhr(i);
  endif
endfor

average = mean(vO)
ripple = max(vO) - min(vO)




#-------------------------Voltage Regulator----------------------------------

diodes = 20;
Von = 0.6;

vO_2 = zeros(1, length(t));
vO_2_dc = 0;
vO_2_ac = zeros(1, length(t));

%dc component regulator ----------------
if average >= Von*diodes
  vO_2_dc = Von*diodes;
else
  vO_2_dc = average;
endif

%ac component regulator -----------------
vt = 0.025;
Is = 1e-14;
new = 2;

Rd = new*vt/(Is*exp(Von/(new*vt)))

% ac regulator
for i = 1:length(t)
  if vO(i) >= diodes*Von
    vO_2_ac(i) = diodes*Rd/(diodes*Rd+R2) * (vO(i)-average);
  else
    vO_2_ac(i) = vO(i)-average;
  endif
endfor

vO_2 = vO_2_dc + vO_2_ac;


%plots ----------------------------------------------

%output voltages at rectifier, envelope detector and regulator
hfc = figure(1);
title("Envelope output voltage v_o(t)")
plot (t*1000,vO, ";vo_{envelope}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "env_vout.pdf", "-dpdf");
saveas (hfc, "env_vout.eps");

%output voltages at rectifier, envelope detector and regulator
hfc = figure(2);
title("Regulator output voltage v_o(t)")
plot (t*1000,vO_2, ";vo_{regulator}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "t_vout.pdf", "-dpdf");
saveas (hfc, "t_vout.eps");

%output voltages at rectifier, envelope detector and regulator
hfc = figure(3);
title("Regulator and envelope output voltage v_o(t)")
x = 12;
plot (t*1000, vS, ";vs_{transformer}(t);", t*1000,vO, ";vo_{envelope}(t);", t*1000,vO_2, ";vo_{regulator}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "all_vout.pdf", "-dpdf");
saveas (hfc, "all_vout.eps");

%Deviations (vO - 12) 
hfc = figure(4);
title("Deviations from desired DC voltage")
plot (t*1000,vO_2-12, ";vo-12 (t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "deviation.pdf", "-dpdf");
saveas (2, "deviation.eps");

average_reg = mean(vO_2)
ripple_reg = max(vO_2)-min(vO_2) 

cost = R1/1000 + R2/1000 + C*1e6 + diodes*0.1 + 0.4 %o 0.1 e do diodo do envelope detector 

MERIT = 1/(cost*(ripple_reg + abs(average_reg - 12) + 1e-6))

#--------------------  Guardar para Tabelas -----------------------



#--------------------  Imprimir em ficheiros -----------------------
        


