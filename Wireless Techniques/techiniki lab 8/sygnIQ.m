[inSig,Fs]=audioread('voice_spectrev.wav');
%sygnał ktory wlasnie wczytalismy do zmiennej inSig zawiera fragment tekstu, ktory
%zostal zakodowany tak ze wysokie czestotliwosci zamieniono miejscami z
%niskimi (zamiana górnej i dolnej połówki widma). Przyjmując, że maksymalna częstotliwość w widmie badanego sygnału
%to 4 kHz napisz dekoder który pozwoli na usłyszenie tekstu w czytelnej dla
%człowieka postaci

pwelch(inSig,4096,[],[],Fs,'centered');
soundsc(inSig,Fs); %tak brzmi zakodowany sygnał
%TODO 1: odkomentuj poniższe linie i napisz dekoder. Użyj funkcji hilbert (przeczytaj uważnie dokumentację!!!) i
%własnej pomysłowości. 
% Wskazówka: Jeśli rozwiązanie zajmuje więcej niż 5 linijek oznacza, że
% robisz coś źle
% outSig=....
% soundsc(inSig,Fs); %a tak brzmi sygnał po zdekodowaniu