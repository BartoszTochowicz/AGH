function y = idct4(x)
% Szybkie obliczenie odwrotnej transformaty DCT-4 z bloku wspolczynnikow
%
% y = idct4(x)
% x - pionowy wektor wspolczynnikow 
% y - pionowy wektor probek

x = x(:);
N = 2*length(x);
[k,n] = meshgrid(0:(N/2-1),0:(N-1));
C = cos(pi*(2*n+1+N/2).*(2*k+1)/(2*N));
y = 4*C*x/N;