clear all;
close all;
w3dB = 2*pi*100;
N = [2,4,6,8];
% freq = linspace(0,1000,1000);
freq = 0:1:1000;
omega = 2*pi*freq;
figure;

% Charakterystyki amplitudowe - skala liniowa
subplot(2,2,1);
hold on;
title('Charakterystyka amplitudowa (skala liniowa)');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid on;

% Charakterystyki amplitudowe - skala logarytmiczna
subplot(2,2,2);
hold on;
title('Charakterystyka amplitudowa (skala logarytmiczna)');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
set(gca, 'XScale', 'log');
grid on;

% Charakterystyka fazowa
subplot(2,2,[3,4]);
hold on;
title('Charakterystyka fazowa');
xlabel('Częstotliwość [Hz]');
ylabel('Faza [rad]');
grid on;
hold on;
for n = N
    pk = zeros(1,n);
    for k = 1:n
        pk(1,k) = w3dB*exp(1i*(pi/2 + 0.5*pi/n+(k-1)*pi/n));
    end
    [B,A] = zp2tf(zeros(1,n)',pk,1);
    H=tf(B,A);
    H_freq = freqs(B,A,omega);
    magH = 20*log10(abs(H_freq));
    phase = angle(H_freq);
    
    subplot(2,2,1);
    plot(freq, magH, 'DisplayName', ['N = ' num2str(n)], 'LineWidth', 1.5);
    
    subplot(2,2,2);
    plot(freq, magH, 'DisplayName', ['N = ' num2str(n)], 'LineWidth', 1.5);

    subplot(2,2,[3,4]);
    plot(freq, phase, 'DisplayName', ['N = ' num2str(n)], 'LineWidth', 1.5);
    
    % Zapamiętujemy filtr N=4 do analizy czasowej
    if n == 4
        H4 = H;
    end
end
subplot(2,2,1);
legend;
subplot(2,2,2);
legend;
subplot(2,2,[3,4]);
legend;

% Odpowiedź impulsowa i skokowa dla N = 4
figure;

subplot(2,1,1);
impulse(H4);
title('Odpowiedź impulsowa filtru Butterwortha N = 4');

subplot(2,1,2);
step(H4);
title('Odpowiedź skokowa filtru Butterwortha N = 4');