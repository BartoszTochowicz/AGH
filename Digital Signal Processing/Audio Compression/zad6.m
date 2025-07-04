% cps_13_aac.m
% Podstawy kodera audio AAC z uzyciem nakladkowej transformacji MDCT
clear all; close all;
Nmany = 100; % liczba przetwarzanych ramek sygnalu audio
N = 2048; % teraz uzywamy tylko jednej dlugosci okna, sa dwie 256 i 2048
M = N/2; % przesuniecie okna 50%
Nx = N+M*(Nmany-1); % liczba przetwarzanych probek sygnalu audio
% Sygnal wejsciowy
[x, fpr ] = audioread('ah-repond-samsondelilah-saint-saens-anneliese-von-koenig-mezzo-127459.mp3'); size(x), pause % rzeczywisty wczytany
x = x(174400:end,1);
% fpr=44100; x=0.3*randn(Nx,1); % syntetyczny szum
% fpr=44100; x = 0.5*sin(2*pi*200/fpr*(0:Nx-1)’); % syntetyczny sinus
x = x(1:Nx,1); % wez tylko poczatek
soundsc(x,fpr); % odegraj
figure; plot(x);  % pokaz
% Macierze transformacji MDCT oraz IMDCT o wymiarach M=N/2 x N
win = sin(pi*((0:N-1)'+0.5)/N); % pionowe okno do wycinania fragmentu sygnalu
k = 0:N/2-1; n=0:N-1; % wiersze-czestotliwosci, kolumny-probki
C = sqrt(2/M)*cos(pi/M*(k'+1/2).*(n+1/2+M/2)); % macierz C (N/2)xN analizy MDCT
D = C'; % transpozycja % macierz D Nx(N/2)syntezy IMDCT

sb = zeros(Nmany, M); % macierz na wspolczynniki MDCT
for kk = 1:Nmany
    idx = 1+(kk-1)*M : N+(kk-1)*M;
    buf = x(idx) .* win;
    BX = C * buf; % MDCT
    sb(kk,:) = BX';
end

% Analiza-synteza AAC
% --- Wyświetlanie macierzy MDCT jak spektrogram
figure;
imagesc(abs(sb')); axis xy;
xlabel('Ramy czasowe'); ylabel('Numer podpasma (częstotliwość)');
title('Moduł współczynników MDCT');
colorbar;

% --- MASKOWANIE: zostaw tylko wybrane pasma (np. 30-50)
mask = zeros(size(sb));
mask(:,30:50) = 1; % Przykład: tylko pasma 30–50

sb_masked = sb .* mask;

% --- Synteza sygnału z zamaskowanych wsp. MDCT
y_masked = zeros(Nx,1);
for k=1:Nmany
    n = 1+(k-1)*M : N + (k-1)*M;
    BX_masked = sb_masked(k,:)';
    by_masked = D * BX_masked;
    y_masked(n) = y_masked(n) + by_masked .* win;
end

% --- Odsłuch, porównanie
pause
soundsc(y_masked, fpr);
figure; plot(n, x, 'r', n, y_masked, 'b'); legend('Oryginał', 'Przefiltrowany');