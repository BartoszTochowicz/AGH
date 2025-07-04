clear all; close all;

[dref, fs] = audioread("mowa8000 (1).wav");
Nx = length(dref);
t = (0:Nx-1)'/fs;

% 1. Zakłócenie sinusoidalne
s_clean = sin(2*pi*1e3*t);

% 2. Tworzenie sygnału x (opóźniony i osłabiony sygnał zakłócenia)
x = [zeros(4,1); 0.25 * s_clean(1:end-4)];
x = x(1:Nx);  % dopasuj długość

% 3. Tworzenie sygnału obserwowanego d(n) = mowa + zakłócenie
s = 0.25 * s_clean; % ten sam jak x (ale bez opóźnienia)
d = dref + s;

% 4. Parametry filtra adaptacyjnego
M = 100;
mi = 0.05;
gamma = 1e-6;
lambda = 0.98;
delta = 1e3;
ialg = 2; % NLMS

% 5. Uruchomienie filtra
[y, e, h] = adaptTZ(d, x, M, mi, gamma, lambda, delta, ialg, fs);

% 6. Odsłuch błędu (czyli "oczyszczonej" mowy)
soundsc(e, fs);

% Odtworzenie oczyszczonego sygnału
% soundsc(y, fs);

% N = 2048;
% f = linspace(0, fs/2, N/2);
% 
% Y = abs(fft(y, N));
% E = abs(fft(e, N));
% D = abs(fft(d, N));
% 
% figure;
% subplot(3,1,1); plot(f, 20*log10(D(1:N/2))); title('Widmo sygnału d (mowa + zakłócenie)'); grid on;
% subplot(3,1,2); plot(f, 20*log10(Y(1:N/2))); title('Widmo y(n)'); grid on;
% subplot(3,1,3); plot(f, 20*log10(E(1:N/2))); title('Widmo błędu e(n)'); grid on;
% xlabel('Częstotliwość [Hz]');