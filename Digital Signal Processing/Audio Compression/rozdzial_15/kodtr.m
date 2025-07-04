function [sym,bps] = kodtr(x,N,Q)
% Koder transformatowy
%
% [sym,bps] = kodtr(x, N, Q)
% x - sygnal wejsciowy
%
% N - dlugosc bloku probek dla transformaty MDCT
% Q - wspolczynniki skalujace (jeden wspolny lub wektor indywidualnych wspolczynnikow)
% sym - tablica zakodowanych symboli
% bps - srednia liczba bitow zakodowanych danych na probke sygnalu wejsciowego

H = N/2;                        % przesuniecia kolejnych blokow
M = floor((length(x)-H)/H);      % liczba blokow
sym = zeros(H,M);               % tablica symboli danych zakodowanych
win = sin(pi*((0:(N-1))+0.5)/N)'; % okienko do transformaty MDCT

h_wbar = waitbar(0,'Przetwarzanie ramek', 'Name', 'Kodowanie transformatowe');
for m = 0:M-1
    waitbar(m/M,h_wbar);
    n0 = m*H + 1;               % poczatek bloku
    x0 = x(n0:n0+N-1);          % pobieranie bloku probek
    x0 = x0.*win;               % okienkowanie
    Fk = dct4(x0);              % obliczenie transformaty
    Fkq = fix(Fk.*Q);           % kwantowanie wspolczynnikow
    sym(:,m+1) = Fkq;           % zapisanie do tablicy symboli
end
close(h_wbar);

% Oszacowanie wielkosci strumienia danych
zakr = (max(sym')-min(sym'))';  % zakresy zmiennosci symboli
koszt = max(0,ceil(log2(zakr))); % szacunkowy koszt zakodowania symboli
bps = mean(koszt);              % srednia liczba bitow na probke


