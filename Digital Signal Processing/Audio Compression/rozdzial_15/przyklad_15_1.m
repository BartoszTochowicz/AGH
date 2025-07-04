% przyklad 15.1: Demonstracja kodowania podpasmowego

clc; clear; close all
[x,Fs] = wavread('harpsichord.wav'); 	% Wczytanie sygnalu z pliku wav
soundsc(x,Fs)                           % odsluchanie
figure(1)
specgram(x,2048,Fs,2000)                % demonstracja spektrogramu
title('Sygnal oryginalny')

% Zakodowanie koderem podpasmowym z uzyciem 8 podpasm i 6 bitow na probke
% UWAGA: przed skwantowaniem kazde pasmo jest normalizowane do zakresu -1..1
[y2,bps] = kodowanie_podpasmowe(x,8,6);
soundsc(y2,Fs)
figure(2)
specgram(y2,2048,Fs,2000)
title(sprintf('Liczba bitow na probke: %1.2f\n',bps))

% Zakodowanie koderem podpasmowym z uzyciem 32 podpasm i 8 bitow na probke
[y3,bps] = kodowanie_podpasmowe(x,32,5);
soundsc(y3,Fs)
figure(3)
specgram(y3,2048,Fs,2000)
title(sprintf('Liczba bitow na probke: %1.2f\n',bps))

% Zakodowanie koderem podpasmowym z uzyciem 16 podpasm i zmiennej liczby bitow na probke
[y4,bps] = kodowanie_podpasmowe(x,16,[6 5 4 4 3 3 3 3 3 3 3 3]);
soundsc(y4,Fs)
figure(4)
specgram(y4,2048,Fs,2000)
title(sprintf('Liczba bitow na probke: %1.2f\n',bps))
