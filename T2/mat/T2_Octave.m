close all
clear all
format short e

#--------------------  DADOS  ----------------------- 

values = dlmread('data.txt');  

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
C = values(11,3) 
Kb = values(12,3)*0.001
Kd = values(13,3)*1000


#--------------------  NOS  ----------------------- 

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
Vc = Nos_C(2)
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

#iR1 = (V6-V1) / R1
#iR2 = Ib
#iR3 = Vb / R3
#iR4 = (V2 - V7) / R4
#iR5 = (V4 - V7) / R5
#iR6 = Iccl
#iR7 = Ic

save("-ascii","../doc/nos.tex", "Vb", "Vc", "V1", "V2", "V3", "V5", "V6", "V7", "Ib", "Ic", "Id", "iR1", "iR2", "iR3", "iR4", "iR5", "iR6", "iR7");

filename = 'ngspice_basic_circuit.txt'
file = fopen(filename, 'w')
fprintf(file, "Vs V1 0 DC %.11e\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVc 0 V9 0V\nHVc V5 V8 VVc %.11e\nGIb V6 V3 V2 V5 %.11e\nVx V6 V8 DC 0\nC1 V6 V8 %.11e", Vs, R1, R2, R3, R4, R5, R6, R7, Kd, Kb,C) 
fflush(filename)
fclose(filename)
