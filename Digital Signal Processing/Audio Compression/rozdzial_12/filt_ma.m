% filtr FIR
% xn - sygnal wejsciowy
% bi - wspolczynniki filtru
% etat - pamiec filtru
function [yn, etat] = filt_ma(bi, xn, etat)

P = length(etat);  % rzad filtru
yn = zeros(size(xn));
for n = 1:length(xn)
    yn(n) = bi'*[xn(n); etat];
    etat(2:P) = etat(1:P-1);
    etat(1) = xn(n);
end;
