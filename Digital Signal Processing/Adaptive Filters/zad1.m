clear all;
close all;
fs = 8e3;
t = 0:1/fs:1;
A1 = 0.5;
f1 = 34.2;
A2 = 1;
f2 = 115.5;
%sygnał zlozony z 2 sinusoid

% dref = (A1*sin(f1*2*pi*t)+A2*sin(f2*2*pi*t))';

%sygnał SFM

% fc = 1e3;
% fd = 500;
% fm = 0.25;
% dref = sin(2*pi*fc + fd*(sin(2*pi*fm*t))/fm);

%nagranie silniika 

[dref,fs] = audioread("r2d2talk01.wav");
N_dref = length(dref); 
t = 0:1/fs:(N_dref-1)/fs;

d = zeros(length(dref),3);

d(:,1) = awgn(dref,10,'measured');
d(:,2) = awgn(dref,20,'measured');
d(:,3) = awgn(dref,40,'measured');

x = zeros(length(d),3);
x(:,1) = [ d(1,1); d(1:end-1,1)];
x(:,2) = [ d(1,2); d(1:end-1,2)];
x(:,3) = [ d(1,3); d(1:end-1,3)];

M = 50;
mi = 0.009;

%  parametry filtru dla SFM
% M = 50;
% mi = 0.001;

y = zeros(length(x),3); e = zeros(length(x),3);
bx = zeros(M,1);
h = zeros(M,1);
for i = 1:3
    for n = 1:length(x)
        bx = [ x(n,i); bx(1:M-1)];
        y(n,i) = h' * bx;
        e(n,i) = d(n,i) - y(n,i);
        h = h+mi*e(n,i)*bx;
    end
    h = zeros(M,1);
end
N = length(dref);
P_dref = 0;
P_noise = zeros(1,3);
for n = 1:N
    P_dref = P_dref+(dref(n))^2;
    P_noise(1,1) = P_noise(1,1) + (dref(n)-y(n,1))^2;
    P_noise(1,2) = P_noise(1,2) + (dref(n)-y(n,2))^2;
    P_noise(1,3) = P_noise(1,3) + (dref(n)-y(n,3))^2;
end
P_dref = (1/N) * P_dref;
P_noise(1,1) = (1/N) * P_noise(1,1);
P_noise(1,2) = (1/N) * P_noise(1,2);
P_noise(1,3) = (1/N) * P_noise(1,3);


% P_noise1 = mean(d(:,1).^2);
% P_noise2 = mean(d(:,2).^2);
% P_noise3 = mean(d(:,3).^2);

SNR = zeros(1,3);
SNR(1,1) = 10*log10(P_dref./P_noise(1,1));
SNR(1,2) = 10*log10(P_dref./P_noise(1,2));
SNR(1,3) = 10*log10(P_dref./P_noise(1,3));
% 
figure;
plot(t, dref, 'b', 'LineWidth', 1.2); hold on;
% plot(t, d(:,1), 'r', 'LineWidth', 0.8);
plot(t, y(:,1), 'g', 'LineWidth', 1.2);
legend('Sygnał oryginalny (dref)', 'Zaszumiony (10 dB)', 'Odszumiony (LMS)');
xlabel('Czas [s]');
ylabel('Amplituda');
title(sprintf('Odszumianie sygnału – SNR = %.2f dB', SNR(1,1)));
grid on;

figure;
plot(t, dref, 'b', 'LineWidth', 1.2); hold on;
plot(t, d(:,2), 'r', 'LineWidth', 0.8);
plot(t, y(:,2), 'g', 'LineWidth', 1.2);
legend('Sygnał oryginalny (dref)', 'Zaszumiony (20 dB)', 'Odszumiony (LMS)');
xlabel('Czas [s]');
ylabel('Amplituda');
title(sprintf('Odszumianie sygnału – SNR = %.2f dB', SNR(1,2)));
grid on;

figure;
plot(t, dref, 'b', 'LineWidth', 1.2); hold on;
plot(t, d(:,3), 'r', 'LineWidth', 0.8);
plot(t, y(:,3), 'g', 'LineWidth', 1.2);
legend('Sygnał oryginalny (dref)', 'Zaszumiony (40 dB)', 'Odszumiony (LMS)');
xlabel('Czas [s]');
ylabel('Amplituda');
title(sprintf('Odszumianie sygnału – SNR = %.2f dB', SNR(1,3)));
grid on;