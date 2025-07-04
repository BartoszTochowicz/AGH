close all;
[inSig,Fs]=audioread('voice_spectrev.wav');
%sygnał ktory wlasnie wczytalismy do zmiennej inSig zawiera fragment tekstu, ktory
%zostal zakodowany tak ze wysokie czestotliwosci zamieniono miejscami z
%niskimi (zamiana górnej i dolnej połówki widma). Przyjmując, że maksymalna częstotliwość w widmie badanego sygnału
%to 4 kHz napisz dekoder który pozwoli na usłyszenie tekstu w czytelnej dla
%człowieka postaci

hold on
pwelch(inSig,4096,[],[],Fs,'centered');
%soundsc(inSig,Fs); %tak brzmi zakodowany sygnał
%TODO 1: odkomentuj poniższe linie i napisz dekoder. Użyj funkcji hilbert (przeczytaj uważnie dokumentację!!!) i
%własnej pomysłowości.
% Wskazówka: Jeśli rozwiązanie zajmuje więcej niż 5 linijek oznacza, że
% robisz coś źle
% y = hilbert(inSig).*(exp(1j*4000*2*pi.*[0:1/Fs:(length(inSig)-1)/Fs]))';
% pwelch(y,4096,[],[],Fs,'centered');
% y2 = hilbert(inSig).*(exp(-1j*4000*2*pi.*[0:1/Fs:(length(inSig)-1)/Fs]))';

y1 = hilbert(inSig).*exp(1j*4000*2*pi.*[0:1/Fs:(length(inSig)-1)/Fs])';

% figure;
% pwelch(y1,4096,[],[],Fs,'centered');
%pwelch(x,4096,[],[],Fs,'centered');
% figure;
% pwelch(y2,4096,[],[],Fs,'centered');
% figure;
signal_out = real(y1 + flip(y1));
pwelch(signal_out,4096,[],[],Fs,'centered');

soundsc(signal_out,Fs); %a tak brzmi sygnał po zdekodowaniu