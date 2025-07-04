clear all; close all; clc;

fpr = 2000;               % Częstotliwość próbkowania [Hz]
dt = 1/fpr;               % Okres próbkowania
Nx = fpr;                 % Liczba próbek = 1 sekunda
t = dt*(0:Nx-1);          % Wektor czasu

% Parametry modulacji
A = 10;                   % Stała amplituda nośna
kA = 0.5; fA = 2;         % Głębokość i częstotliwość AM
xA = A * (1 + kA * sin(2*pi*fA*t));  % Obwiednia AM

kF = 250; fF = 1;         % Głębokość i częstotliwość FM
xF = kF * sin(2*pi*fF*t); % Część FM

fc = 500;                 % Częstotliwość nośna
x = xA .* sin(2*pi*(fc*t + cumsum(xF)*dt));  % Sygnał AM-FM

xa = hilbert(x);          % Transformacja Hilberta (sygnał analityczny)
xAest = abs(xa);          % Estymacja amplitudy (modulacja AM)
ph = unwrap(angle(xa));   % Estymacja fazy (kąt fazowy)

% Estymacja częstotliwości chwilowej (pochodna kąta fazowego)
xFest = (1/(2*pi)) * (ph(3:end) - ph(1:end-2)) / (2*dt);

% === Wykresy ===
figure;
plot(t, xA, 'r-', t, xAest, 'b--'); grid on;
title('Demodulacja AM: Rzeczywista vs Szacowana Obwiednia');
legend('Rzeczywista x_A(t)', 'Szacowana |xa(t)|');

figure;
plot(t, xF, 'r-', t(2:Nx-1), xFest - fc, 'b--'); grid on;
title('Demodulacja FM: Rzeczywista vs Szacowana chwilowa czestotliwość');
legend('Rzeczywista x_F(t)', 'Szacowana f_{inst}(t)-f_c');

error_AM = xAest - xA;
error_FM = xFest - fc - xF(2:Nx-1);

figure;
subplot(2,1,1);
plot(t, error_AM); grid on;
title('Błąd demodulacji AM');

subplot(2,1,2);
plot(t(2:Nx-1), error_FM); grid on;
title('Błąd demodulacji FM');

M = 60;                    % Rząd filtra Hilberta (parzysty!)
win = hamming(M+1);        % Okno Hamminga
h = firhilb(M, win);       % Własna funkcja - definicja niżej

% Wykres wag filtra
figure;
stem(0:M, h); grid on;
title('Wagi filtra Hilberta');

% Charakterystyka częstotliwościowa
[H,f] = freqz(h,1,1024, fpr);
figure;
subplot(2,1,1);
plot(f, abs(H)); grid on;
title('Charakterystyka amplitudowa filtra Hilberta');

subplot(2,1,2);
plot(f, unwrap(angle(H))); grid on;
title('Charakterystyka fazowa filtra Hilberta');

% Spróbuj różnych wartości kF i obserwuj rosnący błąd FM:
kF_values = [100, 200, 300, 400, 500];
for i = 1:length(kF_values)
    kF = kF_values(i);
    xF = kF * sin(2*pi*fF*t);
    x = xA .* sin(2*pi*(fc*t + cumsum(xF)*dt));
    xa = hilbert(x);
    ph = unwrap(angle(xa));
    xFest = (1/(2*pi)) * (ph(3:end) - ph(1:end-2)) / (2*dt);
    error_FM = xFest - fc - xF(2:Nx-1);

    figure;
    plot(t(2:Nx-1), error_FM); grid on;
    title(['Błąd FM dla kF = ', num2str(kF)]);
end

function h = firhilb(M, win)
    % M = rząd filtra (parzysty!), win = wektor okna np. hamming(M+1)
    h = zeros(1, M+1);
    for n = 1:M+1
        k = n - (M+1)/2;
        if mod(k,2)==1
            h(n) = 2/(pi*k);
        else
            h(n) = 0;
        end
    end
    h = h .* win(:)'; % zastosuj okno
end
