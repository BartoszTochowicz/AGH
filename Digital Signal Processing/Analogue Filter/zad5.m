clear all;
close all;
f = 96*10^6;
f1 = 10^6;
passband1 = [f-f1 f+f1];
stopband1 = [f-2*f1 f+2*f1];
Rp = 3;
Rs = 40;
w_pass1 = 2*pi*passband1;
w_stop1 = 2*pi*stopband1;

[N1, Wn1] = ellipord(w_pass1, w_stop1, Rp, Rs, 's');
[b1, a1] = ellip(N1, Rp, Rs, Wn1, 'bandpass', 's');

H1=tf(b1,a1);
freq = linspace(94e6, 98e6, 10000);
w = 2*pi*freq;
Hf1 = freqs(b1,a1,w);
figure;
plot(freq, 20*log10(abs(Hf1)), 'LineWidth', 1.5); hold on;

% Linie pomocnicze
yline(-3, 'r--', 'Pasmo przepustowe', 'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle', 'Color', 'red');
yline(-40, 'k--', 'Pasmo zaporowe', 'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle', 'Color', 'black');

xline(passband1(1), 'g--');
xline(passband1(2), 'g--');

% Opis wykresu
grid on;
title('Charakterystyka testowego filtru (96 MHz ±1 MHz)');
xlabel('Częstotliwość [Hz]');
ylabel('Wzmocnienie [dB]');
xlim([min(freq) max(freq)]);
ylim([-60 5]);

legend('Charakterystyka filtru', 'Location', 'southwest');