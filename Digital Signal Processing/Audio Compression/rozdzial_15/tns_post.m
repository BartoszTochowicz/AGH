function Fk = tns_post(Fk,R)
% Fk = tns_post(Fk,A)
%
% Fk - wektor wspolczynnikow transformaty MDCT
% R - wspolczynniki predyktora

% przeliczenie wspolczynnikow do postaci LP
a = rc2poly(R); 

% filtr syntezy (odtwarzanie przebiegu)
Fk = filter(1,a,Fk);  