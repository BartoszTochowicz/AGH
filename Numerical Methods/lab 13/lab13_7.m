clear all; close all;
format long;

N = 10^6; % liczba prób
Nk = 0; % liczba trafień w koło

% Generowanie punktów za pomocą sekwencji Sobola
sobol = sobolset(2, 'Skip', 1e3, 'Leap', 2e2); % sekwencja Sobola w 2 wymiarach
points = net(sobol, N); % generowanie punktów Sobola

% Przekształcenie na zakres [-1, 1]
x = 2 * points(:, 1) - 1; % współrzędne x
y = 2 * points(:, 2) - 1; % współrzędne y

% Obliczenie liczby trafień w koło
Nk = sum(sqrt(x.^2 + y.^2) <= 1);

% Obliczenie wartości pi
mypi = 4 * Nk / N;

% Obliczenia z wyższą precyzją
pi_estimate = vpa(mypi, 50); % 50 cyfr znaczących
pi_vpa = vpa(pi, 50); % π również w wysokiej precyzji

disp('Wynik z bardzo wysoką precyzją:');
disp(pi_estimate);

disp('Różnica względem wartości rzeczywistej:');
difference = abs(pi_estimate - pi_vpa);
disp(difference)
N = 100000; % liczba strzalow
Nk = 0; % liczba trafien w kolo
for i = 1 : N % PETLA: kolejne strzaly
x = rand(1,1)*2.0 - 1.0; % # kwadrat o boku 2
y = rand(1,1)*2.0 - 1.0; % #
if( sqrt( x*x + y*y ) <= 1.0) % kolo o promieniu 1
Nk = Nk + 1; % zwieksz liczbe trafien o 1
end %
end %
pi; % dokladne pi
mypi = 4.0 * Nk / N; % obliczone pi
xy = 2*rand(N,2)-1.0;
Nk = numel( find( sqrt(xy(:,1).^2 + xy(:,2).^2) <= 1 ) );
disp('Różnica względem wartości rzeczywistej:');
difference1 = abs(pi - mypi);
disp(difference1)
if difference1>difference
    abs(difference-difference1)
end