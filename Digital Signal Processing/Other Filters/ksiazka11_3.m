% clear all;
% close all;
% load("lab08_am.mat");
% T = 1;
% fs = 1000;
% fc = 200;

close all; clear;

% Parametry sygnału
Nx = 1000;
fs = 2000;
f0 = fs/40;
x = cos(2*pi*(f0/fs)*(0:Nx-1)); % Sygnał testowy

%% Tworzenie filtra Hilberta z definicji
M = 50;                  % Połowa długości filtra
N = 2*M + 1;             % Długość całkowita
n = -M:M;                % Indeksy próbek
h = (1 - cos(pi*n)) ./ (pi*n); % Definicja
h(M+1) = 0;              % wartość dla n = 0 (bo 0/0)

figure;
stem(n, h);
title('Odpowiedź impulsowa filtra Hilberta');
xlabel('n'); grid on;

%% Analiza częstotliwościowa filtra
f = -fs/2 : fs/2000 : fs/2;

% Metoda 1: definicja przez wielomian z Z-transformacji
z = exp(-1j*2*pi*f/fs);   % zmienna zespolona z = e^(-jω)
H1 = polyval(fliplr(h), z);  % odwrócenie h dla wielomianu

% Metoda 2: freqz (tylko dla f > 0)
[H2, f2] = freqz(h, 1, f, fs);

% Amplituda (log)
figure;
plot(f, 20*log10(abs(H1)));
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Odpowiedź amplitudowa filtra Hilberta');
grid on;

% Faza – przed kompensacją
figure;
plot(f, unwrap(angle(H1)));
xlabel('f [Hz]'); ylabel('Faza [rad]');
title('Odpowiedź fazowa filtra Hilberta (przed kompensacją)');
grid on;

%% Kompensacja opóźnienia liniowego
H1_corr = H1 .* exp(1j*2*pi*f/fs*M); % kompensacja opóźnienia M próbek

figure;
plot(f, angle(H1_corr));
xlabel('f [Hz]'); ylabel('Faza [rad]');
title('Odpowiedź fazowa po kompensacji');
grid on;

%% Okienkowanie – poprawa odpowiedzi amplitudowej
w = kaiser(N, 10)';     % Okno Kaisera
h_win = h .* w;         % Wagi po okienkowaniu
% Odpowiedź częstotliwościowa po okienkowaniu
H_win = polyval(fliplr(h_win), z);

figure;
plot(f, 20*log10(abs(H_win)));
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Odpowiedź amplitudowa z oknem Kaisera');
grid on;

% Alternatywnie możesz też sprawdzić inne okna:
% w = hamming(N)';
% w = blackman(N)';
% w = hann(N)';



% Zakładamy, że masz zdefiniowane: fs, f0, x, M, N, h z poprzedniego zadania

% Filtrowanie: przekształcenie przez filtr Hilberta
xH = filter(h, 1, x); % H[x(n)] – odpowiedź Hilberta

% Synchronizacja – usuwamy przesunięcie o M próbek
x_sync = x(M+1 : end-M);              % x(n)
xH_sync = xH(2*M+1 : end);            % przesunięta H[x(n)]

% Tworzymy sygnał analityczny
xa = x_sync + 1j * xH_sync;
Nx = length(xa);

% --- WYKRESY czasowe: x vs xH ---
figure;
plot(1:Nx, x_sync, 'ro-', 1:Nx, xH_sync, 'bo-');
xlabel('n'); legend('x(n)', 'H[x(n)]');
title('Porównanie sygnału i odpowiedzi filtra Hilberta');
grid on;

% Czy kosinus zamienił się w sinus? (przesunięcie fazy o π/2)

% --- WYKRES fazowy: Lissajous ---
figure;
plot(x_sync, xH_sync, 'bo-');
xlabel('x(n)'); ylabel('H[x(n)]');
title('Wykres Lissajous – czy otrzymaliśmy okrąg?');
axis equal; grid on;

% --- Analiza widmowa ---
X = fft(x_sync);     % FFT sygnału rzeczywistego
Xa = fft(xa);        % FFT sygnału analitycznego

% Częstotliwości osi
f_fft = linspace(-fs/2, fs/2, Nx);

% Przesunięcie widmowe (dla poprawnego wyświetlania od -fs/2 do fs/2)
X_shifted = fftshift(X);
Xa_shifted = fftshift(Xa);

% --- Widma ---
figure;
plot(f_fft, abs(X_shifted), 'r', f_fft, abs(Xa_shifted), 'b');
xlabel('f [Hz]');
ylabel('|X(f)| i |Xa(f)|');
legend('Oryginalny', 'Analityczny');
title('Widma sygnału rzeczywistego i jego wersji analitycznej');
grid on;
