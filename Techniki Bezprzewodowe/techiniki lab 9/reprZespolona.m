%zakładamy szybkość transmisji 10 ksym/s
%zatem kolejne symbole modulacji będą pojawiać się co czas Ts - to będzie nasza podstawowa jednostka pracy systmu
numSyms=10; %generujemy 10 symboli
sps=100;%liczba probek na symbol
Ts=1e-6;
M=4; %modulation order. Jak widać testujemy modulację QPSK

%TODO 1: wygeneruj numSyms losowych liczb całkowitych z zakresu od 0 do M-1 użyj funkcji randi
inData=...;

%TODO 2: przekształć wejściowy strumień danych na ciąg symboli QPSK użyj funkcji qammod
symStr=...; %wygeneruj ciąg symboli QPSK

%TODO 3: w naszym eksperymencie zakładamy szybkosć symbolową 10 ksym/s zatem czas trwania każdego symbolu to 100 taktów zegara
%wydłuż czas trwania symboli znajdujących się w zmiennej symStr z jednego do stu taktów korzystając z funkcji repelem
symStr=...;
%Przygladając się zmiennej symStr można zauważyć, że zawiera ona tzw. dolnopasmową reprezentację zespoloną sygnału
%Krótko mówiąc opisuje ona, w postaci liczby zespolonej, amplitudę i fazę sygnału przy założeniu że jego częstotliwość środkowa (czyli nośna) to 0 Hz
%Jesli chcemy zobaczyć rzeczywistą postać sygnału najprościej będzie jeśli przesuniemy sygnał w dziedzienie częstotliwości np o 30 kHz a następnie weźmiemy z niego jedynie część rzeczywistą

%TODO 4: przesuń sygnał w dziedzinie częstotliwości o 30 kHz mnożąc go
%przez sygnał postaci e^jwt. Użyj funkcji exp i real. W Matlabie jednostke
%urojoną zapisujemy jako 1i
fc=3e4;
cplxMod=...;
%pwelch(cplxMod,4096,[],[],1/Ts,'centered');
realMod=real(cplxMod);
%zrobione? TAK, to oglądamy
title('postać rzeczywista niefiltrowanego sygnału QPSK');
plot(realMod);
%Wygląda jak w ksiązkach no to teraz czas większy realizm. Jak niebawem
%sprawdzimy  modulacja bez filtracji niestety ma niewiele sensu.
%Widzieliśmy już diagramy konstelacji zatem zobaczmy też rzeczywistą postać
%sygnału po filtracji

%TODO 5: wygeneruj filtr o charakterystyce podniesiony cosinus (RC)
%korzystając z funkcji rcosdesign. Pamiętaj, że w naszym przypadku mamy sps
%próbek na symbol, natomiast uzyskanie dobrej jakości filtracji zapewnia
%filtr obejmujący co najmniej 10 symboli. Przyjmij współczynnik poszerzenia
%pasma na poziomie 0,35
rcFiltr=...;
%TODO 6: zastosuj operację filtracji wygenerowanym filtrem do sygnału ze
%zmiennej symStr. Użyj funkcji upfirdn
rcSyms=upfirdn(symStr,rcFiltr,1,1);
rcSyms=rcSyms(floor(length(rcFiltr)/2)+1:end-floor(length(rcFiltr)/2)); % a co to za linijka? Zastanów się co robi i po co 
%TODO 7: przesuń sygnał w dziedzinie częstotliwości o 30 kHz tak żeby się
%go przyjemnie oglądało. Krótko mówiąc zrób dokładnie to samo co w punkcie
%todo 4
cplxModRC=...;
realModRC=real(cplxModRC);
title('postać rzeczywista sygnału QPSK filtrowanego filtrem RC');
plot(realModRC);


