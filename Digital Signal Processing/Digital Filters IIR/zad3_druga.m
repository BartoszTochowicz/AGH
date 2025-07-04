% odbiornik FM: P. Swiatkiewicz, T. Twardowski, T. Zielinski, J. Bułat

clear all; close all; clc;

fs = 3.2e6; % sampling frequency
N = 32e6; % number of samples (IQ)
% fc = 0.4e6; % central frequency of MF station
% fc = 0.89e6;
% fc = 2.19e6;
fc = 2.49e6; % UFO
% fc = 2.79e6;

bwSERV = 80e3; % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 16e3; % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s-127;

% IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;

figure;psd(spectrum.welch('Hamming',1024), wideband_signal(1:end),'Fs',fs);

% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');

figure;psd(spectrum.welch('Hamming',1024), wideband_signal_shifted(1:end),'Fs',fs);

% Filter out the service from the wide-band signal
[b,a] = butter(4, 80e3/fs);
wideband_signal_filtered = filter( b, a, wideband_signal_shifted );

figure;psd(spectrum.welch('Hamming',1024), wideband_signal_filtered(1:end),'Fs',fs);

% Down-sample to service bandwidth - bwSERV = new sampling rate
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );

figure;psd(spectrum.welch('Hamming',1024), x(1:end),'Fs',bwSERV);

% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );

figure;psd(spectrum.welch('Hamming',1024), y(1:end),'Fs',bwSERV);

% Decimate to audio signal bandwidth bwAUDIO
[bA,aA] = butter(6,16e3/bwSERV);
y = filter(bA,aA,y); % antyaliasing filter
ym = y(1:bwSERV/(bwAUDIO):end); % decimate (1/5)

% De-emfaza
fo = 2100;
[b_de, a_de] = butter(2, fo/(bwAUDIO/2), 'low');
ym = filter(b_de,a_de,ym);

% freqz(b_de, a_de,0:bwAUDIO/2, bwAUDIO);

figure;psd(spectrum.welch('Hamming',1024), ym(1:end),'Fs',bwAUDIO);

% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
soundsc( ym, bwAUDIO*2);
% audiowrite("UFO.wav",ym,bwAUDIO*2)