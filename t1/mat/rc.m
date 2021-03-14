close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

syms t
syms R
syms C
syms vi(t)
syms vo(t)
syms i(t)

i(t)=C*diff(vo,t)

printf("\n\nKVL equation:\n");

vi(t) = R*i(t)+vo(t)

syms vo_n(t) %natural solution
syms vo_f(t) %forced solution

printf("\n\nSolution is of the form");

v(t) = vo_n(t) + vo_f(t)

printf("\n\nNatural solution:\n");
syms A
syms wn

vi(t) = 0 %no excitation
i_n(t) = C*diff(vo_n, t)


printf("\n\n Natural solution is of the form");
vo_n(t) = A*exp(wn*t)

R*i_n(t)+vo_n(t) == 0

R*C*wn*vo_n(t)+vo_n(t) == 0

R*C*wn+1==0

solve(ans, wn)


%%EXAMPLE NUMERIC COMPUTATIONS

R=1e3 %Ohm
C=100e-9 %F

f = 1000 %Hz
w = 2*pi*f; %rad/s

%time axis: 0 to 10ms with 1us steps
t=0:1e-6:10e-3; %s

Zc = 1/(j*w*C)
Cgain = Zc/(R+Zc)
Gain = abs(Cgain)
Phase = angle(Cgain)

vi = 1*cos(w*t);
vo = Gain*cos(w*t+Phase);

hf = figure ();
plot (t*1000, vi, "g");
hold on;
plot (t*1000, vo, "b");

xlabel ("t[ms]");
ylabel ("vi(t), vo(t) [V]");
print (hf, "forced.eps", "-depsc");
%print forced.eps
