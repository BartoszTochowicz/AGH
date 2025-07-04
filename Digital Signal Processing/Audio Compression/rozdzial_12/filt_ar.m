% filtr IIR
% xn - sygnal wejsciowy
% b0 - wspolczynnik wzmocnienia
% ai - wspolczynniki wielomianu mianownika transmitancji (ai(1)=1)
% etat - pamiec filtru
function [yn, etat] = filt_ar(b0, ai, xn, etat)

P = length(etat);    %rzad filtru
yn = zeros(size(xn));
for n = 1:length(xn)
    yn(n) = b0*xn(n) - ai(2:P+1)'*etat;
    etat(2:P) = etat(1:P-1);
    etat(1) = yn(n);
end
