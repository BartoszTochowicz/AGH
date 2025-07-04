clear all; close all; clc;

%% Parametry ogólne
fs = 3.2e6;              % Częstotliwość próbkowania
N = 32e6;                % Liczba próbek
fc = 2.49e6;             % Przesunięcie częstotliwości stacji FM (np. UFO)
bwSERV = 80e3;           % Przepustowość kanału FM
bwAUDIO = 16e3;          % Przepustowość audio

%% Wczytanie sygnału
f = fopen('samples_100MHz_fs3200kHz (1).raw');
s = fread(f, 2*N, 'uint8');
fclose(f);
s = s - 127;             % Przeskalowanie z uint8

% Sygnał zespolony IQ
wideband_signal = s(1:2:end) + 1i*s(2:2:end);

%% Przesunięcie do pasma podstawowego
n = 0:N-1;
wideband_signal_shifted = wideband_signal .* exp(-1i*2*pi*fc/fs*n');

%% Filtracja pasmowa i decymacja
[b_bp, a_bp] = butter(4, bwSERV/fs); % Antyaliasing
x_filtered = filter(b_bp, a_bp, wideband_signal_shifted);
x = x_filtered(1:fs/(bwSERV*2):end); % Downsampling do 160 kHz

%% Demodulacja FM
dx = x(2:end).*conj(x(1:end-1));
y = atan2(imag(dx), real(dx)); % faza różniczkowa

%% Antyaliasing i dalsza decymacja do 32 kHz
[bA, aA] = butter(6, 16e3/(bwSERV)); 
y = filter(bA, aA, y); 
ym = y(1:bwSERV/(bwAUDIO):end); % finalna dekymacja

%% De-emfaza
fo = 2100;
[b_de, a_de] = butter(2, fo/(bwAUDIO/2), 'low');
ym = filter(b_de, a_de, ym);

% Filtracja pilota PRZED decymacją do audio
fs_fm = bwSERV; % 160 kHz
f1_pilot = 18.9e3;
f2_pilot = 19.1e3;

N_pilot = 1500;
beta = 14;
w_kaiser = kaiser(N_pilot+1, beta);
b_pilot = fir1(N_pilot, [f1_pilot f2_pilot]/(fs_fm/2), "bandpass", w_kaiser);

pilot = filter(b_pilot, 1, y); % y to wynik demodulacji FM przy fs=160kHz

% Teraz analiza czasowo-częstotliwościowa pilota
window = hamming(1024);
noverlap = 768;
nfft = 4096;

figure;
spectrogram(pilot, window, noverlap, nfft, fs_fm, 'yaxis');
title('Spectrogram pilota stereo (19 kHz)');
ylim([0 30]); % Zakres do 30 kHz
colorbar;
