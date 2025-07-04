clear all;
close all;
fs = 8e3;
t = 0:1/fs:1;
fc = 1e3;
fd = 500;
fm = 0.5;
dref = audioread("mowa8000 (1).wav");

d = zeros(length(dref),3);

d(:,1) = awgn(dref,10,'measured');
d(:,2) = awgn(dref,20,'measured');
d(:,3) = awgn(dref,40,'measured');

x = zeros(length(d),3);
x(:,1) = [ d(1,1); d(1:end-1,1)];
x(:,2) = [ d(1,2); d(1:end-1,2)];
x(:,3) = [ d(1,3); d(1:end-1,3)];

M = 100;
mi = 0.06;

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
    figure;
    freqz(h,1,1024,fs);
    title('Odpowiedź częstotliwościowa filtru h');
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

soundsc(y(:,1),fs);

fragment_len = round(0.25 * fs);
start_idx = length(dref) - fragment_len + 1;
fragment_dref = dref(start_idx:end);
fragment_y = y(start_idx:end,3);  % lub 1/2, zależnie od SNR

% Gęstość widmowa mocy (pwelch)
[pxx_dref, f] = pwelch(fragment_dref, hamming(256), 128, 1024, fs);
[pxx_y, ~] = pwelch(fragment_y, hamming(256), 128, 1024, fs);

figure;
plot(f,10*log10(pxx_dref), 'b', 'LineWidth', 1.5); hold on;
plot(f,10*log10(pxx_y), 'r', 'LineWidth', 1.5);
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość mocy [dB/Hz]');
legend('Oryginalny sygnał mowy', 'Odfiltrowany sygnał');
title('Widmo gęstości mocy - fragment końcowy');
grid on;

