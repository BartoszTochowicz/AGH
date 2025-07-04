function y = dct4(x)
% Szybkie obliczenie transformaty DCT-4 z bloku probek
% y = dct4(x)
% x - pionowy wektor probek
% y - pionowy wektor wspolczynnikow

x = x(:);
N = length(x);
if mod(N, 2)
    error('Rzad transformacji musi byc parzysty');
end
N  = length(x);
[n,k] = meshgrid(0:(N-1),0:(N/2-1));
C = cos(pi*(2*n+1+N/2).*(2*k+1)/(2*N));
y = C*x;
