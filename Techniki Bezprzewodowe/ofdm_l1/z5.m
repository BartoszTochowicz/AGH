clear all
close all

%% konfiguracja parametrow transmisji
symNumber=10;
guardInt=10;
fftSize=512;
prefLen=40;
M=64;
pilotInt=51;
Fs= 1e6; % częstotliwość próbkowania w Hz
%pilotInt=0;
Cir = [1, 0, 0.3+0.3j]; %odpowiedz impulsowa kanalu

[txSig,txBitStream]=ofdmTx(symNumber,prefLen,fftSize,M,guardInt,pilotInt);


%% transmisja przez kanał
rxSig=filter(Cir,1,txSig);
HF_act=circshift(abs(fft(Cir,fftSize)),fftSize/2);

%% odpowiedź częstotliwościowa kanału (resztę wizualizacji pokazuje odbiornik)
plot(1e-3*[-(Fs/2):Fs/fftSize:(Fs/2)-1],HF_act,'r');
title('Odpowiedź częstotliwościowa kanału');
xlabel('częstotliwość w [kHz]');
grid on;
figure;
rxBitStream=ofdmRx(rxSig,prefLen,fftSize,M,guardInt,pilotInt);

%% a tu możesz zaobserwować które bity zostały przekłamane 
figure
plot(txBitStream-rxBitStream);
title('różnica między sygnałem nadanym i odebranym');
