clear all;
close all;
[x,fs] = audioread("mowa8000 (1).wav");
% x = wgn(length(x_audio),1,0);
h_true = zeros(256,1);
h_true(256,1) = 0.8;
h_true(121,1) = -0.5;
h_true(31,1) = 0.1;

d = filter(h_true,1,x);


M = 256;
mi = 0.02;
% mi = 0.002;
gamma = 1e-6;
lambda = 0.98;
delta = 1e3;
ialg = 2; % NLMS


% [y,e,h] = adaptTZ(d,x)

bx = zeros(M,1);
h_est = zeros(M,1);
y = zeros(size(x));
e = zeros(size(x));

for n = 1:length(x)
    bx = [x(n); bx(1:M-1)];
    y(n) = h_est'*bx;
    e(n) = d(n) - y(n);
    h_est = h_est + mi * e(n) * bx;
end
% h_est = 2*h_est;
err = mean(abs(h_est - h_true))

figure;
stem(h_true, 'bx', 'LineWidth', 1.5); hold on;
stem(h_est, 'r--', 'LineWidth', 1.2);
xlabel('Próbka');
ylabel('Amplituda');
legend('Rzeczywista odpowiedź impulsowa', 'Estymowana przez LMS');
title('Porównanie odpowiedzi impulsowych');
grid on;

% soundsc(y,fs)