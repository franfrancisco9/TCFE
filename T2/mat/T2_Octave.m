close all
clear all
format short e
pkg load symbolic
pkg load control
pkg load signal
#--------------------  DADOS  ----------------------- 

values = dlmread('data.txt');  

f = 1000

R1 = values(3,3)*1000
R2 = values(4,3)*1000
R3 = values(5,3)*1000
R4 = values(6,3)*1000
R5 = values(7,3)*1000
R6 = values(8,3)*1000
R7 = values(9,3)*1000

G1 = 1/R1
G2 = 1/R2
G3 = 1/R3
G4 = 1/R4 
G5 = 1/R5 
G6 = 1/R6
G7 = 1/R7

Vs= values(10,3)
C = values(11,3)*0.000001 
Kb = values(12,3)*0.001
Kd = values(13,3)*1000


#--------------------  Alínea 1  ----------------------- 

Nos_A = [0 0 1 0 0 0 0 0 0 0 0 0;
        -1 0 0 1 0 -1 0 0 0 0 0 0; 
        Kb 0 0 0 0 0 0 0 0 -1 0 0;
        0 -1 0 0 0 0 0 0 0 0 0 Kd;
        0 -1 0 0 0 1 0 0 -1 0 0 0;
        0 0 0 0 0 0 0 -G6 0 0 0 -1;
        0 0 0 0 0 0 0 0 0 0 1 0;
        0 0 -G1 G1+G2+G3 -G2 -G3 0 0 0 0 0 0;
        0 0 0 -G2-Kb G2 Kb 0 0 0 0 0 0;
        0 0 0 Kb 0 -Kb-G5 G5 0 0 0 0 0;
        0 0 0 0 0 0 0 G7+G6 -G7 0 0 0 ; 
        0 0 G1 -G1 0 -G4 0 0 0 0 0 1]

Nos_B = [Vs;0;0;0;0;0;0;0;0;0;0;0]

Nos_C =  Nos_A\Nos_B

Vb = Nos_C(1)
Vd = Nos_C(2)
V1 = Nos_C(3)
V2 = Nos_C(4)
V3 = Nos_C(5)
V5 = Nos_C(6)
V6 = Nos_C(7)
V7 = Nos_C(8)
V8 = Nos_C(9)
Ib = Nos_C(10)
Ic = Nos_C(11)
Id = Nos_C(12)


IR1 = (V1 - V2)*G1
IR2 = (V2 - V3)*G2
IR3 = (V5 - V2)*G3
IR4 = V5*G4
IR5 = (V6 - V5)*G5
IR6 = -V7*G6
IR7 = (V7 - V8)*G7



#--------------------  Alínea 2  ----------------------- 

Vx_2 = V6 - V8

Nos_A_2 = [-G1 G1+G2+G3 -G2 -G3 0 0 0 0 0 0 0 ;
        0 -G2 G2 0 0 0 0 -1 0 0 0 ; 
        0 0 0 0 0 G7 -G7 0 -1 0 0 ;
        0 0 0 0 1 0 -1 0 0 0 0 ;
        0 -1 0 1 0 0 0 0 0 1 0 ;
        0 0 0 -1 0 0 1 0 0 0 1 ;
        0 0 0 0 0 0 0 1 0 -Kb 0;
        0 0 0 0 0 0 0 0 -Kd 0 1;
        G1+G4 -G1 0 -G4 0 0 0 0 1 0 0;
        1 0 0 0 0 0 0 0 0 0 0 ;
        -G6 0 0 0 0 G6 0 0 1 0 0]
        
Nos_B_2 = [0;0;0;Vx_2;0;0;0;0;0;0;0]

Nos_C_2 =  Nos_A_2\Nos_B_2

V1_2 = Nos_C_2(1)
V2_2 = Nos_C_2(2)
V3_2 = Nos_C_2(3)
V5_2 = Nos_C_2(4)
V6_2 = Nos_C_2(5)
V7_2 = Nos_C_2(6)
V8_2 = Nos_C_2(7)
Ib_2 = Nos_C_2(8)
Id_2 = Nos_C_2(9)
Vb_2 = Nos_C_2(10)
Vd_2 = Nos_C_2(11)

IR1_2 = (V1_2 - V2_2)*G1
IR2_2 = (V2_2 - V3_2)*G2
IR3_2 = (V5_2 - V2_2)*G3
IR4_2 = V5_2*G4
IR5_2 = (V6_2 - V5_2)*G5
IR6_2 = -V7_2*G6
IR7_2 = (V7_2 - V8_2)*G7

