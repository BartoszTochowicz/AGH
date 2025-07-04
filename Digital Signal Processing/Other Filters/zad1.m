clear all;
close all;
load("lab08_am.mat");
x = s4;
fs = 1000;
fc = 200;
T = 1;
t = 0:1/fs:T;

% M = 50;
% win = hamming(M+1);
% h = zeros(1, M+1);
% for n = 1:M+1
%     k = n - (M+1)/2;
%     if mod(k,2)==1
%         h(n) = 2/(pi*k);
%     else
%         h(n) = 0;
%     end
% end
% h = h .* win(:)'; % zastosuj okno
% h = h .* win(:)'; % zastosuj okno
M = 50;                  % Połowa długości filtra
N = 2*M + 1;             % Długość całkowita
n = -M:M;                % Indeksy próbek
h = (1 - cos(pi*n)) ./ (pi*n); % Definicja
h(M+1) = 0;              % wartość dla n = 0 (bo 0/0)

w = hamming(N)';
h = h .* w;

xh = filter(h,1,x);

x_sync = x(M+1 : end-M);              % x(n)
xH_sync = xh(2*M+1 : end); 

env = sqrt(x_sync.^2 + xH_sync.^2);
Ne = length(env);

% Wykres obwiedni:
figure;
plot(1:Ne, env, 'r', 1:Ne, x_sync, 'k');
legend('Obwiednia (m(t))', 'Sygnał x');
title('Demodulacja AM – obwiednia sygnału');
grid on;

ENV = abs(fft(env));
ENV = ENV / max(ENV);
f = (0:floor(Ne/2)) * fs / Ne;

% Wykres
figure;
plot(f, ENV(1:floor(Ne/2)+1));
title('Widmo obwiedni (m(t))');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda (znormalizowana)');
grid on;

t_env = (0:length(x_sync)-1)/fs;
A1 = 0.163942; F1 = 6.67;
A2 = 0.188731; F2 = 30;
A3 = 0.2888849; F3 = 50;

m = 1 + A1*cos(2*pi*F1*t_env)+A2*cos(2*pi*F2*t_env)+A3*cos(2*pi*F3*t_env);
x_reconstructed = m.*cos(2*pi*fc*t_env);


figure;
plot(t_env, x_sync, 'k', t_env, x_reconstructed, 'r--');
legend('Oryginalny sygnał x', 'Odtworzony sygnał x');
title('Porównanie oryginalnego i odtworzonego sygnału AM');
xlabel('Czas [s]');
grid on;

% Obliczenie błędu MSE
mse_error = mean((x_sync - x_reconstructed).^2);
fprintf('Średni błąd kwadratowy (MSE) = %.6f\n', mse_error);

% ENV = abs(fft(env));
% ENV = ENV / max(ENV);  % Normalizacja
% 
% % Oblicz częstotliwości
% f = (0:floor(Ne/2)) * fs / Ne;
% ENV_half = ENV(1:floor(Ne/2)+1);
% 
% % Ignoruj DC (pierwszy element)
% ENV_half(1:2) = 0;
% 
% % Znajdź 3 największe piki w widmie (czyli częstotliwości f1, f2, f3)
% [peak_values, peak_indices] = maxk(ENV_half, 3);
% 
% % Posortuj rosnąco według częstotliwości
% [peak_freqs_sorted, sort_idx] = sort(f(peak_indices));
% peak_amps_sorted = peak_values(sort_idx);
% 
% % Przypisz do nazwanych zmiennych
% f1 = peak_freqs_sorted(1);
% f2 = peak_freqs_sorted(2);
% f3 = peak_freqs_sorted(3);
% 
% A1 = peak_amps_sorted(1);
% A2 = peak_amps_sorted(2);
% A3 = peak_amps_sorted(3);
% 
% % Wyświetlenie wyników
% fprintf('f1 = %.2f Hz, A1 = %.3f\n', f1, A1);
% fprintf('f2 = %.2f Hz, A2 = %.3f\n', f2, A2);
% fprintf('f3 = %.2f Hz, A3 = %.3f\n', f3, A3);
% 
% % Wykres
% figure;
% plot(f, ENV_half);
% hold on;
% stem(peak_freqs_sorted, peak_amps_sorted, 'r', 'LineWidth', 1.5);
% title('Widmo obwiedni z oznaczonymi pikami');
% xlabel('Częstotliwość [Hz]');
% ylabel('Znormalizowana amplituda');
% grid on;
