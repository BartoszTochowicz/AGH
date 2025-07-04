clear all;
close all;
[x,fpr]=audioread("mowa1.wav");

x_dzwieczny = x(49537:49537+239);
% x_dzwieczny(:,1) = mean(x_dzwieczny);

[cold, fs_cold] = audioread("coldvox.wav");
cold = cold(:)';  % upewnij się, że jest wektorem wierszowym
cold_idx = 1;     % indeks startowy

figure;
plot(x);title('sygnał mowy');
% soundsc(x,fpr);

N = length(x);
Mlen = 256; % dlugosc okna Hamminga (liczba probek)
Mstep = 180; % przesuniecie okna w czasie
Np = 10; % rzad filtra predykcji
gdzie = Mstep+1; % poczatkowe położenie pobudzenia dzwiecznego;

lpc = [];% tablica na wspolczynniki modelu sygnalu mowy
s = []; % cala mowa zsyntezowana
ss = []; % fragment sygnalu zsyntezowany
bs = zeros(1,Np); %bufor na fragment sygnalu mowy
Nramek = floor((N-Mlen)/Mstep+1); % ile fragmentow sygnalu jest do przetworzenia

x = filter([1 -0.9735],1,x); %filtracja wstepna (preemfaza)
% figure;

residuals = [];
for nr = 1:Nramek
    % pobierz kolejny fragment sygnalu
    n = 1+(nr-1)*Mstep:Mlen+(nr-1)*Mstep;
    bx = x(n);

    % ANALIZA - wyznacz parametry modelu
    bx = bx - mean(bx); % usuń wartosć srednia
    for k = 0:Mlen-1
        r(k+1) = sum( bx(1:Mlen-k).*bx(1+k:Mlen)); %funkcja autokorelacji
    end
    % subplot(411); plot(n,bx); title('fragment sygna�u mowy');
    % subplot(412); plot(r); title('jego funkcja autokorelacji');

    offset = 20; rmax = max( r(offset:Mlen)); % max funkcji autokorelacji
    imax = find(r==rmax);
    if ( rmax> 0.35*r(1)) % gloscka dzwiecza czy bezdzwieczna
        T = imax;
        isVoiced = true;
         residual = filter([1;a],1,bx);
        residuals{nr} = residual;
    else
        T = 0;
        residuals{nr} = 0;
        isVoiced = false;
    end
    
    rr(1:Np,1) = r(2:Np+1)';
    for m = 1:Np
        R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji\
    end

    a = -inv(R)*rr; % wspolczynniki filtra predykcji
    wzm = r(1)+r(2:Np+1)*a; % wzmocnieni filtra predykcji


   

    lpc=[lpc; T; wzm; a; ];	%zapamietaj wartosci parametrow
end

for nr = 1:Nramek
    idx = (nr-1)*(Np+2);
    T = lpc(idx+1);
    wzm = lpc(idx+2);
    a = lpc(idx+3:idx+Np+2);
    %     T0 = 120;
    % residuals{nr} = residual;
    % res_avg = mean(reshape(residual(1:T0*2),T0,2),2);
    % residuals{nr} = res_avg / max(abs(res_avg));
    if(T~=0)
        pobudzenie = residuals{nr};
        pobudzenie = pobudzenie / max(abs(pobudzenie)) * sqrt(wzm);
    else
        pobudzenie = randn(Mstep,1);
        pobudzenie = pobudzenie / max(abs(pobudzenie)) * sqrt(wzm);
    end
    bs = zeros(1,Np);
    ss = zeros(1,Mstep);

    for n = 1:Mstep
        if n <= length(pobudzenie)
            pob = pobudzenie(n);
        else
            pob = 0;
        end
        ss(n) = wzm*pob-bs*a;
        bs = [ss(n) bs(1:Np-1)];
    end
    s = [s ss];
end
s = filter(1,[1 -0.9735],s); % deemfaza
figure;
plot(s); title('mowa zsyntezowana');

soundsc(s, fpr); 