Vx = V6_2 - V8_2
Ix = Ib_2 + (V6_2 - V5_2)*G5
Req = Vx/Ix
tau = Req * C

#--------------------  Alínea 3  -----------------------
syms t
syms v6(t)
t=0:1e-6:20e-3;
v6 = (V8_2 + Vx_2) * exp(-(t/tau));

hf = figure ();
plot(t*1000, v6);
xlabel ("t[ms]");
ylabel ("V_{6n}(t) [V]");
legend("v6");
#title ("Natural Response of v_{6n}(t) in the interval [0,20]ms using Vx(t<0) as the initial condition");
print (hf, "theoretical_3.eps", "-color");


#--------------------  Alínea 4  -----------------------
Yc = (C*2*pi*f)*i
Zc = 1/Yc


Nos_A_4 = [-G1 G1+G2+G3 -G2 -G3 0 0 0 0 0 0 0 ;
        0 -G2-Kb G2 Kb 0 0 0 0 0 0 0 ; 
        0 Kb 0 -Kb-G5 G5+Yc 0 -Yc 0 0 0 0 ;
        0 0 0 0 0 G6+G7 -G7 0 0 0 0 ;
        1 0 0 0 0 0 0 0 0 0 0 ;
        0 0 0 1 0 Kd*G6 -1 0 0 0 0 ;
        G1 -G1 0 -G4 0 -G6 0 0 0 0 0]

Nos_B_4 = [0;0;0;0;1;0;0]
Nos_C_4 =  Nos_A_4\Nos_B_4

V1_4 = (Nos_C_4(1))
V2_4 = (Nos_C_4(2))
V3_4 = (Nos_C_4(3))
V5_4 = (Nos_C_4(4))
V6_4 = (Nos_C_4(5))
V7_4 = (Nos_C_4(6))
V8_4 = (Nos_C_4(7))

RV1 = real(V1_4)
IV1 = imag(V1_4)
RV2 = real(V2_4)
IV2 = imag(V2_4)
RV3 = real(V3_4)
IV3 = imag(V3_4)
RV5 = real(V5_4)
IV5 = imag(V5_4)
RV6 = real(V6_4)
IV6 = imag(V6_4)
RV7 = real(V7_4)
IV7 = imag(V7_4)
RV8 = real(V8_4)
IV8 = imag(V8_4)
AmpV1 = sqrt(RV1*RV1 + IV1*IV1)
AmpV2 = sqrt(RV2*RV2 + IV2*IV2)
AmpV3 = sqrt(RV3*RV3 + IV3*IV3)
AmpV5 = sqrt(RV5*RV5 + IV5*IV5)
AmpV6 = sqrt(RV6*RV6 + IV6*IV6)
AmpV7 = sqrt(RV7*RV7 + IV7*IV7)
AmpV8 = sqrt(RV8*RV8 + IV8*IV8)
PhaseV1 = atan(IV1/RV1)
PhaseV2 = atan(IV2/RV2)
PhaseV3 = atan(IV3/RV3)
PhaseV5 = atan(IV5/RV5)
PhaseV6 = atan(IV6/RV6)
PhaseV7 = atan(IV7/RV7)
PhaseV8 = atan(IV8/RV8)


t=0:1e-6:20e-3;
V6_forced = V6_4*sin(2*pi*f*t);
Vs_all = sin(2*pi*f*t); 

hf1 = figure();
plot(t*1000, V6_forced, t*1000, Vs_all);
axis ([0, 20, -2, 2]);
xlabel ("t[ms]");
ylabel ("v_{6f}(t) [V]");
#title ("Forced Response of v_{6f}(t) in the interval [0,20]ms");
print (hf1, "theoretical_4.eps", "-color");
close(hf1);

#--------------------  Alínea 5  -----------------------
t=-5e-3:1e-6:20e-3;
V6_all(t>=0)= V6_4*sin(2*pi*f*t(t>=0)) + Vx*exp(-t(t>=0)/tau);
V6_all(t<0) = V6;
Vs_all(t>=0) = sin(2*pi*f*t(t>=0));
Vs_all(t<0) = Vs;
 
hf2 = figure();
plot(t, V6_all, t, Vs_all);
xlabel ("t[ms]");
ylabel ("v_6(t) [V] and v_s(t) [V]");
legend("v6","vs");
#title ("Final solution of v_6(t) and v_s(t) in the interval [-5,20]ms");
print (hf2, "theoretical_5.eps", "-color");
close(hf2);

