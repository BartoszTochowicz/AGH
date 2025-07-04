% Przykład_12_3: skrypt adpcm_test.m - testowanie kwantyzatora adaptacyjnego

% Dane wejściowe:
%
% Nazwa pliku wejściowego (bez rozszerzenia WAV);
%
% Amplituda sygnału wejściowego – jak w kwant_test;
%
% Liczba bitów n: można wpisać 2, 3 lub 4, otrzymując kwantyzator o 4, 8 i 16 poziomach.
% Są to kwantyzatory typu mid-riser – nie mają poziomu o wartości zerowej;
%
% Liczba współczynników predykcji: wpisujemy dowolną liczbę od 1 do kilkunastu,
% predyktor i tak będzie generował zerowy sygnał predykcji;
%
% Szybkość adaptacji: 0.
%
% Dane wyjściowe – jak w programie kwant_test.

clear
close all
%   nazwa pliku audio
fichier = input('plik audio  ','s');
nom_fichier = [fichier '.wav'];

we=audioread(nom_fichier);
amp = input('amplituda sygnalu  ≶ 1): ');
sig=we*amp/max(abs(we));

N=length(sig);
qsig=sig;
bits = input('liczba bitow (2, 3 lub 4) : ');
L=2^bits;  % liczba poziomow kwantyzacji
% wspolczynniki adaptacji kwantyzatora:
if L==4
    xm=[0.8,1.6];
elseif L==8
    xm=[0.9,0.9,1.25,1.75];
elseif L==16
    xm=[0.8,0.8,0.8,0.8,1.2,1.6,2.,2.4];
else
    disp('liczba bitow = 2, 3 lub 4')
    pause
end

zmax=1.;
zmin=0.001*zmax;
z=0.2*zmax; % poczatkowy zakres pracy
delta=1.e-5;
dl=1.e-10;
w=0.99;

mp = input('liczba wsp. predykcji (M > 0) :');

beta = input('szybkosc adaptacji beta = ');

ai = zeros(mp,1); % wspolczynniki predykcji

buf=zeros(mp,1);

for i=1:N
    snp=buf'*ai; % predykcja
    en=sig(i)-snp;       % blad predykcji
    [nr,wy]=kwant_rown(L,z,en);  % kwantyzator rownomierny
    z=z*xm(abs(nr)); %adaptacja kwantyzatora metoda "wstecz"
    
    if z <= zmin
        z=zmin;
    end
    if z > zmax
        z=zmax;
    end
    
    qsig(i)=wy+snp;  % syg. wyjsciowy
    
    ai=ai+beta*wy*buf; % adaptacja predyktora
    
    buf=[qsig(i);buf(1:mp-1)];
    
    unstab=norm(ai);  % wykrywanie niestabilnosci numerycznej
    if unstab > 10^6
        'niestabilnosc - zmniejsz beta!'
        pause
    end
    
end

qerr = sig-qsig;

snr_(sig(20:N),qsig(20:N));

figure(1), hold off
plot(sig), hold on
plot(qsig, 'g')
plot(qerr, 'r')
title('we, wy i blad kwantyzacji')

audiowrite(qsig,'synt.wav')