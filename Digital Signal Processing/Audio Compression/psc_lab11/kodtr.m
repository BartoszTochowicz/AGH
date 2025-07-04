function [sym,bps] = kodtr(x,N,Q)
% Koder transformatowy
%
% [sym,bps] = kodtr(x, N, Q)
% x – sygnał wejściowy
%
% N – długość bloku próbek dla transformaty MDCT
% Q – współczynniki skalujące (jeden wspólny lub wektor indywidualnych współczynników)
% sym – tablica zakodowanych symboli
% bps – średnia liczba bitów zakodowanych danych na próbkę sygnału wejściowego

H = N/2;                        % przesunięcia kolejnych bloków
M = floor((length(x)-H)/H);      % liczba bloków
sym = zeros(H,M);               % tablica symboli danych zakodowanych
win = sin(pi*((0:(N-1))+0.5)/N)'; % okienko do transformaty MDCT

h_wbar = waitbar(0,'Przetwarzanie ramek', 'Name', 'Kodowanie transformatowe');
for m = 0:M-1
    waitbar(m/M,h_wbar);
    n0 = m*H + 1;               % początek bloku
    x0 = x(n0:n0+N-1);          % pobieranie bloku próbek
    x0 = x0.*win;               % okienkowanie
    Fk = dct4(x0);              % obliczenie transformaty
    Fkq = fix(Fk.*Q);           % kwantowanie współczynników
    sym(:,m+1) = Fkq;           % zapisanie do tablicy symboli
end
close(h_wbar);

% Oszacowanie wielkości strumienia danych
zakr = (max(sym')-min(sym'))';  % zakresy zmienności symboli
koszt = max(0,ceil(log2(zakr))); % szacunkowy koszt zakodowania symboli
bps = mean(koszt);              % średnia liczba bitów na próbkę