#--------------------  Alínea 6  -----------------------

#Plot do Vc(w)
#Temos de por f a ir de 0.1 a 10⁶ e tirar rad/s do título do angulo, mas dá bem
#s = tf('s');                                      
#G = 1/(C*Req*s/(2*pi)+1);                               
#bode(G)


#Não consegui seguir os passos do Francisco Branco e pôr isto a funcionar por causa de uma coisa deste género:
#syms t
#syms v6(t)
#t=0:1e-6:20e-3;
#v6 = (V8_2 + Vx_2) * exp(-(t/tau)); #-> Esta puta de expressão não dá erro
#v6 = 1/(1+i*2*pi*t*C*Req) -> Mas esta pua de expressão já dá erro
#hf = figure ();
#plot(t*1000, v6);
#xlabel ("t[ms]");
#ylabel ("V_{6n}(t) [V]");
#title ("Natural Response of v_{6n}(t) in the interval [0,20]ms using Vx(t<0) as the initial condition");
#print (hf, "theoretical_3.eps", "-color");


#Plot do V6(w): Ideias
#v6 = V8_4 + 1/(C*Req*2*pi*f*i+1); ;

#IDEIAS
#Usar a ideia do exercício 3, mas com o f em logscale

#r = sqrt(square(RV6)+square(IV6))
#teta = atan(IV6/RV6)
#V6_bode1 = r*exp(i*2*pi*f+teta)  
#V6_bode2 = G + V8_4

#f = logspace(-1, 6, 200);
#[mag, phase] = bode(G ,2*pi*f) ;
#subplot(2,1,1);
#semilogx(f, 20*log10(abs(mag)));
#subplot(2,1,2);
#semilogx(f, phase);

#syms f
#r = sqrt(RV6*RV6+IV6*IV6)
#teta = atan(IV6/RV6)
#f = logspace(-1, 6, 200);
#for aux=1:200
#  v6(aux)=r*exp(2*pi*f(aux)*i + teta)
#endfor
#plot(v6)

#bode(V8_bode)
#bode(G+V8_bode)
#bode



#G = V6_6/Vs_6

#magnitude
#syms f
#f = logspace(-1, 6, 200);
#Vc = 1./(1+i.*2.*pi.*Req.*f.*C)
#Vc_abs = abs(Vc)
#Vc_phase = atan(imag(Vc)/real(Vc))
#subplot(2,1,1);
#semilogx(f, 20*log10(Vc_abs));
#subplot(2,1,2);
#semilogx(f, Vc_phase);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nPasso 6:\n");
phi_vs = pi/2
vsp= 1*power(e,-j*phi_vs)
f =-1:0.1:6; %Hz
w = 2*pi*power(10,f);

vsp= 1*power(e,-j*phi_vs);
Zc=1. ./ (j .* w .* C);

N = [Kb+1./R2, -1./R2, -Kb, 0;
     1./R3-Kb,  0, Kb-1./R3-1./R4, -1./R6;
     Kb-1./R1-1./R3, 0, 1./R3-Kb, 0;
     0, 0, 1., Kd/R6-R7/R6-1.];
b = [0; 0; -vsp/R1; 0];

V=linsolve(N,b); % v2, v3, v5, v7
 
v8 = R7*(1./R1+1./R6)*V(4) + 0*Zc;
v6 = ((1./R5+Kb)*V(3)-Kb*V(1)+ (v8 ./ Zc)) ./ (1./R5 + 1. ./ Zc);
vc = v6 - v8;
vs = power(e,j*pi/2) + 0*w;

#{
Tvc= 1 ./ (1 + j*w*Req*C);
Tv6= Tvc;

vs = power(e,j*pi/2) + 0*w;
vc = Tvc .* vs;
v6 = vc + v8p;
#}

hf = figure ();
plot (f, 20*log10(abs(vc)), "m");
hold on;
plot (f, 20*log10(abs(v6)), "b");
hold on;
plot (f, 20*log10(abs(vs)), "r");

legend("vc","v6","vs");
xlabel ("log_{10}(f) [Hz]");
ylabel ("v^~_c(f), v^~_6(f), v^~_s(f) [dB]");
print (hf, "theoretical_6_dB.eps", "-depsc");
disp("\nfigure saved");

