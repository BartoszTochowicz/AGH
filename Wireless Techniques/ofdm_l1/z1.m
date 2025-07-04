clear all;
close all;

Fs= 1e6; % częstotliwość próbkowania w Hz


%TODO 1: korzystając z funkcji ofdmTx wygeneruj 100 symboli OFDM 
numOFDMSyms=100;
%o długości prefiksu cyklicznego 16 próbek,
cpLength=16;
%zawierającego 256 podnośnych, pracujących z modulacją 64 Qam
scNum=256;
modM=64;
%oraz o 10% szerokości pasma ochronnego
guardBWperc=10;
%zakładamy brak częstotliwości pilotujących

[tdTxSig,~]=...;

%TODO 2: wyznacz widmo sygnału OFDM możesz skorzystać bezpośrednio z fft lub pwelch
...;

%TODO 3: Wyznacz czas trwania symbolu w [ms]. Pamiętaj żeby uwzglednić również czas trwania prefiksu cyklicznego

symDuration= ...;

%TODO 4: Wyznacz szerokość pasma sygnału przesyłanego na pojedynczej podnośnej w [kHz]

sCBandw=...;
%TODO 5: wyznacz przepustowość dla pojedynczej podnośnej w [kbit/s]. Pamiętaj o prefiksie cyklicznym
sCThr=...;


fprintf(['sygnał OFDM:\n Liczba podnośnych %d, czas trwania symbolu : %g [ms] ' ...
    'szerokość pasma podnośnej: %g [kHz], przepustowośc podnośnej %g  [kbit/s]\n'], ...
    scNum,symDuration,sCBandw,sCThr);
