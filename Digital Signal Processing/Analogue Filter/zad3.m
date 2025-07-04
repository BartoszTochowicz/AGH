clear all;
close all;
clc;

% Parametry
fs = 256e3; % [Hz] - częstotliwość próbkowania
fp = 64e3; % [Hz] - częstotliwość graniczna przepustowa
fsb = fs / 2; % [Hz] - częstotliwość graniczna zaporowa
Ap = 3; % [dB] - maksymalne zafalowanie w paśmie przepustowym
As = 40; % [dB] - minimalne tłumienie w paśmie zaporowym

% Przekształcamy na pulsacje (rad/s)
wp = 2 * pi * fp;
ws = 2 * pi * fsb;

% Zakres częstotliwości do rysowania charakterystyk
f = logspace(3, 6, 1000); % od 1 kHz do 1 MHz
w = 2 * pi * f;

% Filtry do porównania
filter_types = {'Butterworth', 'Chebyshev I', 'Chebyshev II', 'Elliptic'};

% Kolory wykresów
colors = {'b', 'r', 'g', 'm'};

figure;
subplot(2,1,1);
hold on;
title('Charakterystyka amplitudowa filtrów');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid on;

subplot(2,1,2);
hold on;
title('Charakterystyka fazowa filtrów');
xlabel('Częstotliwość [Hz]');
ylabel('Faza [rad]');
grid on;

figure;
hold on;
title('Rozkład biegunów i zer');
xlabel('Re(s)');
ylabel('Im(s)');
grid on;

for i = 1:length(filter_types)
    filter_type = filter_types{i};
    
    switch filter_type
        case 'Butterworth'
            [N, Wn] = buttord(wp, ws, Ap, As, 's');
            [b, a] = butter(N, Wn, 's');
            
        case 'Chebyshev I'
            [N, Wn] = cheb1ord(wp, ws, Ap, As, 's');
            [b, a] = cheby1(N, Ap, Wn, 's');
            
        case 'Chebyshev II'
            [N, Wn] = cheb2ord(wp, ws, Ap, As, 's');
            [b, a] = cheby2(N, As, Wn, 's');
            
        case 'Elliptic'
            [N, Wn] = ellipord(wp, ws, Ap, As, 's');
            [b, a] = ellip(N, Ap, As, Wn, 's');
    end
    
    H = tf(b, a);

    % Bieguny i zera
    figure(2);
    pzmap(H);
    plot(0, 0, 'ko'); % punkt zero
    title('Rozkład biegunów i zer');

    % Odpowiedź częstotliwościowa
    [mag, phase] = bode(H, w);
    mag = squeeze(20*log10(mag));
    phase = squeeze(phase) * pi / 180; % stopnie na radiany

    figure(1);
    subplot(2,1,1);
    semilogx(f, mag, 'Color', colors{i}, 'DisplayName', [filter_type ' (N=' num2str(N) ')'], 'LineWidth', 1.5);
    
    subplot(2,1,2);
    semilogx(f, phase, 'Color', colors{i}, 'DisplayName', [filter_type ' (N=' num2str(N) ')'], 'LineWidth', 1.5);
end

figure(1);
subplot(2,1,1);
legend;
subplot(2,1,2);
legend;
