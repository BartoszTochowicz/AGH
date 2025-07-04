% Przyklad_12_2: skrypt qlog_test.m - testowanie kwantyzatora logarytmicznego typu mi

% Dane wejsciowe:
%
% Nazwa pliku dzwiekowego (bez rozszerzenia WAV)
%
% Amplituda sygnalu wejsciowego: wpisujac 1, zapewniamy pelne wysterowanie kwantyzatora,
% gdyz przeprowadza on kwantyzacje od -1 do +1; wpisujac wartosci np. 0,1, 0,01,
% 0,001 tlumimy fraze wejsciowa odpowiednio o 20, 40, 60 dB; wpisujac wartosci > 1
% mozna uzyskac efekt przesterowania;
%
% Liczba poziomow kwantyzacji L.
%
% Wartosc parametru mi (wzor 12.9)
%
% Dane wyjsciowe:
%
% Plik SYNT_WAV gotowy do odsluchu;
%
% Wykres sygnalu wejsciowego, wyjsciowego i bledu kwantyzacji (Figure 1);
%
% snrdb, snrsegdb - wartosci SNR globalnego i segmentowego (w dB);
%
% Wykres sygnalu wejsciowego i wyjsciowego (Figure 10);
%
% Energia sygnalu w poszczegolnych segmentach (w segmencie jest 80 probek, czyli 10 ms
% sygnalu) - wykres niebieski (Figure 20);
%
% SNR w dB w poszczegolnych segmentach - wykres czerwony (Figure 20).

clear
close all

%   nazwa pliku audio
fichier = input('plik audio  ','s');
nom_fichier = [fichier '.wav'];

we=wavread(nom_fichier);
amp = input('amplituda sygnalu: ');
sig=we*amp/max(abs(we));


N=length(sig);


L = input('liczba poziomow ');

we_nor=sig;

% kompresja mi

mu=input('wartosc mi: ');

for i=1:N
    ylog(i) =kompr_log(we_nor(i),1,mu);
end

% kwantyzacja rownomierna

for i=1:N
    [indx(i) qy] = kwant_rown(L, 1, ylog(i));
end

% dekodowanie rownomierne

for i=1:N
    qylog(i) = dekod_rown(L, 1, indx(i));
end

% ekspander

for i=1:N
    wy_nor(i)= expand_log(qylog(i),1,mu);
end

wy_nor=wy_nor';
err = wy_nor-we_nor;   % blad kwantyzacji

figure(1), hold off
plot(we_nor), hold on
plot(wy_nor, 'g')
plot(err, 'r')
title('we, wy i blad kwantyzacji')


snr_(we_nor,wy_nor);

wavwrite(wy_nor,'synt.wav')

