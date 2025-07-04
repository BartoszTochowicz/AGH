clear all; close all; clc;
format long;

% Parametry systemu
N_bits = 10^7; % liczba bitów do przesłania
Eb_N0_dB = 0:1:10; % zakres wartości Eb/N0 w dB
BER = zeros(size(Eb_N0_dB)); % tablica do przechowywania BER

% Symulacja Monte Carlo dla każdego Eb/N0
for idx = 1:length(Eb_N0_dB)
    % Konwersja Eb/N0 z dB na wartość liniową
    Eb_N0_lin = 10^(Eb_N0_dB(idx) / 10);
    
    % Wyznaczenie odchylenia standardowego szumu (sigma)
    sigma = sqrt(1 / (2 * Eb_N0_lin));
    
    % Generowanie losowych bitów (0 lub 1)
    bits_tx = randi([0, 1], 1, N_bits);
    
    % Mapowanie bitów na symbole BPSK (0 -> -1, 1 -> +1)
    symbols_tx = 2 * bits_tx - 1;
    
    % Dodanie szumu Gaussa
    noise = sigma * randn(1, N_bits);
    symbols_rx = symbols_tx + noise;
    
    % Decyzja detektora (prosty próg: 0)
    bits_rx = symbols_rx > 0;
    
    % Liczba błędów
    num_errors = sum(bits_tx ~= bits_rx);
    
    % Współczynnik błędów BER
    BER(idx) = num_errors / N_bits;
end

% Porównanie z teoretycznym BER dla BPSK w AWGN
Eb_N0_lin = 10.^(Eb_N0_dB / 10);
BER_theoretical = qfunc(sqrt(2 * Eb_N0_lin));

% Rysowanie wykresu
figure;
semilogy(Eb_N0_dB, BER, 'b-o', 'LineWidth', 2, 'DisplayName', 'Symulacja Monte Carlo');
hold on;
semilogy(Eb_N0_dB, BER_theoretical, 'r--', 'LineWidth', 2, 'DisplayName', 'Teoretyczny BER');
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('Analiza BER w kanale AWGN (BPSK)');
legend('Location', 'southwest');
grid on;
