clear all;
close all;
[x1_read,fs1] = audioread("x1.wav");
x1 = x1_read(:,1);
[x2,fs2] = audioread("x2.wav");

fs = 48e3;

dt = 1/fs;
t = (0:dt:1-dt)';

L1 = 3;
L2 = fs/fs2;
M1 = 2;

x1_up = upsample(x1,L1);
x2_up = upsample(x2,L2);

N = 1001;
win = kaiser(N,8);
h1 = fir1(N-1,(1/L1) - 0.1*(1/L1),win);
h2 = fir1(N-1,(1/L2) - 0.1*(1/L2),win);
% h1 = fir1(N-1,(1/L1),win);
% h2 = fir1(N-1,(1/L2),win);

x1_filt = conv(x1_up, h1, 'same');
x2_filt = conv(x2_up, h2, 'same');

x1_final = x1_filt(1:M1:end);  

minLength = min(length(x1_final),length(x2_filt));

x1_final = x1_final(1:minLength);
x2_final = x2_filt(1:minLength);

x3 = x1_final+x2_final;


% Wykres
figure;
plot(x3); title('Sygnał zrekonstruowany (x3)');

sound(x3,fs);