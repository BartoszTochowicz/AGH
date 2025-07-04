clear all; close all; clc;

% --- Parametry ---
fs = 16000;        % częstotliwość próbkowania [Hz]
T = 1;             % czas trwania sygnału [s]
fg = [1189, 1229]; % częstotliwości graniczne analogowe [Hz]

% --- Wczytanie danych ---
load butter.mat % zakładając, że plik zawiera zmienne z, p, k

% --- 1. Analogowy filtr: H(s) ---
[b_a, a_a] = zp2tf(z, p, k);  % zamiana na postać H(s)

% --- 2. Konwersja do cyfrowego filtru H(z) (bilinear transform) ---
[bd, ad] = bilinear(b_a, a_a, fs);

f = linspace(0, fs/2, 1024); 

% analogowy
w = 2*pi*f; % częstotliwość kątowa
H_analog = freqs(b_a, a_a, w);

% cyfrowy
H_digital = freqz(bd, ad, f, fs);


figure;
plot(f, 20*log10(abs(H_analog)), 'b', 'LineWidth', 1.5); hold on;
plot(f, 20*log10(abs(H_digital)), 'r--', 'LineWidth', 1.5);
xline(1189, 'k--', 'LineWidth', 1);
xline(1229, 'k--', 'LineWidth', 1);
legend('Analogowy H(s)', 'Cyfrowy H(z)', 'Lokalizacja f_g');
xlabel('Częstotliwość [Hz]');
ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa: analogowy vs cyfrowy filtr');
grid on;