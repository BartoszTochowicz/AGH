% Przyklad_12_1: skrypt kwant_test.m  - testowanie kwantyzatora rownomiernego

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
sig=we*amp/max(abs(we));  % tu mozna stlumic lub wzmocnic sygnal

N=length(sig);

L = input('liczba poziomow  ');

% kwantyzacja
for i=1:N
    [indx(i) qy] = kwant_rown(L, 1, sig(i));
end
%
% dekodowanie
for i=1:N
    qsig(i) = dekod_rown(L, 1, indx(i));
end
qsig=qsig';

qerr = sig-qsig;


snr_(sig,qsig);

figure(1), hold off
plot(sig), hold on
plot(qsig, 'g')
plot(qerr, 'r')
title('we, wy i blad kwantyzacji')

wavwrite(qsig,'synt.wav')


