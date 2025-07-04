function [snrdb,snrsegdb] = snr_(x, y)

% Porownanie 2 fraz dzwiekowych: x - oryginal, y - sygnal przetworzony.
% Funkcja  obliczajaca SNR synchronizuje w pewnym zakresie obie frazy. Koryguje ich
% przesuniecie (do 100 probek) i amplitude (zmiana amplitudy nie ma wplywu
% na SNR).
% Otrzymuje sie SNR w decybelach (snrdb) i segmentowe SNR w decybelach
% (snrsegdb). 
% Ponadto otrzymuje sie: 
% Wykres sygnalu wejsciowego i wyjsciowego (Figure 10);
% Energie sygnalu w poszczegolnych segmentach (w segmencie jest 80 probek, czyli 10 ms
% sygnalu) - wykres niebieski (Figure 20);
% SNR w dB w poszczegolnych segmentach - wykres czerwony (Figure 20).

fe = 8000; %czestotliwosc probkowania

N=80;   % dlugosc segmentu

lref=length(x);
ltest=length(y);

figure(10), hold off
plot(x); hold on
plot(y,'r');
title('oryginal i kopia')

corr1=zeros(100,1);
corr2=zeros(100,1);
corr0=0;

mlen=min(lref,ltest);
xx=x(1:mlen);
yy=y(1:mlen);
corr0=xx'*yy;

for i=1:100
    xx=x(1:mlen-i);
    yy=y(i+1:mlen);
    corr1(i)=xx'*yy;
    yy=y(1:mlen-i);
    xx=x(i+1:mlen);
    corr2(i)=xx'*yy;
end
[cmax1,imax1]=max(corr1);
[cmax2,imax2]=max(corr2);
if cmax1 > cmax2
    cmax=cmax1;
    imax=imax1;
    gain=(x(1:mlen-imax1)'*y(imax1+1:mlen))/(x(1:mlen-imax1)'*x(1:mlen-imax1));
    diff=gain*x(1:mlen-imax1)-y(imax1+1:mlen);
    xdel=gain*x(1:mlen-imax1);
else
    cmax=cmax2;
    imax=-imax2;
    gain=(x(imax2+1:mlen)'*y(1:mlen-imax2))/(x(imax2+1:mlen)'*x(imax2+1:mlen));
    diff=gain*x(imax2+1:mlen)-y(1:mlen-imax2);
    xdel=gain*x(imax2+1:mlen);
end

if corr0 > cmax
    cmax=corr0;
    imax=0;
    gain=(x(1:mlen)'*y(1:mlen))/(x(1:mlen)'*x(1:mlen));
    diff=gain*x(1:mlen)-y(1:mlen);
    xdel=gain*x(1:mlen);
end

diffabs=diff'*diff+10^(-10);
snr=(xx'*xx)/diffabs;
snrdb=10*log10(snr)
przesuniecie=imax

nsamp=length(diff);
nfen=fix(nsamp/N);
snrs=zeros(1,nfen);
enrgx=zeros(1,nfen);
for ifen=1:nfen
    xfen=xdel(N*(ifen-1)+1:N*ifen);
    dfen=diff(N*(ifen-1)+1:N*ifen);
    exfen=norm(xfen);
    enrgx(ifen)=20*log10(exfen+10^(-6));
    edfen=norm(dfen);
    snrs(ifen)=20*log10((exfen+10^(-6))/(edfen+10^(-10)));
    if exfen < 10^(-6)
        snrs(ifen)=0;
    end
end

figure(20), hold off
plot(enrgx); hold on
plot(snrs,'r');
title('energia sygnalu i snr w segmentach [dB]')

snrsegdb=mean(snrs)