av6 = 180/pi*(angle(v6));
for  i=1:length(av6)
	if(av6(i)<=-90) 
		av6(i) += 180;
	elseif (av6(i)>=90) 
		av6(i) -= 180;
endif
endfor

hf = figure ();
plot (f, 180/pi*(angle(vc) + pi), "m");
hold on;
plot (f, av6, "b");
hold on;
plot (f, 180/pi*angle(vs), "r");

legend("vc","v6","vs");
xlabel ("log_{10}(f) [Hz]");
ylabel ("Phase v_c(f), v_6(f), v_s(f) [degrees]");
print (hf, "theoretical_6_phase.eps", "-depsc");
disp("\nfigure saved");


#--------------------  Guardar para Tabelas -----------------------

save("-ascii","../doc/theoretical_1.tex", "Vb", "Vd", "V1", "V2", "V3", "V5", "V6", "V7", "V8", "Ib", "Ic", "Id", "IR1", "IR2", "IR3", "IR4", "IR5", "IR6", "IR7");
save("-ascii","../doc/theoretical_2.tex", "Vx", "Ix", "Req", "tau", "Vb_2", "Vd_2", "V1_2", "V2_2", "V3_2", "V5_2", "V6_2", "V7_2", "V8_2", "Ib_2", "Id_2", "IR1_2", "IR2_2", "IR3_2", "IR4_2", "IR5_2", "IR6_2", "IR7_2");
save("-ascii","../doc/theoretical_4.tex", "AmpV1", "AmpV2", "AmpV3", "AmpV5", "AmpV6", "AmpV7", "AmpV8", "PhaseV1", "PhaseV2", "PhaseV3", "PhaseV5", "PhaseV6", "PhaseV7", "PhaseV8");



#--------------------  Imprimir em ficheiros -----------------------
        
filename = 'ngspice_circuit_1.txt'
file = fopen(filename, 'w');
fprintf(file, "Vs V1 0 DC %.11e\nR1 V1 V2 %.11e\nR2 V2 V3 %.11e\nR3 V5 V2 %.11e\nR4 V5 0 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVd 0 V9 0V\nHVd V5 V8 VVd %.11e\nGIb V6 V3 V2 V5 %.11e\nC1 V6 V8 %.11e", Vs, R1, R2, R3, R4, R5, R6, R7, Kd, Kb, C); 
fflush(filename);
fclose(filename);

filename = 'ngspice_circuit_2.txt'
file = fopen(filename, 'w');
fprintf(file, "Vs V1 0 DC 0\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVd 0 V9 0V\nHVd V5 V8 VVd %.11e\nGIb V6 V3 V2 V5 %.11e\nVx V6 V8 DC %.11e", R1, R2, R3, R4, R5, R6, R7, Kd, Kb,Vx); 
fflush(filename);
fclose(filename);

filename = 'ngspice_circuit_3.txt'
file = fopen(filename, 'w');
fprintf(file, "Vs V1 0 DC 0\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVd 0 V9 0V\nHVd V5 V8 VVd %.11e\nGIb V6 V3 V2 V5 %.11e\nC1 V6 V8 %.11e ic = %.11e\n.ic v(V6) = %.11e v(V8) = 0", R1, R2, R3, R4, R5, R6, R7, Kd, Kb,C,Vx, Vx); 
fflush(filename);
fclose(filename);

filename = 'ngspice_circuit_4.txt'
file = fopen(filename, 'w');
fprintf(file, "Vs V1 0 0.0 ac 1.0 sin(0 1 1k)\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVd 0 V9 0V\nHVd V5 V8 VVd %.11e\nGIb V6 V3 V2 V5 %.11e\nC1 V6 V8 %.11e ic = %.11e\n.ic v(V6) = %.11e v(V8) = 0", R1, R2, R3, R4, R5, R6, R7, Kd, Kb,C,Vx, Vx); 
fflush(filename);
fclose(filename);

filename = 'ngspice_circuit_5.txt'
file = fopen(filename, 'w');
fprintf(file, "Vs V1 0 0.0 ac 1.0 sin(0 1 1k)\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVd 0 V9 0V\nHVd V5 V8 VVd %.11e\nGIb V6 V3 V2 V5 %.11e\nC1 V6 V8 %.11e ic = %.11e\n.ic v(V6) = %.11e v(V8) = 0", R1, R2, R3, R4, R5, R6, R7, Kd, Kb,C,Vx, Vx); 
fflush(filename);
fclose(filename);
