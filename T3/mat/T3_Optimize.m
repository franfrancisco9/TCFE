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
n = 17;
A = Vin_A/n;

Merit_final = 0;
Cost_final = 0;
Average_Final = 0;
Ripple_Final = 0;
R1_Final = 0;
R2_Final = 0;
C_Final = 0;
C = 8e-6;
while (C <= 12e-6)
  R1 = 8000;
  while  (R1 <= 12000)
    R2 = 600;
    while  (R2 <= 1300 )
      
      t=linspace(0, 0.2, 1000);

          vS=A*cos(w*t);

          vOhr = zeros(1, length(t));
          vO = zeros(1, length(t));

          tOFF = 1/w * atan(1/w/R1/C);

          vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/R1/C);

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
              vOnexp = A*abs(cos(w*tOFF))*exp(-(t-tOFF)/R1/C);
              vO(i) = vOhr(i);
            endif
          endfor

          average = mean(vO);
          ripple = max(vO) - min(vO);




          #-------------------------Voltage Regulator----------------------------------

          diodes = 19;
          Von = 0.7;

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
          vt = 0.026;
          Is = 1e-14;
          new = 1;

          Rd = new*vt/(Is*exp(Von/(new*vt)));

          % ac regulator
          for i = 1:length(t)
            if vO(i) >= diodes*Von
              vO_2_ac(i) = diodes*Rd/(diodes*Rd+R2) * (vO(i)-average);
            else
              vO_2_ac(i) = vO(i)-average;
            endif
          endfor

          vO_2 = vO_2_dc + vO_2_ac;

          average_reg = mean(vO_2);
          ripple_reg = max(vO_2)-min(vO_2) ;

          cost = R1/1000 + R2/1000 + C*1e6 + diodes*0.1 + 0.4; %o 0.1 e do diodo do envelope detector 

          MERIT = 1/(cost*(ripple_reg + abs(average_reg - 12) + 1e-6));
          if Merit_final < MERIT
            Merit_final = MERIT;
            Cost_final = cost;
            Average_Final = average_reg;
            Ripple_Final = ripple_reg;
            R1_Final = R1;
            R2_Final = R2;
            C_Final = C;
            
          endif    
          
         R2 = R2 +10;
    end
         R1 = R1 + 500;
  end
          C = C + 0.5e-6
end

disp("Merit")
disp(Merit_final)
disp("Cost:")
disp(Cost_final)
disp("Average:")
disp(Average_Final)
disp("Ripple:")
disp(Ripple_Final)
disp("R1:")
disp(R1_Final)
disp("R2:")
disp(R2_Final)
disp("C:")
disp(C_Final)

#------------------------Transformador-----------------------------------



#------------------------Envelope Detector---------------------------------


#--------------------  Guardar para Tabelas -----------------------



#--------------------  Imprimir em ficheiros -----------------------
        


