clear all;
close all;

[x, fs] = audioread("DontWorryBeHappy.wav");
x = x(:,1); 

N = 32;       % rozmiar okna
hop = N/2;    % przesunięcie okna (overlap 50%)

% Okno analizy/syntezy (sinus)
n = 0:N-1;
h = sin(pi*(n + 0.5)/N)';


A = zeros(N/2, N);
for k = 1:N/2
    for m = 1:N
        A(k,m) = sqrt(4/N) * cos((2*pi/N)*(k-0.5)*(m-0.5 + N/4));
    end
end
S = A'; 


x = [zeros(hop,1); x; zeros(hop,1)];
L = length(x);
nFrames = floor((L - N) / hop) + 1;

Xmdct = zeros(N/2, nFrames);
y = zeros(L,1);

% Kodowanie MDCT
for iFrame = 1:nFrames
    idx = (iFrame-1)*hop + (1:N);
    xw = x(idx) .* h;
    Xmdct(:,iFrame) = A * xw;
end

% Dekodowanie MDCT
for iFrame = 1:nFrames
    idx = (iFrame-1)*hop + (1:N);
    xw = S * Xmdct(:,iFrame);
    y(idx) = y(idx) + xw .* h;
end

% Normalizacja i odsłuch
y = y / max(abs(y));
sound(y, fs);

% Wykresy
figure;
subplot(2,1,1); plot(x); title('Sygnał wejściowy (z dopełnieniem)');
subplot(2,1,2); plot(y); title('Sygnał po rekonstrukcji MDCT');
