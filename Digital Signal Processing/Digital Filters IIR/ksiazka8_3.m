clear all; close all;
% Wybor/projekt wspolczynnikow filtra cyfrowego IIR
fpr = 2000; % czestotliwosc probkowania

gain = 0.001;
z = [ 1, 1 ] .* exp(j*2*pi*[ 600, 800 ]/fpr); z = [z conj(z)];
p = [ 0.99,0.99 ] .* exp(j*2*pi*[40,60]/fpr); p = [p conj(p)];
b = gain*poly(z), a = poly(p),  % [z,p] --> [b,a]


f = 0 : 0.1 : 1000; % czestotliwosc w hercach
wn = 2*pi*f/fpr; % czestotliwosc katowa
zz = exp(-j*wn); % zmienna "z" transformacji Z (u nas z^(-1))
H = polyval(b(end:-1:1),zz) ./ polyval( a(end:-1:1),zz); % stosunek dwoch wielomianow
% H = freqz(b,a,f,fpr) % alternatywna funkcja Matlab

% --- Rysowanie wykresów ---
figure; plot(f, 20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid on;
figure; plot(f, unwrap(angle(H))); xlabel('f [Hz]'); title('∠H(f) [rad]'); grid on;

% --- Wykres zer i biegunów ---
figure;
alfa = 0 : pi/1000 : 2*pi;
c = cos(alfa); s = sin(alfa);
plot(real(z), imag(z), 'bo', real(p), imag(p), 'r*', c, s, 'k-'); 
title('Zera i Bieguny'); xlabel('Re'); ylabel('Im'); grid on;