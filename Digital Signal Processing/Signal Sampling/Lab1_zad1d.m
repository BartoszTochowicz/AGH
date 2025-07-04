clear all;
close all;
T = 1;
fpr = 10000;
fn = 50;
fm = 1;
df = 5;
t = 0:1/fpr:T;
m_t = sin(2*pi*fm*t);
y_t = sin(2*pi*fn*t+2*pi*df*cumsum(m_t)/fpr);
% Wykres sygna³u modulowanego i moduluj¹cego
figure;
subplot(2,1,1);
plot(t, m_t, 'r'); hold on;
plot(t, y_t, 'b');
legend('Sygna³ moduluj¹cy', 'Sygna³ FM');
title('Sygna³ moduluj¹cy i zmodulowany');
xlabel('Czas [s]'); ylabel('Amplituda'); grid on;

fs2 = 25;
t2 = 0:1/fs2:T;
y_t2 = sin(2*pi*fn*t2+2*pi*df*cumsum(sin(2*pi*fm*t2)/fs2));
% Wykres porównania sygna³u analogowego i próbkowanego
subplot(2,1,2);
plot(t, y_t, 'b'); hold on;
stem(t2, y_t2, 'r');
legend('Sygna³ analogowy', 'Sygna³ próbkowany');
title('Porównanie sygna³u analogowego i próbkowanego');
xlabel('Czas [s]'); ylabel('Amplituda'); grid on;
% Obliczenie b³êdów próbkowania
errors = interp1(t2, y_t2, t, 'nearest', 'extrap') - y_t;

% Wykres b³êdów próbkowania
figure;
plot(t, errors, 'k');
title('B³êdy spowodowane próbkowaniem');
xlabel('Czas [s]'); ylabel('B³¹d'); grid on;
% Widma gêstoœci mocy przed i po próbkowaniu
figure;
subplot(2,1,1);
pspectrum(y_t, fpr);
title('Widmo gêstoœci mocy sygna³u przed próbkowaniem');

subplot(2,1,2);
pspectrum(y_t2, fs2);
title('Widmo gêstoœci mocy sygna³u po próbkowaniu');