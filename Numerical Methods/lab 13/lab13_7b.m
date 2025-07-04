% oblicz_pi.m
clear all; close all;
format long;
N = 100000; % liczba strzalow
Nk = 0; % liczba trafien w kolo
for i = 1 : N % PETLA: kolejne strzaly
x = rand(1,1)*2.0 - 1.0; % # kwadrat o boku 2
y = rand(1,1)*2.0 - 1.0; % #
if( sqrt( x*x + y*y ) <= 1.0) % kolo o promieniu 1
Nk = Nk + 1; % zwieksz liczbe trafien o 1
end %
end %
pi, % dokladne pi
mypi = 4.0 * Nk / N, % obliczone pi
xy = 2*rand(N,2)-1.0;
Nk = numel( find( sqrt(xy(:,1).^2 + xy(:,2).^2) <= 1 ) );
disp('Różnica względem wartości rzeczywistej:');
difference = pi - mypi;
disp(difference)
