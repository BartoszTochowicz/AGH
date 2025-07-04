clear; close all;

% 1. Wczytanie plików
[mowa, fs1]   = audioread("798739__freqwincy__we-spoke-about-this-on-the-telephone.m4a");
[silnik, fs2] = audioread("corsa-xterioridle2.mp3");
fs = fs1;
if fs1 ~= fs2
    silnik = resample(silnik, fs1, fs2);  % resamplujemy silnik do fs1
end

% przygotowanie mono i wyrównanie długości
mowa   = mean(mowa,2);
silnik = mean(silnik,2);
L = max(length(mowa), length(silnik));
mowa(end+1:L)   = 0;
silnik(end+1:L) = 0;

% miks i normalizacja
mixed = mowa + silnik;
mixed = mixed / max(abs(mixed));

% oś czasu
t = (0:L-1)/fs;
N = 2048;
f = (0:N/2-1)*(fs/N);

M1 = abs(fft(mowa  (1:N), N));
M2 = abs(fft(silnik(1:N), N));
M3 = abs(fft(mixed(1:N), N));

figure;
subplot(3,1,1);
plot(f,20*log10(M1(1:N/2))); title('FFT MOWA'); xlabel('Hz'); ylabel('dB'); grid on;

subplot(3,1,2);
plot(f,20*log10(M2(1:N/2))); title('FFT SILNIK'); xlabel('Hz'); ylabel('dB'); grid on;

subplot(3,1,3);
plot(f,20*log10(M3(1:N/2))); title('FFT MIXED'); xlabel('Hz'); ylabel('dB'); grid on;
window = hann(512);
noverlap = 256;
nfft    = 512;

figure;
subplot(3,1,1);
spectrogram(mowa,   window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram MOWA');

subplot(3,1,2);
spectrogram(silnik, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram SILNIK');

subplot(3,1,3);
spectrogram(mixed, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram MIXED');
f_low  = 300;    % Hz
f_high = 3400;   % Hz
Wp = [f_low f_high]/(fs/2);   % normalizacja

[Nb, Na] = butter(6, Wp, 'bandpass');

% odpowiedź częstotliwościowa
[H, w] = freqz(Nb, Na, 1024, fs);
figure;
plot(w, 20*log10(abs(H)));
xlabel('Hz'); ylabel('Amplitude [dB]');
title('Charakterystyka filtru BP 300–3400 Hz'); grid on;

% zerap i bieguny
figure; zplane(Nb, Na);
title('Zera i bieguny filtru IIR');
% 3.1 Filtracja
y_iir = filter(Nb, Na, mixed);

% 3.2 Kompensacja opóźnienia
[gd, w_gd] = grpdelay(Nb, Na, 1024, fs);
d = round(mean(gd));

% Upewnij się, że d jest prawidłowe
if ~isfinite(d) || d < 0 || d >= length(y_iir)
    warning("Nieprawidłowe d = %g – ustawiam na 0", d);
    d = 0;
end
if length(y_iir) > d
    y_iir = [y_iir(d+1:end); zeros(d,1)];
end
% 3.3 Odsłuch
soundsc(y_iir, fs);
M4 = abs(fft(y_iir(1:N), N));
figure;
plot(f,20*log10(M4(1:N/2)));
title('FFT po filtracji IIR'); xlabel('Hz'); ylabel('dB'); grid on;
figure;
spectrogram(y_iir, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram po filtracji IIR');
