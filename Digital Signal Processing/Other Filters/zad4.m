clear all;
close all;
load("lab08_fm.mat"); 

% Parametry
fc = 200e3;         
fs = 2e6;           
M = 250;            
N = 2*M + 1;

% Filtr różniczkujący (cos(pi*n)/n * okno Kaisera)
n = -M:M;
hD = cos(pi*n) ./ n;
hD(M+1) = 0;  % wartość w n = 0
w = kaiser(N, 8)';
hD = hD .* w;

f_low = 100e3 / (fs/2);
f_high = 300e3 / (fs/2);
hBP = fir1(N-1, [f_low f_high], 'bandpass', kaiser(N, 8));

% Filtr różniczkujący pasmowo-przepustowy = splot
h = conv(hD, hBP);

y = filter(h, 1, x);

% Obwiednia
y = y.^2;

hLP = fir1(N-1, 8e3/(fs/2), 'low', kaiser(N, 8));
y = filter(hLP, 1, y);

y = sqrt(y);

% Resampling (do 8 kHz)
y = resample(y, 8000, fs); 

% Odsłuch i wykres
soundsc(real(y), 8000);
t = (0:length(y)-1)/8000;
figure;
plot(t, y);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Zdemodulowany sygnał mowy (FM)');