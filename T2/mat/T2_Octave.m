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

#--------------------  Alínea 2  ----------------------- 

Vx = V6 - V8

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
        
Nos_B_2 = [0;0;0;Vx;0;0;0;0;0;0;0]

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
        
filename = 'ngspice_circuit_1.txt'
file = fopen(filename, 'w')
fprintf(file, "Vs V1 0 DC %.11e\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVc 0 V9 0V\nHVc V5 V8 VVc %.11e\nGIb V6 V3 V2 V5 %.11e", Vs, R1, R2, R3, R4, R5, R6, R7, Kd, Kb) 
fflush(filename)
fclose(filename)
filename = 'ngspice_circuit_2.txt'
file = fopen(filename, 'w')
fprintf(file, "Vs V1 0 DC 0\nR1 V2 V1 %.11e\nR2 V3 V2 %.11e\nR3 V2 V5 %.11e\nR4 0 V5 %.11e\nR5 V6 V5 %.11e\nR6 V9 V7 %.11e\nR7 V7 V8 %.11e\nVVc 0 V9 0V\nHVc V5 V8 VVc %.11e\nGIb V6 V3 V2 V5 %.11e\nVx V6 V8 DC %.11e", R1, R2, R3, R4, R5, R6, R7, Kd, Kb,Vx) 
fflush(filename)
fclose(filename)
