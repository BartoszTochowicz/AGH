clear all;
close all;
f1 = 1001.2;
fs1 = 8e3;
dt1 = 1/fs1;
t1 = (0:dt1:1-dt1)';
x1 = sin(2*pi*f1*t1);

f2 = 303.1;
fs2 = 32e3;
dt2 = 1/fs2;
t2 = (0:dt2:1-dt2)';
x2 = sin(2*pi*f2*t2);

f3 = 2110.4;
fs3 = 48e3;
dt3 = 1/fs3;
t3 = (0:dt3:1-dt3)';
x3 = sin(2*pi*f3*t3);

% x1_up = zeros(length(x3),1);
% p = 0;
% for i = 1:2:length(x1)
%     x1_up(i+p:i+p+1) = x1(i:i+1);
%     p=p+10;
% end
% 
% x2_up = zeros(length(x3),1);
% p = 0;
% for i = 1:2:length(x2)
%     x2_up(i+p:i+p+1) = x2(i:i+1);
%     p=p+1;
% end
% 
% x4 = x1_up+x2_up+x3;
% figure;
% plot(t3,x4,'b');

L1 = fs3/fs1;  % 6
L2 = 3;    

x1_up = upsample(x1, L1);
x2_up = upsample(x2, L2);



N = 101;  
h1 = fir1(N-1, 1/L1);
h2 = fir1(N-1, 1/L2);

x1_filt = conv(x1_up, h1, 'same');
x2_filt = conv(x2_up, h2, 'same');

x2_final = x2_filt(1:2:end);  % decymacja przez 2

min_len = min([length(x1_filt), length(x2_final), length(x3)]);
x1_final = x1_filt(1:min_len);
x2_final = x2_final(1:min_len);
x3_final = x3(1:min_len);

% Sumowanie
x4 = x1_final + x2_final + x3_final;

% Oczekiwany sygnał
% t = (0:1/fs3:1-1/fs3)';
t = t3;
x4_expected = sin(2*pi*f1*t) + sin(2*pi*f2*t) + sin(2*pi*f3*t);
x4_expected = x4_expected(1:min_len);

% Wykres
figure;
subplot(2,1,1);
plot(x4); title('Sygnał zrekonstruowany (x4)');
subplot(2,1,2);
plot(x4_expected); title('Sygnał oczekiwany (x̄4)');

% % Odsłuch
% sound(x4, fs3);

