function y = dektr(sym,N,Q)
% Dekoder transformatowy
% y = dektr(sym, N, Q)
%
% sym - tablica zakodowanych symboli
% N - dlugosc bloku probek dla transformaty MDCT
% Q - wspolczynniki skalujace (jeden wspolny lub wektor indywidualnych wspolczynnikow)
% y - sygnal odtworzony

H = N/2;                        % przesuniecia kolejnych blokow
M = size(sym,2);                % liczba blokow
L = H * (M+1);                  % szacowana dlugosc sygnalu zdekodowanego
y = zeros(L,1);                 % miejsce na probki sygnalu
win = sin(pi*((0:(N-1))+0.5)/N)'; % okienko do transformaty MDCT

h_wbar = waitbar(0,'Dekodowanie ramek', 'Name', 'Kodowanie transformatowe');
for m = 0:M-1
    waitbar(m/M,h_wbar);
    Fkq = sym(:,m+1);           % odczytanie kolejnego wektora symboli
    Fkr = Fkq./Q;               % odtworzenie wspolczynnikow transformaty
    y0 = idct4(Fkr);            % obliczenie odwrotnej transformaty
    y0 = y0.*win;               % ponowne okienkowanie
    n0 = m*H + 1;               % poczatek bloku    
    y(n0:n0+N-1) = y(n0:n0+N-1)+y0; % skladanie blokow na zakladke
end
close(h_wbar);