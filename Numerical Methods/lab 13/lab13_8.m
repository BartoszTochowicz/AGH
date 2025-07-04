% oblicz_skut.m - obliczanie wartosci skutecznej snusoidy
clear all; close all;
Ax = sqrt(2)*230; fx = 50; % nominalna amplituda i czestotliwosc sygnalu
Nx = 100; n = 0:Nx-1; % liczba probek, indeksy probek
fpr = Nx * fx; % czest. probkowania 100x wieksza, ~100 probek/okres
for iter = 1 : 10000
x = Ax*sin( 2*pi*(fx+1/3*randn())/fpr * n + rand()*2*pi ); %sygnal
x = awgn( x, 0 ); % SNR = 0, 20, 40, 60 dB
xsk1(iter) = sqrt( sum(x.^2) / Nx ); % estymator #1
xsk2(iter) = max( abs(x) ) / sqrt(2); % estymator #2
end
subplot(211); hist(xsk1,30); grid; xlabel('xsk1'); title('hist( xsk1 )');
subplot(212); hist(xsk2,30); grid; xlabel('xsk2'); title('hist( xsk2 )');