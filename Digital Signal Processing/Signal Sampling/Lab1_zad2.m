clear all;
close all;

stopTime = 1;
fs3 = 200; % Częstotliwość próbkowania
fs_analogowy = 10000; % Wysoka częstotliwość próbkowania (analogowa)
f = 1; % Częstotliwość sygnału
T = 1/fs3; % Okres próbkowania

t3 = 0:1/fs3:stopTime; % Oś czasu dla próbek
t_analogowy = 0:1/fs_analogowy:stopTime; % Oś czasu dla sygnału analogowego

x3 = sin(2*pi*f*t3); % Próbkowany sygnał

% Rekonstrukcja sygnału z próbek przy użyciu sinc
xhat = zeros(size(t_analogowy));

for idx = 1:length(t_analogowy)
    t = t_analogowy(idx);
    xhat(idx) = 0;
    for n = 1:length(t3)
       a = pi/T*(t - (n-1)*T);
       sc = 1;
       if a ~= 0
           sc = sin(a)/a; % Funkcja sinc
       end
       xhat(idx) = xhat(idx) + x3(n) * sc;
    end
end

x_analog = sin(2*pi*f*t_analogowy); % Oryginalny sygnał analogowy

% Obliczanie błędu rekonstrukcji
error = x_analog - xhat;
MAE = mean(abs(error)); % Średni błąd bezwzględny
MSE = mean(error.^2); % Błąd średniokwadratowy

% Rysowanie wykresów
figure;
hold on;
plot(t_analogowy, x_analog, 'b-', 'LineWidth', 1.5); % Oryginalny sygnał
plot(t_analogowy, xhat, 'g--', 'LineWidth', 1.5); % Zrekonstruowany sygnał
stem(t3, x3, 'ro', 'MarkerSize', 5); % Punkty próbkowania
legend('Pseudo analogowy', 'Zrekonstruowany', 'Próbki (fs3=200 Hz)');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
title('Rekonstrukcja sygnału za pomocą sinc(x)');
grid on;
hold off;

% Wykres błędu rekonstrukcji
figure;
plot(t_analogowy, error, 'k', 'LineWidth', 1.2);
xlabel('Czas [s]');
ylabel('Błąd rekonstrukcji');
title(['Błąd rekonstrukcji, MAE = ', num2str(MAE), ', MSE = ', num2str(MSE)]);
grid on;
