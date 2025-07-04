clear all; close all;

fpr = 2000;  % częstotliwość próbkowania [Hz]
gain = 1;

% --- ZERA: Umieszczone w zakresie wysokich częstotliwości, blisko 1 (osłabienie powyżej 200 Hz) ---
z = [1 1] .* exp(1j * 2 * pi * [400, 700]/fpr);
z = [z conj(z)];  % dodaj sprzężone zespolone, by zachować rzeczywiste współczynniki

% --- BIEGUNY: Blisko okręgu jednostkowego w niskich częstotliwościach (~50–90 Hz) ---
p = [0.98 0.98] .* exp(1j * 2 * pi * [50, 90]/fpr);
p = [p conj(p)];

% --- Współczynniki wielomianów ---
b = gain * poly(z);
a = poly(p);

% --- Wykresy charakterystyk ---
f = 0 : 0.1 : 1000;         % częstotliwości [Hz]
wn = 2*pi*f/fpr;            % częstotliwość kątowa
zz = exp(-1j * wn);         % z = e^{-jω}
H = polyval(b(end:-1:1), zz) ./ polyval(a(end:-1:1), zz);

% --- Charakterystyka amplitudowa ---
figure; plot(f, 20*log10(abs(H)));
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa |H(f)|');
grid on; 

% --- Charakterystyka fazowa ---
figure; plot(f, unwrap(angle(H)));
xlabel('f [Hz]'); ylabel('Faza [rad]');
title('Charakterystyka fazowa ∠H(f)');
grid on;

% --- Wykres zer i biegunów ---
figure;
alfa = 0 : pi/1000 : 2*pi;
plot(cos(alfa), sin(alfa), 'k--'); hold on; axis equal;
plot(real(z), imag(z), 'bo', 'MarkerSize',10, 'DisplayName','Zera');
plot(real(p), imag(p), 'r*', 'MarkerSize',10, 'DisplayName','Bieguny');
xlabel('Re'); ylabel('Im'); title('Zera i bieguny filtra'); grid on; legend;
