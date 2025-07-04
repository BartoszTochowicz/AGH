clear all;
close all;

[x, fpr] = audioread("mowa1.wav");

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

    % Oblicz energię
    energia = sum(bx.^2);
    
    offset = 20;
    rmax = max(r(offset:Mlen));
    imax = find(r == rmax, 1);
    T_autokor = imax;
    
    % Próg energii i autokorelacji
    progE = 0.01;              % próg energii
    progR = 0.35 * r(1);       % próg korelacji
    
    if energia > progE && rmax > progR && T_autokor >= 20 && T_autokor <= 160
        T = T_autokor;  % lub T_cep
        isVoiced = true;
    else
        T = 0;
        isVoiced = false;
    end

    % Implementacja Levinsona-Durbina
    a = zeros(Np,1);
    E = r(1);
    for i = 1:Np
        if i == 1
            gamma = -r(2) / E;
            a(1) = gamma;
            E = E * (1 - gamma^2);
        else
            % Oblicz sumę: r(i+1) + sum_{j=1}^{i-1} a_{j} * r(i-j+1)
            suma = r(i+1);
            for j = 1:i-1
                suma = suma + a(j)*r(i-j+1);
            end
            gamma = -suma / E;
    
            a_prev = a(1:i-1);
            for j = 1:i-1
                a(j) = a(j) + gamma * conj(a_prev(i-j));
            end
            a(i) = gamma;
            E = E * (1 - gamma^2);
        end
    end

    wzm = r(1)+r(2:Np+1)*a; % wzmocnieni filtra predykcji
    H = freqz(1,[1;a]); % oblicvz odp czestotliwoci

    lpc=[lpc; T; wzm; a; ];	%zapamietaj wartosci parametrow


    % SYNTEZA - odtworz na podstawie parametrow

    if(T~=0)
        gdzie = gdzie-Mstep; %przenies pobudzenie dzwieczne
    end
    for n = 1:Mstep
        if(T == 0)
            pob = 2*(rand(1,1)-0.5); % pobudzenie szumowe
            gdzie = gdzie+T;
        else
            if(n==gdzie)
                pob = 1;  % pobudzenie dzwieczne
                gdzie = gdzie+T;
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

