clear all;
AP = [30,20];
P_AP = -20;
f = 6*10^9;
antena1 = [29.9875,20];
antena2 = [30.0125,20];
uzytkownik1 = [100,100];
uzytkownik2 = [140,0];
N = -130;
a1_u1 = sqrt((antena1(1)-uzytkownik1(1))^2+(antena1(2)-uzytkownik1(2))^2);
a2_u1 = sqrt((antena2(1)-uzytkownik1(1))^2+(antena2(2)-uzytkownik1(2))^2);
a1_u2 = sqrt((antena1(1)-uzytkownik2(1))^2+(antena1(2)-uzytkownik2(2))^2);
a2_u2 = sqrt((antena2(1)-uzytkownik2(1))^2+(antena2(2)-uzytkownik2(2))^2);
lampda = 3*10^8/f;
faza1 = (a1_u1-a2_u1)*2*pi/lampda;
faza2 = (a1_u2-a2_u2)*2*pi/lampda;
% 
% H_a1_u1 = lampda/(4*pi*a1_u1)*exp(-1i*2*pi*a1_u1/lampda)*exp(i*faza1);
% H_a2_u1 = lampda/(4*pi*a2_u1)*exp(-1i*2*pi*a2_u1/lampda);
% H_u1 = H_a2_u1+H_a1_u1;
% P_u1 = P_AP+20*log10(abs(H_u1));
% SNR_u1 = P_u1-N,
% 
% H_a1_u2 = lampda/(4*pi*a1_u2)*exp(-i*2*pi*a1_u2/lampda)*exp(i*faza2);
% H_a2_u2 = lampda/(4*pi*a2_u2)*exp(-i*2*pi*a2_u2/lampda);
% H_u2 = H_a2_u2+H_a1_u2;
% P_u2 = P_AP+20*log10(abs(H_u2));
% SNR_u2 = P_u2-N,
P_AP = -23;
%wyciszenie u1
H_a1_u1 = lampda/(4*pi*a1_u1)*exp(-1i*2*pi*a1_u1/lampda)*exp(i*(faza1-pi));
H_a2_u1 = lampda/(4*pi*a2_u1)*exp(-1i*2*pi*a2_u1/lampda);
H_u1 = H_a2_u1+H_a1_u1;
P_u1 = P_AP+20*log10(abs(H_u1));
SNR_u1 = P_u1-N,
%wyciszenie u2
H_a1_u2 = lampda/(4*pi*a1_u2)*exp(-i*2*pi*a1_u2/lampda)*exp(i*(faza2-pi));
H_a2_u2 = lampda/(4*pi*a2_u2)*exp(-i*2*pi*a2_u2/lampda);
H_u2 = H_a2_u2+H_a1_u2;
P_u2 = P_AP+20*log10(abs(H_u2));
SNR_u2 = P_u2-N,

H_a1_u1 = lampda/(4*pi*a1_u1)*exp(-1i*2*pi*a1_u1/lampda)*exp(i*(faza2-pi));
H_a2_u1 = lampda/(4*pi*a2_u1)*exp(-1i*2*pi*a2_u1/lampda);
H_u1 = H_a2_u1+H_a1_u1;
P_u1 = P_AP+20*log10(abs(H_u1));
SNR_u1 = P_u1-N,

H_a1_u2 = lampda/(4*pi*a1_u2)*exp(-i*2*pi*a1_u2/lampda)*exp(i*(faza1-pi));
H_a2_u2 = lampda/(4*pi*a2_u2)*exp(-i*2*pi*a2_u2/lampda);
H_u2 = H_a2_u2+H_a1_u2;
P_u2 = P_AP+20*log10(abs(H_u2));
SNR_u2 = P_u2-N,