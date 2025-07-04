%Niniejszy skrypt symuluje w Matlabie ten sam scenariusz który oglądaliśmy
%przed chwilą dzięki modelowi Simulinka. Tym razem jednak przyglądać
%będziemy się innym aspektom transmisji, a dokładniej sposobowi w jaki
%objawiają się błędy transmisji. W tym celu porównamy dwa tory:
% Tor pierwszy nie zawiera operacji kodowania i dekodowania nadmiarowego
% dataIn->qammod->AWGN->qamdemod->dataRaw
% dataIn - dane wejsciowe dataRaw - dane wynikowe
% Tor drugi zawiera operację kodowania i dekodowania splotowego o
% sprawności 1/2
% dataIn->convenc->qammod->AWGN->qamdemod->vitdec->dataSoft
%Z uwagi na opóźnienie wnoszone przez tor drugi należy dokonać jego
%korekcji. Zatem tym razem para dane wejsciowe dane wynikowe to: convDataIn, convDataOut
clear all;
close all;
rng default
M = 4;                % Modulation order
k = log2(M);           % Bits per symbol
% zwróć uwagę na dwie różne wartości EbNo użyte dla obydwu torów. Celem
% zastosowania dwóch różnych wartości jest uzyskanie zbliżonej wartości BER
% na wyjściach obydwu torów. Spróbujemy zweryfikować to założenie w punkcie
% TODO 1.
EbNo = 3.3;     % Eb/No value (dB)
EbNoRaw = 8;
numSyms = 1e6; % Number of QAM symbols

trellis = poly2trellis(7,[171 133]);
tbl = 32;
rate = 1/2;


    % Convert Eb/No to SNR
    snrdB = EbNo + 10*log10(k*rate);
    snrRawdB = EbNoRaw + 10*log10(k);	
    % Noise variance calculation for unity average signal power
    noiseVar = 10.^(-snrdB/10);
    % Reset the error and bit counters
    
        % Generate binary data and convert to symbols
        dataIn = randi([0 1],numSyms*k,1);
        
        % Convolutionally encode the data
        dataEnc = convenc(dataIn,trellis);
        
        % QAM modulate
        txSig = qammod(dataEnc,M, ...
            InputType='bit', ...
            UnitAveragePower=true);
        txSigRaw = qammod(dataIn,M, ...
            InputType='bit', ...
            UnitAveragePower=true);
        % Pass through AWGN channel
        rxSig = awgn(txSig,snrdB,'measured');
        rxSigRaw = awgn(txSigRaw,snrRawdB,'measured');		
        
        % Demodulate the noisy signal using  soft decision (approximate LLR) approach.
        dataRaw = qamdemod(rxSigRaw,M, ...
            OutputType='bit', ...
            UnitAveragePower=true);
        rxDataSoft = qamdemod(rxSig,M, ...
            OutputType='approxllr', ...
            UnitAveragePower=true, ...
            NoiseVariance=noiseVar);
        
        % Viterbi decode the demodulated data
        dataSoft = vitdec(rxDataSoft,trellis,tbl,'cont','unquant');
        
        %align both transmitted and received streams in time;
        convDataIn = dataIn(1:end-tbl);
        convDataOut = dataSoft(tbl+1:end);
%TODO1:
% Wyznacz bitową stopę błędów na wyjsciu obydwu torów. Wykorzystaj funkcje
% biterr pakietu matlab
% Pary sygnałów wejście-wyjście:
%  (dataIn,dataRaw) - transmisja sygnału QPSK przez kanał AWGN
%  (convDataIn,convDataOut) - transmisja kodowanego splotowo sygnału QPSK

[~,BerRaw]=...;
[~,BerFEC]=...;
fprintf('BER bez kodowania %g BER z kodowaniem: %g\n',BerRaw,BerFEC);


%TODO2:
% Narysuj histogramy obrazujące liczone w bitach odległości między
% kolejnymi przekłamanymi bitami dla transmisji bez kodowania splotowego
% oraz dla transmisji z kodowaniem splotowym.
% Pary sygnałów wejście-wyjście:
%  (dataIn,dataRaw) - transmisja sygnału QPSK przez kanał AWGN
%  (convDataIn,convDataOut) - transmisja kodowanego splotowo sygnału QPSK
% Do realizacji zadania wykorzystaj funkcje: xor, find oraz histogram.
% Jeśli zauważysz, że realizacja zadania zabiera Ci więcej niż 10 linijek kodu znaczy to, że coś
% idzie nie tak :)




        
