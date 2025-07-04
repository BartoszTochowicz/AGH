clear all;
close all;

clear all;
Fs= 1e6; % częstotliwość próbkowania w Hz
fftSize=1024;%rozmiar prefiksu wyrażony w próbkach
%TODO 1: Sporządź wykres wyrażonej w Mbit/s szybkości transmisji sygnału OFDM w funkcji długości prefiksu cyklicznego.
%		 Przyjmij, ze częstotliwość próbkowania w nadajniku oraz rozmiar fft pozostaje bez zmian.
%		 Długość prefiksu cyklicznego zmienia się od 1 do 64 próbek 
L_cp = 1:64; 
M = 16; 

T_u = fftSize / Fs; 
T_cp = L_cp / Fs; 
T_ofdm = T_u + T_cp; 
R = (fftSize ./ T_ofdm) * log2(M) / 1e6; 

% Wykres
figure;
plot(L_cp, R,'o', 'LineWidth', 2);
grid on;
