clear all; close all;

fs = 3.2e6;         % Częstotliwość próbkowania
N  = 32e6;          % Liczba próbek
fc = 0.50e6;        % Częstotliwość nośna wybranej stacji

bwSERV = 80e3;      % Przepustowość kanału radiowego
bwAUDIO = 16e3;     % Przepustowość audio (sygnał końcowy)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);
s = s - 127;

% IQ --> sygnał zespolony
wideband_signal = s(1:2:end) + 1j*s(2:2:end); clear s;

% Analiza czasowo-częstotliwościowa sygnału szerokopasmowego
figure;
spectrogram(wideband_signal(1:2e5), 1024, 768, 1024, fs, 'yaxis');
title('Spectrogram sygnału szerokopasmowego');

% Widmo gęstości mocy
figure;
psd(spectrum.welch('Hamming', 1024), wideband_signal(1:2e5), 'Fs', fs);
title('Widmo gęstości mocy (PSD) - sygnał szerokopasmowy');

% Przesunięcie do pasma podstawowego
wideband_signal_shifted = wideband_signal .* exp(-1j*2*pi*fc/fs*(0:N-1)');

% Filtracja stacji (Butterworth LP, 4 rząd, fc = 80 kHz)
[b,a] = butter(6, (bwSERV/2)/(fs/2)); % normalizacja częstotliwości
wideband_signal_filtered = filter(b, a, wideband_signal_shifted);

% Downsampling do ~160 kHz
dec1 = fs / (2 * bwSERV);   % np. 20
x = wideband_signal_filtered(1:dec1:end);

% Demodulacja FM
dx = x(2:end) .* conj(x(1:end-1));
y = atan2(imag(dx), real(dx));

% Filtr antyaliasingowy (LP do 16 kHz)
[b2, a2] = butter(6, (bwAUDIO)/(bwSERV)); % fs = 80 kHz, fc = 16 kHz
y_filtered = filter(b2, a2, y);

% Downsampling do 32 kHz
dec2 = bwSERV / bwAUDIO; % np. 5
ym = y_filtered(1:dec2:end);

% De-emfaza (prosty filtr RC, opcjonalnie)
tau = 75e-6;
alpha = 1 / (1 + 1/(2*pi*tau*bwAUDIO*2));
ym = filter([1-alpha], [1 -alpha], ym);

% Normalizacja i dźwięk
ym = ym - mean(ym);
ym = ym / (1.001*max(abs(ym)));
soundsc(ym, bwAUDIO*2);  % 32 kHz

% Widma pośrednie
figure;
subplot(3,1,1); psd(spectrum.welch('Hamming',1024), wideband_signal(1:2e5),'Fs',fs); title('PSD: sygnał szerokopasmowy');
subplot(3,1,2); psd(spectrum.welch('Hamming',1024), x(1:2e4),'Fs',bwSERV*2); title('PSD: po filtracji i decymacji');
subplot(3,1,3); psd(spectrum.welch('Hamming',1024), ym,'Fs',bwAUDIO*2); title('PSD: sygnał audio');
