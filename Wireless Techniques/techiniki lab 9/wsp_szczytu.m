span=8; %ilosc symboli obejmowanych filtrem
sps=128; % liczba probek na symbol
M=4; %liczba punktów konstelacji
numSyms=10000; %liczba transmitowanych symboli modulacji
%TODO 1: wygeneruj numSyms liczb losowych z zakresu [0;M-1] użyj randi
x=randi...;
%TODO 2: na podstawie x wygeneruj odpowiednie symbole QPSK (użyj qammod)
modSig=...;

alfa=[0.01:0.05:0.99]; % wspolczynnik poszerzenia pasma filtru
    for i=1:length(alfa)
%TODO 3: zaprojektuj filtr typu podniesiony cosinus o współczynniku poszerzenia pasma wynoszącym 
%		 alfa(i) obejmujący "span" symboli z których każdy obejmuje "sps" próbek. Uzyj rcosdesign    
    rrcFilter = ...;
%TODO 4: nadprobkuj sygnał sps krotnie i dokonaj filtracji. Uzyj funkcji upfirdn
    txOut=...;
%TODO 5: wyznacz współczynnik szczytu sygnału txOut. Uzyj funkcji max, abs oraz mean
    cf(i)=...;
    end
plot(alfa,cf);