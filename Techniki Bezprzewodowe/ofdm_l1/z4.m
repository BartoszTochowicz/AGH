clear all
close all



%TODO 1:
%liczba podnośnych z zakresu 128-4096 (jako rozmiar transformaty przyjmij kolejne potęgi 2: (128,256,512,1024,2048,4096),

%TODO 2:
%napisz strukturę pętli iterującą po wektorze fftSize
%TODO 3:
%w wewnętrznej pętli 
% Każdy punkt na wykresie wyznacz jako średnią ze 100 eksperymentów, z których każdy to 
% wygenerowanie 10 symboli OFDM i wyznaczenie współczynnika szczytu sygnału. 
% wyniki zapisz w zmiennych paprQpsk i papr64Qam



fftSize = [128, 256, 512, 1024, 2048, 4096];
numExperiments = 100;  
numSymbols = 10;       
guardInterval = 10;    
prefixLength = round(0.1 * fftSize); 

paprQpsk = zeros(length(fftSize), 1);
papr64Qam = zeros(length(fftSize), 1);


for i = 1:length(fftSize)
    fftN = fftSize(i);
    paprQpskExp = zeros(numExperiments, 1);
    papr64QamExp = zeros(numExperiments, 1);

    
    for j = 1:numExperiments
       
        [txSigQPSK, ~] = ofdmTx(numSymbols, prefixLength(i), fftN, 4, guardInterval);
       
        [txSig64QAM, ~] = ofdmTx(numSymbols, prefixLength(i), fftN, 64, guardInterval);
        
        paprQpskExp(j) = 10 * log10(max(abs(txSigQPSK).^2) / mean(abs(txSigQPSK).^2));
        papr64QamExp(j) = 10 * log10(max(abs(txSig64QAM).^2) / mean(abs(txSig64QAM).^2));
    end
    paprQpsk(i) = mean(paprQpskExp);
    papr64Qam(i) = mean(papr64QamExp);
end

plot(fftSize,paprQpsk,'g');
hold on;
grid on;
plot(fftSize,papr64Qam,'r');
xlim([fftSize(1) fftSize(end)]);