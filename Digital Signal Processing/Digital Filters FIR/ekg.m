close all;
clear all;

load('ECG100.mat');
ecg = val(1,:);
fpr = 360;
pwelch(ecg,[],[],2^14,fpr);

f_low = [0.5 45];
f_nyg = fpr/2;

M = 50;
N = 2*M+1;
h = fir1(N-1,f_low/f_nyg,"bandpass",blackmanharris(N));
% h = fir1(N-1,[25.5 75]/f_nyg,"bandpass",rectwin(N));

y = filter(h,1,ecg);

x_sync = ecg(M+1:end);
y_sync = y(2*M+1:end);

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


ecg_noise = ecg+10.5*randn(1,length(ecg));


y_noise = filter(h,1,ecg_noise);

x_sync_noise = ecg_noise(M+1:end);
y_sync_noise = y_noise(2*M+1:end);

Nmin = min(length(x_sync_noise), length(y_sync_noise));
x_sync_noise = x_sync_noise(1:Nmin);
y_sync_noise = y_sync_noise(1:Nmin);

figure;
plot((0:Nmin-1)/fpr, x_sync_noise, 'b', 'DisplayName', ' EKG zaszumiony');
hold on;
plot((0:Nmin-1)/fpr, y_sync_noise, 'r--', 'DisplayName', 'Po filtracji (odszumione)');
xlabel('Czas [s]');
ylabel('Amplituda');
title('Porównanie odszumiania sygnału EKG');
legend;
grid on;

