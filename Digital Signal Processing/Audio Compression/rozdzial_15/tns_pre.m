function [Fk,R] = tns_pre(Fk,Pmax,Gmin)
% Fk = tns_pre(Fk,Pmax,Gmin)
%
% Fk - wektor wspolczynnikow transformaty MDCT
% Pmax - maksymalny rzad predykcji
% Gmin - minimalny zysk predykcji
% R - wspolczynniki PARCOR predyktora

Rmin = 0.05;

% wyznaczamy wspolczynniki predyktora
a = lpc(Fk,Pmax);

% przeksztalcamy do postaci PARCOR
R = poly2rc(a); 

% znajdujemy male wartosci wspolczynnikow
z = find(abs(R)>=Rmin,1,'last'); 
if ~isempty(z)
    % odrzucamy koncowe male wspolczynniki zmniejszajac rzad predyktora
    R(z+1:end)=[]; 
    a = rc2poly(R); % przeliczenie z PARCOR na LPC
end

% filtr analizy ("wybielanie" w czasie, 
% czyli wyrownywanie amplitudy sygnalu)
X = filter(a,1,Fk); 

% obliczanie zysku predykcji
Gp = rms(Fk)/rms(X); 
if Gp >= Gmin % warunek aktywnosci narzedzia TNS
    % zastapienie wybranych wspolczynnikow MDCT wartosciami bledu predykcji
    Fk = X;     
else
    R = [];
end