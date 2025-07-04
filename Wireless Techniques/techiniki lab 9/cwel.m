% BER Simulation for different interleaver depths
% Definicja parametrów
EbNo = 0:2:10; % Wartości Eb/No w dB
numBits = 1e5; % Liczba bitów do przesłania

% Wygenerowanie danych
data = randi([0 1], numBits, 1); % Losowe bity

% Symulacja bez przeplotu
ber_no_interleaver = ber_simulation(data, EbNo, 1);

% Symulacja z przeplotem (głębokość 12)
ber_interleaved12 = ber_simulation(data, EbNo, 12);

% Wykres porównawczy
figure;
semilogy(EbNo, ber_no_interleaver, '-o', 'LineWidth', 1.5);
hold on;
semilogy(EbNo, ber_interleaved12, '-x', 'LineWidth', 1.5);
hold off;
grid on;
legend('Bez przeplotu (depth = 1)', 'Przeplot (depth = 12)');
xlabel('Eb/No [dB]');
ylabel('BER');
title('Porównanie BER dla różnych głębokości przeplotu');

function ber = ber_simulation(data, EbNo, interleaverDepth)
    N0 = 1; % Moc szumu AWGN
    ber = zeros(size(EbNo));
    for i = 1:length(EbNo)
        % Modulacja BPSK
        modData = 2*data - 1;

        % Dodanie przeplotu, jeśli wymagany
        if interleaverDepth > 1
            interleaver = "comm.BlockInterleaver('NumColumns', interleaverDepth)";
            modData = interleaver(double(modData)); % Przeplot danych
        end

        % Dodanie szumu AWGN
        noiseVar = N0 / (2 * 10^(EbNo(i)/10));
        noise = sqrt(noiseVar) * randn(size(modData));
        received = modData + noise;

        % Demodulacja i zliczanie błędów
        demodData = received < 0;

        % Odszyfrowanie przeplotu
        if interleaverDepth > 1
            deinterleaver = "comm.BlockDeinterleaver('NumColumns', interleaverDepth)";
            demodData = deinterleaver(double(demodData)); % Odszyfrowanie danych
        end

        % Obliczenie BER
        ber(i) = sum(data ~= demodData) / length(data);
    end
end
