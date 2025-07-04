close all;
clear all;
load("ECG100.mat");
ekg = val(1,:);
fpr = 360;
t = (0:length(ekg)-1)/fpr;
figure;
plot(t, ekg);
title('Oryginalny sygnał EKG');
xlabel('Czas [s]');
ylabel('Amplituda');

nfft = 2^14;
[Pxx, f] = pwelch(ekg, [], [], nfft, fpr);

figure;
plot(f, 10*log10(Pxx));
title('Widmo sygnału EKG');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');
xlim([0 100]);
grid on;

f_pass = [0.5 40]; % Hz

% Normalizacja do Nyquista
f_nyq = fpr/2;
f_norm = f_pass / f_nyq;

% Projekt filtru
N_filt = 300; % liczba próbek filtru
b = fir1(N_filt, f_norm, 'bandpass', hamming(N_filt+1)); % filtr BP

% Filtracja
y = filter(b, 1, ekg);

P = (N_filt)/2;

x_sync = ekg(P+1:end);
y_sync = y(N_filt+1:end);

Nmin = min(length(x_sync), length(y_sync));
x_sync = x_sync(1:Nmin);
y_sync = y_sync(1:Nmin);

figure;
plot((0:Nmin-1)/fpr, x_sync, 'b', 'DisplayName', 'Sygnał oryginalny');
hold on;
plot((0:Nmin-1)/fpr, y_sync, 'r--', 'DisplayName', 'Sygnał po filtracji');
xlabel('Czas [s]');
ylabel('Amplituda');
title('Porównanie sygnału przed i po filtracji');
legend;
grid on;

ekg_noise = ekg + 0.5*randn(1,length(ekg)); 
y_noisy = filter(b, 1, ekg_noise);          

P = N_filt/2; 

x_sync_noisy = ekg_noise(P+1:end);
y_sync_noisy = y_noisy(P+1:end);

Nmin = min(length(x_sync_noisy), length(y_sync_noisy));
x_sync_noisy = x_sync_noisy(1:Nmin);
y_sync_noisy = y_sync_noisy(1:Nmin);

figure;
plot((0:Nmin-1)/fpr, x_sync_noisy, 'b', 'DisplayName', 'EKG zaszumione');
hold on;
plot((0:Nmin-1)/fpr, y_sync_noisy, 'r--', 'DisplayName', 'Po filtracji ');
xlabel('Czas [s]');
ylabel('Amplituda');
title('Porównanie odszumiania sygnału EKG');
legend;
grid on;