% przyklad 15.1: Demonstracja kodowania podpasmowego

clc; clear; close all
[x,Fs] = audioread('DontWorryBeHappy.wav');% Wczytanie sygnalu z pliku wav
info = audioinfo("DontWorryBeHappy.wav");
x = x(1:300000,1);
soundsc(x,Fs)                           % odsluchanie
figure
specgram(x,2048,Fs,2000)                % demonstracja spektrogramu
title('Sygnal oryginalny')

% % Zakodowanie koderem podpasmowym z uzyciem 8 podpasm i 6 bitow na probke
% % UWAGA: przed skwantowaniem kazde pasmo jest normalizowane do zakresu -1..1
% [y2,bps1] = kodowanie_podpasmowe(x,8,6);
% soundsc(y2,Fs)
% figure(2)
% specgram(y2,2048,Fs,2000)
% title(sprintf('Liczba bitow na probke: %1.2f\n',bps1))
% 
% % Zakodowanie koderem podpasmowym z uzyciem 32 podpasm i 8 bitow na probke
% [y3,bps2] = kodowanie_podpasmowe(x,32,6);
% soundsc(y3,Fs)
% figure(3)
% specgram(y3,2048,Fs,2000)
% title(sprintf('Liczba bitow na probke: %1.2f\n',bps2))

% Zakodowanie koderem podpasmowym z uzyciem 16 podpasm i zmiennej liczby bitow na probke
[y4,bps3] = kodowanie_podpasmowe(x,32,[8,8,7,6,4]);
soundsc(y4,Fs)
figure(4)
specgram(y4,2048,Fs,2000)
title(sprintf('Liczba bitow na probke: %1.2f\n',bps3))
original_bps = info.BitsPerSample;  % Zakładając 16-bitowe próbki w oryginale
% compression_ratio1 = original_bps / bps1;
% compression_ratio2 = original_bps / bps2;
compression_ratio3 = original_bps / bps3;

x_rec = dekodowanie_podpasmowe(y4, 32, bps3,1);