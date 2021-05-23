pkg load symbolic;

%gain stage

Vcc =  12
Vinm =  1
Vinf =  1000
Rin =  100
Ci =  0.0010000
R1 =  122000
R2 =  20000
Rc =  550
Re =  100
Cb =  0.0042000
Rout =  100
Co =  0.0018000
RL =  8

VT=25e-3
BFN=178.7
VAFN=69.7
RE1=Re
RC1=Rc
RB1=R1
RB2=R2
VBEON=0.7
VCC = Vcc
RS=Rin
Vin = Vinm


RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1


gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

RSB=RB*RS/(RB+RS)

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=0
AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple =  - RSB/RS * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=Re
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZX = ro1*((RSB+rpi1)*RE1/(RSB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RSB)+1/RE1+gm1*rpi1/(rpi1+RSB)))
ZX = ro1*(1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB))/(1/RE1+1/(rpi1+RSB) ) 
ZO1 = 1/(1/ZX+1/RC1)

RE1=0
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZO1 = 1/(1/ro1+1/RC1)

%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = Rout
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)


%total
gB = 1/(1/gpi2+ZO1)
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1
AV_DB = 20*log10(abs(AV))
ZI=ZI1
ZO=1/(go2+gm2/gpi2*gB+ge2+gB)

Gain = abs(AV)
Gain1 = abs(AV1)
Gain2 = abs(AV2)

%gain stage

frequency = logspace(1, 8, 70);
gain = zeros(1,70);

for aux = 1:1:70
  f = frequency(aux);
  w = 2*pi*f

  Vin = Vinm*e^(i*w);

  VT=25e-3; 
  BFN=178.7;
  VAFN=69.7; 
  RE1=Re;
  RC1=Rc;
  RB1=R1;
  RB2=R2;
  VBEON=0.7;
  VCC = Vcc; 

  RS = Rin;
  Zci = 1/(Ci*w*i); 
  Zcb = 1/(Cb*w*i); 
  Zco = 1/(Co*w*i); 


  RB=1/(1/RB1+1/RB2); 
  VEQ=RB2/(RB1+RB2)*VCC;
  IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1); 
  IC1=BFN*IB1; 
  IE1=(1+BFN)*IB1;
  VE1=RE1*IE1;
  VO1=VCC-RC1*IC1;
  VCE=VO1-VE1;


  gm1=IC1/VT; 
  rpi1=BFN/gm1; 
  ro1=VAFN/IC1;

  RSB=RB*RS/(RB+RS);

  %ouput stage
  BFP = 227.3;
  VAFP = 37.2; 
  RE2 = Rout; 
  VEBON = 0.7;
  VI2 = VO1; 
  IE2 = (VCC-VEBON-VI2)/RE2;
  IC2 = BFP/(BFP+1)*IE2; 
  VO2 = VCC - RE2*IE2;

  gm2 = IC2/VT; 
  ro2 = VAFP/IC2; 
  rpi2 = BFP/gm2;  

  aux2 = -gm2-1/rpi2;

  A =[1,0,0,0,0,0,0;
  -1/Rin, 1/Rin+1/Zci, -1/Zci, 0,0,0,0;
  0, -1/Zci, 1/Zci+1/RB+1/rpi1, -1/rpi1,0,0,0;
  0,0,-gm1-1/rpi1, gm1+1/rpi1 + 1/RE1 + 1/Zcb + 1/ro1, -1/ro1, 0,0;
  0,0, gm1, -gm1-1/ro1, 1/ro1 + 1/RC1 + 1/rpi2, -1/rpi2, 0;
  0,0,0,0,0, -1/Zco, 1/Zco + 1/RL;
  0,0,0,0, aux2, gm2 + 1/rpi2 + 1/RE2 + 1/Zco + 1/ro2, -1/Zco;
  ];
  B=[Vin; 0; 0; 0; 0; 0; 0];
  X = A\B;

  gain(aux) = abs(X(7)/X(1));
  vout_vec(aux) = abs(X(7));
endfor

hf = figure (1);
semilogx(frequency, gain,";gain(f);");
xlabel ("f [Hz]");
ylabel ("gain");
print (hf, "frequency.pdf", "-dpdf");



