% Przyklad_12_5: skrypt celp_test.m - testowanie ukladu CELP w wersji uproszczonej

% Dane wejsciowe: 
% 
% Nazwa frazy wejsciowej (bez rozszerzenia WAV);
% 
% N=256 - liczba probek tworzacych ramke, w ktorej beda obliczane wspolczynniki
% predykcji (mozna te wartosc modyfikowac);
% 
% L_sf - liczba wektorow sygnalu w ramce (musi byc podzielnikiem N, typowa wartosc
% L_sf=4). Majac dane N i L_sf program oblicza wymiar przetwarzanych wektorow
% sygnalu: M_sf=N/L_sf;
% 
% K - liczba wektorow slownika tworzacych model sygnalu wedlug wzoru (12.46);
% 
% L2 - liczbawektorow w slowniku (z L2wektorow programwybiera K,wedlug algorytmu
% Matching Pursuit - p. 12.6.1);
% 
% Rodzaj slownika: w programie wykorzystano slownik sekwencji gaussowskich
% (dic_celp = randn(M_sf, L2)). Mozna zamienic ten slownik na slownik impulsowy,
% zawierajacy L2=M_sf wektorow, z ktorych kazdy ma jedynie jedna skladowa
% niezerowa (rowna 1). Nalezy wowczas odblokowac instrukcje:
% L2=M_sf;
% dic_celp=eye(L2);
% 
% (Na podstawie tych danych jest szacowana szybkosc transmisji (przeplywnosc binarna).
% Jest to wartosc orientacyjna, gdyz wiele parametrow, jak wzmocnienia i wspolczynniki
% predykcji, nie podlega kwantyzacji).
% 
% gamma - wspolczynnik filtracji percepcyjnej. Podstawiono wartosc 0,9 - zmiana na
% wartosc 1 spowoduje wylaczenie filtracji percepcyjnej i mechanizmu ksztaltowania
% widma szumu kwantyzacji;
% 
% P_perc - liczba wspolczynnikow predykcji wykorzystywanych w filtrze syntezy predykcyjnej
% H(z) (rys. 12.28) i w filtrach preemfazy/deemfazy.
% 
% Dane wyjsciowe:
% 
% Plik FRAZA.WAV gotowy do odsluchu. Jego nazwa rozni sie od nazwy frazy oryginalnej
% znakiem ,,_";
% 
% Wykres SNR [dB] w segmentach (ramkach) dla sygnalu mowy i dla sygnalu percepcyjnego
% (Figure 7);
% 
% SNR_dB - wartosc srednia SNR w segmentach dla mowy;
% 
% SNR_percep_dB - wartosc srednia SNR w segmentach dla sygnalu percepcyjnego.
% 
% Jesli visu = 1, to sa wyprowadzane co ramke nastepujace wykresy:
% - sygnal wejsciowy, wyjsciowy i blad kwantyzacji (Figure 1),
% - widma amplitudy [dB] ww. sygnalow (Figure 2),
% - sygnal percepcyjny (mowa po preemfazie), jego model i blad modelowania (Figure 3),
% - widma amplitudy [dB] ww. sygnalow (Figure 4),
% - sygnal pobudzajacy filtr syntezy (Figure 5) i jego widmo (Figure 6).

clear
close all
visu = 0;     % uaktywnienie wizualizacji
fe = 8000;    % czestotliwosc probkowania
N = 256;      % ramka
P_perc = 20;   % rzad filru percepcyjnego
gamma = 0.9;   % wspolczynnik filtracji percepcyjnej (gdy gamma=1, brak filtracji)

L2 = 128;      % liczba wektorow w slowniku (mozna ja zmienic)

L_sf = input('liczba wektorow w 256-probkowej ramce (2,4,8 lub 16): ');
K = input('liczba wektorow tworzacych model sygnalu = ');
M_sf=N/L_sf;  % wymiar wektora (podramki)

% slownik CELP - moze byc gaussowski

dic_celp = randn(M_sf, L2);

%L2=M_sf;
%dic_celp=eye(L2);  % to jest slownik impulsowy

bitrate=40*fe/N+(3*K+ceil(log2(factorial(L2)/(factorial(K)*factorial(L2-K)))))*fe/M_sf

% plik wejsciowy

fichier = input('plik sygnalu mowy  ','s');
nom_fichier = [fichier '.wav'];
speech=wavread(nom_fichier); % Fraza mowy
Nbre_ech = length(speech);

Nbre_fen = fix(Nbre_ech/N);  % liczba ramek
fprintf('Przetwarzanie %3d ramek pliku %s.wav \n',Nbre_fen, fichier)

speechout=codec(speech, fe, N, K, M_sf, P_perc, gamma, dic_celp, Nbre_fen,  visu);

nom_out = [fichier '_.wav'];
wavwrite(speechout,fe,nom_out); % plik wyjsciowy

