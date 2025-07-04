clear all;
close all;

[x, fpr] = audioread("mowa1.wav");

x_dzwieczny = x(49537:49537+239);


[cold, fs_cold] = audioread("coldvox.wav");
cold = cold(:)';  % upewnij się, że jest wektorem wierszowym
cold_idx = 1;     % indeks startowy

figure;
plot(x);title('sygnał mowy');
% soundsc(x,fpr);

N = length(x);
Mlen = 240; % dlugosc okna Hamminga (liczba probek)
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
    else
        T = 0;
    end

    % 1 podpunkt
    % T = 0;
    
    rr(1:Np,1) = r(2:Np+1)';
    for m = 1:Np
        R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji\
    end

    a = -inv(R)*rr; % wspolczynniki filtra predykcji
    wzm = r(1)+r(2:Np+1)*a; % wzmocnieni filtra predykcji
    H = freqz(1,[1;a]); % oblicvz odp czestotliwoci
    
    % 2_1 - 2_4
    residual = filter([1;a],1,x_dzwieczny);
    lpc=[lpc; T; wzm; a; ];	%zapamietaj wartosci parametrow
    
    % SYNTEZA - odtworz na podstawie parametrow

    if(T~=0)
        % 2 podpunkt
        % T = T*2;

        % podpunkt 3
        % T = 80;

        gdzie = gdzie-Mstep; %przenies pobudzenie dzwieczne
    end
    % for n = 1:Mstep
    %         if T == 0
    %             pob = 2*(rand(1,1) - 0.5);
    %             gdzie = gdzie + T;
    %         else
    %             if n == gdzie
    %                 pob = 1;
    %                 gdzie = gdzie + T;
    %             else
    %                 pob = 0;
    %             end
    %         end
    % 
    %         ss(n) = wzm*pob - bs*a;
    %         bs = [ss(n) bs(1:Np-1)];
    % end
    % podpunkt 4
    % T = 0;
    % for n = 1:Mstep
    %     pob = cold(cold_idx);  % pobranie próbki z coldvox
    %     cold_idx = cold_idx + 1;
    % if cold_idx > length(cold)
    %     cold_idx = 1;  % zapętlenie
    % end
    % 
    %     ss(n) = wzm * pob - bs * a;
    %     bs = [ss(n) bs(1:Np-1)];
    % end

    % fragment kodu dla 2_1 = 2_4
    T0 = 80;
    res_avg = mean(reshape(residual(1:T0*3),T0,3),2); % srednia z trzech ramek po 80 probek
    res_avg = res_avg / max(abs(res_avg));
    res_idx = 1;
    for n = 1:Mstep
        if(T == 0)
            pob = 2*(rand(1,1)-0.5); % pobudzenie szumowe
            gdzie = gdzie+T;
        else
            if(n==gdzie)
                pob = res_avg(res_idx);  % pobudzenie dzwieczne
                gdzie = gdzie+T;
                res_idx = res_idx+1;
                if(res_idx>length(res_avg))
                    res_idx = 1;
                end
            else
                pob = 0;
            end

        end

        ss(n) = wzm*pob-bs*a; % filtracja syntetycznego pobudzenia
        bs = [ss(n) bs(1:Np-1)]; % przesuniecie bufora wyjsciowego
    end
    s = [s ss]; %zapamietanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny
figure;
plot(s); title('mowa zsyntezowana');
soundsc(s, fpr)