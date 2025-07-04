clear all;
close all;

[x, fs] = audioread("s4.wav");
t = 0:1/fs:(length(x)-1)/fs;
plot(t, x); title('Sygnał DTMF');

fw = [697,770,852,941];         % dolne (wiersze)
fk = [1209,1336,1477];          % górne (kolumny)
keys = ['1','2','3';
        '4','5','6';
        '7','8','9';
        '*','0','#'];

N = 5;                         % liczba cyfr
L = length(x);
frame_len = floor(L/N);
frames = reshape(x(1:frame_len*N), frame_len, N);

digits = '';
f_axis = (0:frame_len-1)*fs/frame_len;
for i = 1:N
    Xf = abs(fft(frames(:, i)));
    Xf = Xf(1:frame_len/2);
    f = f_axis(1:frame_len/2);
    
    % DOLNE tony
    Xf_row = Xf;
    Xf_row(~(f >= 650 & f <= 1000)) = 0;
    [~, idx_row] = max(Xf_row);
    freq_row = f(idx_row);
    [~, row_idx] = min(abs(fw - freq_row));
    
    % GÓRNE tony
    Xf_col = Xf;
    Xf_col(~(f >= 1150 & f <= 1550)) = 0;
    [~, idx_col] = max(Xf_col);
    freq_col = f(idx_col);
    [~, col_idx] = min(abs(fk - freq_col));

    digits = [digits, keys(row_idx, col_idx)];
end


disp(['Rozpoznany kod: ', digits]);
spectrogram( x, 4096, 4096-512, [0:5:2000], fs );

load('butter.mat');
f = 0:1:fs/2;
[b_a, a_a] = zp2tf(z, p, k);
b = k*poly(z); a = poly(p); % zera & bieguny analogowe --> wspolczynniki [b,a]
w = 2*pi*f;

[zz,pp,gain] = bilinearMY(z,p,k,fs); % funkcja biliearMY() NASZA
b_d = real( gain*poly(zz) ); a_d = real( poly(pp) ); % zera & bieguny cyfrowe --> wsp. [b,a]
% fvtool(b_d,a_d), 

y = zeros(1,length(x));
for n = 1:length(x)
    for k = 0:min(n-1,length(b_d)-1)
        y(n) = y(n)+b_d(k+1)*x(n-k);
    end
    for k = 1:min(n-1,length(a_d)-1)
        y(n) = y(n)-a_d(k+1)*y(n-k);
    end
end

figure;
subplot(2,1,1);
spectrogram(x, 4096, 4096-512, 0:5:2000, fs, 'yaxis');
title('Spektrogram oryginalny');

subplot(2,1,2);
spectrogram(y, 4096, 4096-512, 0:5:2000, fs, 'yaxis');
title('Spektrogram po filtracji');

figure;
plot(t, x, 'b'); hold on;
plot(t, y, 'r');
xlabel('Czas [s]');
ylabel('Amplituda');
legend('Oryginalny', 'Po filtracji');
title('Porównanie sygnałów w czasie');
grid on;

delay = round(mean(grpdelay(b_d, a_d, 512))); % estymacja opóźnienia
y_aligned = [y(delay+1:end), zeros(1, delay)]; % przesunięcie

figure;
plot(t, x, 'b'); hold on;
plot(t, y_aligned, 'r');
xlabel('Czas [s]');
ylabel('Amplituda');
legend('Oryginalny', 'Po filtracji (skompensowany)');
title('Sygnał z kompensacją opóźnienia');
grid on;