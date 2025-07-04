clear all;
close all;
fsx = 400e3;
x1 = audioread("mowa8000.wav");
fc1 = 100e3;
x2 = flipud(x1);
fc2 = 110e3;
fs= 8e3;

dA = 0.25;
% Nadprobkowanie 

x1_up = resample(x1,fsx,fs);
x2_up = resample(x2,fsx,fs);

t = (0:length(x1_up)-1)'/fsx;
% DSB-C
% 1 stacja
y_DSB_C_1 = (1+dA*x1_up).*cos(2*pi*fc1*t);
% 2 stacja
y_DSB_C_2 = (1+dA*x2_up).*cos(2*pi*fc2*t);

% DSB-SC
% 1 stacja
y_DSB_SC_1 = x1_up.*cos(2*pi*fc1*t);
% 2 stacja
y_DSB_SC_2 = x2_up.*cos(2*pi*fc2*t);

% SSB-SC
M = 50;                  % Połowa długości filtra
N = 2*M + 1;             % Długość całkowita
n = -M:M;                % Indeksy próbek
h = (1 - cos(pi*n)) ./ (pi*n); % Definicja
h(M+1) = 0;              % wartość dla n = 0 (bo 0/0)

w = hamming(N)';
h = h .* w;

% 1 stacja
xh1 = filter(h,1,x1_up);
y_SSB_SC_1 = 0.5*x1_up.*cos(2*pi*fc1*t)+0.5*xh1.*sin(2*pi*fc1*t);

% 1 stacja
xh2 = filter(h,1,x2_up);
y_SSB_SC_2 = 0.5*x2_up.*cos(2*pi*fc2*t)-0.5*xh2.*sin(2*pi*fc2*t);


% % SUMOWANIE STACJI
% z_DSB_C = y_DSB_C_1 + y_DSB_C_2;
% z_DSB_SC = y_DSB_SC_1 + y_DSB_SC_2;
% z_SSB_SC = y_SSB_SC_1 + y_SSB_SC_2;
% 
% % FFT – przygotowanie
% N = length(z_DSB_C);
% f = linspace(0, fsx, N);
% Z_DSB_C = abs(fft(z_DSB_C));
% Z_DSB_SC = abs(fft(z_DSB_SC));
% Z_SSB_SC = abs(fft(z_SSB_SC));
% 
% % WIDMO DSB-C
% figure;
% plot(f/1e3, Z_DSB_C);
% title('Widmo sygnału AM – DSB-C');
% xlabel('Częstotliwość [kHz]');
% ylabel('|FFT|');
% xlim([80 130]);
% grid on;
% 
% % WIDMO DSB-SC
% figure;
% plot(f/1e3, Z_DSB_SC);
% title('Widmo sygnału AM – DSB-SC');
% xlabel('Częstotliwość [kHz]');
% ylabel('|FFT|');
% xlim([80 130]);
% grid on;
% 
% % WIDMO SSB-SC
% figure;
% plot(f/1e3, Z_SSB_SC);
% title('Widmo sygnału AM – SSB-SC');
% xlabel('Częstotliwość [kHz]');
% ylabel('|FFT|');
% xlim([80 130]);
% grid on;
% 
% % Demodulacja DSB-C
% d1 = demodulate(y_DSB_C_1,fc1,h);
% d2 = demodulate(y_DSB_C_2,fc2,h);
% % Demodulacja DSB-SC
% d3 = demodulate(y_DSB_SC_1,fc1,h);
% d4 = demodulate(y_DSB_SC_2,fc2,h);
% % Demodulacja SSB-SC
% d5 = demodulate(y_SSB_SC_1,fc1,h);
% d6 = demodulate(y_SSB_SC_2,fc2,h);
% 
% d2 = flipud(d2);
% d4 = flipud(d4);
% d6 = flipud(d6);
% 
% d1 = resample(d1, fs, fsx);
% d2 = resample(d2, fs, fsx);
% d3 = resample(d3, fs, fsx);
% d4 = resample(d4, fs, fsx);
% d5 = resample(d5, fs, fsx);
% d6 = resample(d6, fs, fsx);
% 
% sound(d1, fs); pause;
% sound(d2, fs); pause;
% sound(d3, fs); pause;
% sound(d4, fs); pause;
% sound(d5, fs); pause;
% sound(d6, fs); pause;


y_SSB_SC_1_new = 0.5*x1_up.*cos(2*pi*fc1*t)+0.5*xh1.*sin(2*pi*fc1*t);

y_SSB_SC_2_new = 0.5*x2_up.*cos(2*pi*fc1*t)-0.5*xh2.*sin(2*pi*fc1*t);

z_SSB_SC_new = y_SSB_SC_1_new + y_SSB_SC_2_new;
% WIDMO SSB-SC
% FFT – przygotowanie
N_new = length(z_SSB_SC_new);
f_new = linspace(0, fsx, N_new);

Z_SSB_SC_new = abs(fft(z_SSB_SC_new));
figure;
plot(f_new/1e3, Z_SSB_SC_new);
title('Widmo sygnału AM – SSB-SC');
xlabel('Częstotliwość [kHz]');
ylabel('|FFT|');
xlim([80 130]);
grid on;

d5_new = demodulate(y_SSB_SC_1_new,fc1,h);
d6_new = demodulate(y_SSB_SC_2_new,fc1,h);

d6_new = flipud(d6_new);

d5_new = resample(d5_new, fs, fsx);
d6_new = resample(d6_new, fs, fsx);

sound(d5_new, fs); pause;
sound(d6_new, fs); 