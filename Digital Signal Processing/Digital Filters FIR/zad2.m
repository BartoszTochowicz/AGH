clear all; close all; clc;

fs_down = 200e3; % Hz
f_nyq = fs_down/2; % częstotliwość Nyquista

N = 300;
w5 = blackmanharris(N+1); % okno Blackmana-Harrisa

f_cutoff_mono = 15e3;
b_mono = fir1(N, f_cutoff_mono/f_nyq, "low", w5);


f1_pilot = 18.95e3;
f2_pilot = 19.05e3;

N_pilot = 1500;
beta = 14; 
w_kaiser = kaiser(N_pilot+1, beta);
b_pilot = fir1(N_pilot, [f1_pilot f2_pilot]/f_nyq, "bandpass", w_kaiser);

figure;
freqz(b_mono, 1, 4096, fs_down);
title('Charakterystyka filtru MONO (L+R)');

figure;
freqz(b_pilot, 1, 4096, fs_down);
title('Charakterystyka filtru PILOT (19kHz)');


fs = 3.2e6; % sampling frequency
Num_of_samples = 32e6;
fc = 100e6;
fid = fopen('samples_100MHz_fs3200kHz (1).raw');
s = fread(fid,2*Num_of_samples,'uint8');
fclose(fid);

s = s-127;
% 
% % IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); 

% figure;psd(spectrum.welch('Hamming',1024), wideband_signal(1:end),'Fs',fs);

% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:Num_of_samples-1]');
baseband_ds = decimate(real(wideband_signal_shifted), fs/fs_down);

pilot = filter(b_pilot,1,baseband_ds);

% Analiza widmowa
nfft = 2^18;
[Px,f] = pwelch(pilot, hamming(4096), 2048, nfft, fs_down);

window = hamming(1024);
noverlap = 768;
nfft = 4096;

figure;
spectrogram(pilot, window, noverlap, nfft, fs_down, 'yaxis');
title('Spectrogram pilota stereo (19 kHz)');
ylim([10 20]); % Zakres do 30 kHz
colorbar;