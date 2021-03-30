close all
clear all
format short e

#--------------------  DADOS  ----------------------- 

R1 = 1.01949191994e+03
G1 = 1/R1
R2 = 2.05054429461e+03
G2 = 1/R2
R3 = 3.09286027724e+03 
G3 = 1/R3
R4 = 4.12838973576e+03 
G4 = 1/R4
R5 = 3.06635427647e+03 
G5 = 1/R5
R6 = 2.01254230153e+03 
G6 = 1/R6
R7 = 1.00502981701e+03 
G7 = 1/R7
Va = 5.24204797361
Id = 1.01905568201e-03 
Kb = 7.23185131759e-03 
Kc = 8.12820254987e+03 


#--------------------  NOS  ----------------------- 

Nos_A = [Kb 0 0 0 0 0 0 0 0 -1 0; 0 -1 0 0 0 0 0 0 0 0 Kc; 0 -1 0 0 0 0 0 0 1 0 0; 0 0 1 -1 0 0 0 0 0 0 0; 0 0 0 0 G7 0 0 0 0 0 -1; 1 0 0 0 0 0 0 -1 1 0 0; 0 0 0 G6 -G6-G7 0 0 0 0 0 0; Kb 0 0 0 0 G5 0 0 -G5 0 0; Kb 0 0 0 0 0 -G2 G2 0 0 0; Kb 0 G1 0 0 0 0 -G1-G3 G3 0 0; 0 0 G1 G4 G7 0 0 -G1 -G4 0 0]

Nos_B = [0;0;0;Va;0;0;0;Id;0;0;0]

Nos_C =  Nos_A\Nos_B

Vbn = Nos_C(1)
Vcn = Nos_C(2)
V1n = Nos_C(3)
V2n = Nos_C(4)
V3n = Nos_C(5)
V4n = Nos_C(6)
V5n = Nos_C(7)
V6n = Nos_C(8)
V7n = Nos_C(9)
Ibn = Nos_C(10)
Icn = Nos_C(11)
iR1n = (V6n-V1n) / R1
iR2n = Ibn
iR3n = Vbn / R3
iR4n = (V2n - V7n) / R4
iR5n = (V4n - V7n) / R5
iR6n = Icn
iR7n = Icn


#--------------------  MALHAS  ----------------------- 

Malhas_A = [-Kb*R3 1-Kb*R3 0; R1+R3+R4 R3 R4; R4 0 R6+R7-Kc+R4]

Malhas_B = [0;Va;0]

Malhas_C =  Malhas_A\Malhas_B

Iam = Malhas_C(1)
Ibm = Malhas_C(2)
Icm = Malhas_C(3)
Vcm = Kc * Icm
Vbm = Ibm / Kb
V7m = Vcm
V6m = V7m + Vbm
V5m = V6m + R2 * Ibm
V4m = V7m + R5 * (Id - Ibm)
V3m = R7 * Icm
V2m = V3m + R6 * Icm
V1m = V2m + Va
iR1m = Iam
iR2m = Ibm
iR3m = Iam + Ibm
iR4m = Iam + Icm
iR5m = Id - Ibm
iR6m = Icm
iR7m = Icm

save("-ascii","../doc/nos.tex", "Vbn", "Vcn", "V1n", "V2n", "V3n", "V4n", "V5n", "V6n", "V7n", "Ibn", "Icn", "iR1n", "iR2n", "iR3n", "iR4n", "iR5n", "iR6n", "iR7n");
save("-ascii","../doc/malhas.tex", "Vbm", "Vcm", "V1m", "V2m", "V3m", "V4m", "V5m", "V6m", "V7m", "Ibm", "Icm","iR1m", "iR2m", "iR3m", "iR4m", "iR5m", "iR6m", "iR7m");



