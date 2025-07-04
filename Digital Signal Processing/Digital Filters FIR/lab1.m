clear all;
close all;

fpr = 1200; % częstotliwość próbkowania
df = 200;   % szerokość pasma przepustowego
fc = 300;   % częstotliwość środkowa pasma przepustowego

f1 = fc - df/2;
f2 = fc + df/2;

M =64;
N = 2*M+1; % rząd filtra

% Okna
w1 = rectwin(N);
w2 = hann(N);
w3 = hamming(N);
w4 = blackman(N);
w5 = blackmanharris(N);

windows = {w1, w2, w3, w4, w5};
windows_names = {'Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris'};

b = zeros(5, N);

% Projektowanie filtrów
for i = 1:5
    b(i,:) = fir1(N-1, [f1 f2]/(fpr/2), "bandpass", windows{i});
end

% Odpowiedzi częstotliwościowe - UWAGA: tutaj poprawnie
num_points = 4096; % gęsta siatka
f = linspace(0, fpr/2, num_points); % częstotliwość w Hz
H = zeros(5, num_points);

for n = 1:5
    [H(n,:), freq] = freqz(b(n,:), 1, num_points, fpr);
end

% Rysowanie wykresów
figure;
hold on; grid on;
colors = ['b', 'r', 'g', 'm', 'k'];
for n = 1:5
    plot(freq, 20*log10(abs(H(n,:))), 'Color', colors(n), 'DisplayName', windows_names{n});
end
xlabel('f [Hz]');
ylabel('|H(f)| [dB]');
title('Charakterystyki amplitudowe dla różnych okien');
legend('show');
ylim([-100 5]);
xlim([0 600]);
hold off;



% --- Tłumienie ---
attenuation_db = zeros(5,1);

% pasmo zaporowe: <f1-100 lub >f2+100
stopband_mask = (freq < (f1-100)) | (freq > (f2+100)); 

fprintf('Poziomy tłumienia w paśmie zaporowym:\n');
for n = 1:5
    max_in_stopband = max(abs(H(n,stopband_mask)));
    attenuation_db(n) = 20*log10(max_in_stopband);
    fprintf('%s window: %.2f dB\n', windows_names{n}, attenuation_db(n));
end

% Parametry
Nx = 1200;
dt = 1/fpr;
t = (0:Nx-1)*dt;
fx1 = 350;
fx2 = 550;

x = sin(2*pi*fx1*t) + sin(2*pi*fx2*t);

% Przygotowanie do FFT
f0 = fpr/Nx; % rozdzielczość widmowa
f = (0:Nx/2-1)*f0; % częstotliwości dla połowy FFT

% Widmo sygnału przed filtracją
X = fft(x);
X_magnitude = 2*abs(X(1:Nx/2))/(Nx);

figure;
plot(f, 20*log10(X_magnitude));
grid on;
xlabel('f [Hz]');
ylabel('|X(f)| [dB]');
title('Widmo sygnału przed filtracją');
ylim([-80 10]);
xlim([0 600]);

% --- Filtracja i widma po filtracji ---
y = zeros(5,Nx);

for i = 1:5
    y(i,:) = filter(b(i,:),1,x);
    
    Y = fft(y(i,:));
    Y_magnitude = 2*abs(Y(1:Nx/2))/Nx;

    figure;
    plot(f, 20*log10(Y_magnitude));
    grid on;
    xlabel('f [Hz]');
    ylabel('|Y(f)| [dB]');
    title(['Widmo sygnału po filtracji: ' windows_names{i}]);
    ylim([-80 10]);
    xlim([0 600]);
end