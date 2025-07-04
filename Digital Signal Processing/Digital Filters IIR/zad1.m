clear all;
close all;
load('butter.mat');
f1 = 1189;
f2 = 1229;
fpr = 16000;
f = 0:1:fpr/2;
[b_a, a_a] = zp2tf(z, p, k);
b = k*poly(z); a = poly(p); % zera & bieguny analogowe --> wspolczynniki [b,a]
w = 2*pi*f;
H_analog = freqs(b,a,w);

[zz,pp,gain] = bilinearMY(z,p,k,fpr); % funkcja biliearMY() NASZA
b_d = real( gain*poly(zz) ); a_d = real( poly(pp) ); % zera & bieguny cyfrowe --> wsp. [b,a]
% fvtool(b_d,a_d), 
H_digital = freqz(b_d,a_d,f,fpr);
figure;
plot(f, 20*log10(abs(H_analog)), 'b', 'LineWidth', 1.5); hold on;
plot(f, 20*log10(abs(H_digital)), 'r--', 'LineWidth', 1.5);
xline(1189, 'k--', 'LineWidth', 1);
xline(1229, 'k--', 'LineWidth', 1);
legend('Analogowy H(s)', 'Cyfrowy H(z)', 'Lokalizacja f_g');
xlabel('Częstotliwość [Hz]');
ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa: analogowy vs cyfrowy filtr');
grid on;

T = 1;
t = 0:1/fpr:T-1/fpr;
fh1 = 1209; fh2 = 1272;
x = sin(2*pi*fh1*t)+sin(2*pi*fh2*t);
y = zeros(1,length(x));
for n = 1:length(x)
    for k = 0:min(n-1,length(b_d)-1)
        y(n) = y(n)+b_d(k+1)*x(n-k);
    end
    for k = 1:min(n-1,length(a_d)-1)
        y(n) = y(n)-a_d(k+1)*y(n-k);
    end
end
y_filter = filter(b_d,a_d,x);
figure;
plot(t, x, 'k');
figure;
plot( t, y, 'b');
figure;
plot( t, y_filter, 'r');

N = 2048;
f_fft = (0:N/2-1)*(fpr/N);
X = abs(fft(x, N));
Y1 = abs(fft(y, N));
Y2 = abs(fft(y_filter, N));

figure;
plot(f_fft, 20*log10(X(1:N/2)), 'k--'); hold on;
plot(f_fft, 20*log10(Y1(1:N/2)), 'b');
% plot(f_fft, 20*log10(Y2(1:N/2)), 'r');
legend('Oryginalny', 'Własna filtracja', 'filter()');
title('Porównanie w dziedzinie częstotliwości');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda [dB]');
grid on;