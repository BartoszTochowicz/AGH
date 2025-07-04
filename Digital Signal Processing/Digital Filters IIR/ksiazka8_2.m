% cps_08_iir_intro.m
clear all; close all;
% Wybor/projekt wspolczynnikow filtra cyfrowego IIR
fpr = 2000; % czestotliwosc probkowania
if(0) % ### dobor wartosci wspolczynnikow wielomianow transmitancji
b = [2,3]; % [ b0, b1 ]
a = [1, 0.2, 0.3, 0.4]; % [ a0=1, a2, a3, a4]
z = roots(b); p = roots(a); % [b,a] --> [z,p]
else % ### dobor miejsc zerowych wielomianow transmitancji
gain = 0.001;
z = [ 1, 1 ] .* exp(j*2*pi*[ 300, 800 ]/fpr); z = [z conj(z)];
p = [ 0.99,0.99 ] .* exp(j*2*pi*[ 100, 200 ]/fpr); p = [p conj(p)];
b = gain*poly(z), a = poly(p), pause % [z,p] --> [b,a]
end
figure;
alfa = 0 : pi/1000 : 2*pi; c=cos(alfa); s=sin(alfa);
plot(real(z),imag(z),'bo', real(p),imag(p),'r*',c,s,'k-'); grid;
title('Zera i Bieguny'); xlabel('Real()'); ylabel('Imag()'); pause
% Weryfikacja odpowiedzi filtra: amplitudowej, fazowej, impulsowej, skokowej
f = 0 : 0.1 : 1000; % czestotliwosc w hercach
wn = 2*pi*f/fpr; % czestotliwosc katowa
zz = exp(-j*wn); % zmienna "z" transformacji Z (u nas z^(-1))
H = polyval(b(end:-1:1),zz) ./ polyval( a(end:-1:1),zz); % stosunek dwoch wielomianow
% H = freqz(b,a,f,fpr) % alternatywna funkcja Matlab
figure; plot(f,20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid; pause
figure; plot(f,unwrap(angle(H))); xlabel('f [Hz]'); title('angle(H(f)) [rad]'); grid; pause
zz = exp(j*wn); % zmienna transformacji Z
H = polyval(b,zz) ./ polyval(a,zz); % stosunek dwoch wielomianow dla zz=exp(j*om)
% H = freqz(b,a,f,fpr) % alternatywna funkcja Matlaba
figure; plot(f,20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid; pause
figure; plot(f,unwrap(angle(H))); xlabel('f [Hz]'); title('angle(H(f)) [rad]'); grid; pause
% ... ciag dalszy nastapi