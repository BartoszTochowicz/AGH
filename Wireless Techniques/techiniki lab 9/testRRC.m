Rs=1e4; %zakładamy szybkość transmisji 10 ksymboli/s
numSyms=1e4; %liczba przesłanych symboli
Ts=1e-6; %szybkość próbkowania z którą pracuje nasz system
M=4; %modulation order

%deklarujemy pomocniczy blok do liczenia stopy błędów BER
errorCalc = comm.ErrorRate;

%TODO 1: wygeneruj dwa strumienie po numSyms losowych liczb całkowitych z zakresu od 0 do M-1 użyj funkcji randi

numStr1=...;
numStr2=...;

%TODO 2: przekształć wejściowe strumienie danych na ciąg symboli QPSK, użyj funkcji qammod

symStr1=...; %wygeneruj pierwszy sygnał M-QAM
symStr2=...; %wygeneruj drugi sygnał M-QAM

%TODO 3: w naszym eksperymencie zakładamy szybkosć symbolową 10 ksym/s zatem czas trwania każdego symbolu to 1/(Ts*Rs) taktów zegara

%wydłuż czas trwania symboli znajdujących się w zmiennych symStr1 i symStr2 z jednego do sps taktów korzystając z funkcji repelem
%Tym samym sygnał użyteczny zostaje dość mocno nadpróbkowany. W praktyce
%staramy się unikać zbyt dużego nadpróbkowania z uwagi na niepotrzebny wzrost mocy
%obliczeniowej, ale tutaj marzą nam się wykresy o dużej rozdzielczości :-)
sps=1/(Ts*Rs);

%zmiana w TODO6% #1 odkomentuj następną linię a następnie uzupełnij ją tak aby
					%tworzyła ona filtr rrc o współczynniku poszerzenia pasma 0.35, rozciąjący się na 10 kolejnych symboli z których
					%każdy symbol licz sps próbek. Użyj funkcji rcosdesign
%rrcFlt=...;%zmiana w TODO6% #1
					%zmiana w TODO6% #2 prostą metodę nadpróbkowania z układem próbkująco-pamiętającym którą
					%wykonaliśmy z użyciem funkcji repelem zastąp interpolacją z wykorzystaniem
					%filtru rrcFlt. Uzyj funkcji upfirdn

symStr1=...; %zmiana w TODO6% #2
symStr2=...; %zmiana w TODO6% #2



%TODO 4: Uzupełnij kod funkcji fshift (w pliku fshift.m) tak aby dokonywala ona przesuniecia
%sygnalu w dziedzinie czestotliwosci wykonujac mnozenie sygnału wejsciowego
%przez czynnik exp(jwt). Funkcja fshift posiada 3 argumenty: pierwszy to
%sygnał wejściowy, drugi to częstotliwość o którą chcemy przesunąć sygnał
%wejściowy, trzeci zaś to szybkośc próbkowania systemu.

%teraz wykorzystujemy ten sygnał tak aby stworzyć symulację dwóch
%nadajników pracujących na różnych częstotliwościach nośnych f1 oraz f2
f1=2e4;
f2=1e5;
compositeSig=fshift(symStr1,f1,1/Ts) + fshift(symStr2,f2,1/Ts); % przesuń sygnał sig1 o 20KHz i sig2 o 100KHz

%obejrzyjmy wynik w dziedzinie częstotliwości:

pwelch(compositeSig,4096,[],[],1/Ts,'centered');

%jak widać udało nam się wygenerowac dwa sygnały o różnych
% częstotliwościach nośnych. Spróbujmy dokonać odbioru sygnału o indeksie 1.
% W tym celu musimy go przesunąć w lewo w dziedzinie częstotliwości o f1
% a  następnie obniżyć częstotliwość próbkowania sps krotnie i dokonać
% demodulacji

%TODO 5: przesuń sygnał compositeSig w dziedzinie częstotliwości w lewo o f1 korzystając z funkcji fshift.
% oznacza to, ze sygnał symStr1 powinien znaleźć się w paśmie podstawowym 
% Po zrealizowaniu niniejszego podpunktu uruchom skrypt i sprawdz ile wynosi BER
% Zwróć uwagę, że w  naszej symulacji nie ma żadnego szumu. Zatem BER powinien wynosić "0"
detSig=...;


%TODO 6:
		%jak widać nasze dotychczasowe zabiegi nie sprawiły że system działa
		%poprawnie. Problemem jest wzajemne zakłócanie się sygnałów. Musimy zatem
		%przekonstruować nasz system tak aby zawierał on operację filtracji.
		%Rozpoczynając od początku skryptu znajdź wszystkie znaczniki %zmiana w TODO6% #X 
		%a następnie zaczynając od najmniejszych wartości #X dokonaj stosownych przeróbek

		%zmiana w TODO6% #3 Zastępujemy naiwną redukcję szybkości próbkowania
		%bardziej złożoną formą korzystającą z filtru pierwiastek z
		%podniesionego cosinusa. Ponownie korzystamy z filtru rrcFilter
		%oraz funkcji upfirdn

detSyms=downsample(detSig,sps);%redukujemy szybkosc probkowania sps krotnie %zmiana w TODO6% #3. Wykonując zadanie TODO6#3 uzyj funkcji upfirdn
							   %oraz filtru interpolacyjnego opracowanego w punkcie TODO6#1 	

outData=qamdemod(detSyms,M);%demodulujemy odebrany sygnał
recDelay=finddelay(numStr1,outData);
berVec = errorCalc(numStr1,outData(recDelay+1:recDelay+numSyms));   % wyliczamy BER. Jak? - koniecznie przejrzyj dokumentacje obiektu comm.ErrorRate
fprintf('BER: %d liczba błędnych symboli: %d odebranych symboli: %d \n',berVec(1),berVec(2),berVec(3));
