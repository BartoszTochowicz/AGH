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
    
    % Autokorelacja (do detekcji tonu)
    offset = 20;
    rmax = max(r(offset:Mlen));
    imax = find(r == rmax, 1);
    T_autokor = imax;
    
    % c = real(ifft(log(abs(fft(bx)) + eps)));
    % [~, T_cep] = max(c(20:100)); T_cep = T_cep + 19;
    
    % Próg energii i autokorelacji
    progE = 0.01;              % próg energii
    progR = 0.35 * r(1);       % próg korelacji
    
    if energia > progE && rmax > progR && T_autokor >= 20 && T_autokor <= 160
        T = T_autokor;
        isVoiced = true;
    else
        T = 0;
        isVoiced = false;
    end

    rr(1:Np,1) = r(2:Np+1)';
    for m = 1:Np
        R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji\
    end

    a = -inv(R)*rr; % wspolczynniki filtra predykcji
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
    s = [s ss]; 
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny
figure;
plot(s); title('mowa zsyntezowana'); 
soundsc(s, fpr)

