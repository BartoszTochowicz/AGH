clear all;
close all;
[x,fs] = audioread("mowa.wav");
figure
plot(x);
title('Oryginalny sygnał mowy');
xlabel('Numer próbki');
ylabel('Amplituda');
% soundsc(x,fs);
c=dct(x);
figure
stem(c);
title('Współczynniki DCT');
xlabel('Indeks');
ylabel('Amplituda');

N = length(c);

c1 = [c(1:round(0.25*N));zeros(N-round(0.25*N),1)];
y1 = idct(c1);

c2 = [zeros(N-round(0.75*N),1);c(end-round(0.75*N)+1:end)];
y2 = idct(c2);

% disp('Odsłuch - 25% współczynników:');
% soundsc(y1, fs);
% pause(5);
% disp('Odsłuch - 75% współczynników:');
% soundsc(y2, fs);

c3 = c;
c3(abs(c3)<50) = 0;
y3 = idct(c3);

% c4 = c;
% c4(100:200) = 0;
% y4 = idct(c4);
% soundsc(y3, fs);
% pause(5);
% soundsc(y4, fs);

x_noisy = x+0.2*sin(2*pi*250/fs*(0:length(x)-1)');
figure
plot(x_noisy);
% soundsc(x_noisy,fs);

% c_noisy = dct(x_noisy);
% figure
% stem(c_noisy);
% title('Współczynniki DCT sygnału z zakłóceniem');
% 
% % Rekonstrukcja sygnału
% idx = round(250/fs*N);
% c_noisy(idx) = 0;
% c_noisy(N-idx+1) = 0;
% x_clean = idct(c_noisy);
% 
% figure;
% plot(x_clean);
% title('Sygnał po usunięciu zakłócenia');
% 
% disp('Odsłuch - sygnał po usunięciu zakłócenia:');
% % soundsc(x_clean, fs);