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
    
    % Cepstrum (opcjonalnie do estymacji tonu)
    c = real(ifft(log(abs(fft(bx)) + eps)));
    [~, T_cep] = max(c(20:100)); T_cep = T_cep + 19;
    
    % Próg energii i autokorelacji
    progE = 0.01;              % empiryczny próg energii
    progR = 0.35 * r(1);       % próg korelacji
    
    % Połączenie kryteriów (można eksperymentować)
    if energia > progE && rmax > progR && T_autokor >= 20 && T_autokor <= 160
        T = T_autokor;  % lub T_cep
        isVoiced = true;
    else
        T = 0;
        isVoiced = false;
    end

% Algorytm kratowy (katowy) - obliczenie gamma i a
gamma = zeros(Np,1);
a_mat = zeros(Np,Np);  % a_mat(i,j) = współczynniki filtru dla rzędu i
E = r(1);

for i = 1:Np
    % Oblicz suma = r(i+1) + sum_{j=1}^{i-1} a_{i-1,j} * r(i-j+1)
    suma = r(i+1);
    for j = 1:i-1
        suma = suma + a_mat(i-1,j) * r(i-j+1);
    end

    gamma(i) = -suma / E;

    % Ograniczenie gamma dla stabilności
    if abs(gamma(i)) > 0.999
        gamma(i) = sign(gamma(i)) * 0.999;
    end

    % Aktualizacja współczynników a
    if i == 1
        a_mat(i,1) = gamma(i);
    else
        for j = 1:i-1
        if i - j == 0
        % Zabezpieczenie przed indeksem 0
        a_mat(i,j) = a_mat(i-1,j);
    else
        a_mat(i,j) = a_mat(i-1,j) + gamma(i) * a_mat(i-1,i-j);
    end
end
        a_mat(i,i) = gamma(i);
    end

    % Aktualizacja błędu predykcji
    E = E * (1 - gamma(i)^2);
end

% Kwantyzacja gamma
n_bits = 6;
gamma_q = round((gamma + 1) * (2^n_bits - 1) / 2) / (2^n_bits - 1) * 2 - 1;

% Rekonstrukcja a z gamma_q
a_mat = zeros(Np,Np);
for i = 1:Np
    a_mat(i,i) = -gamma_q(i);
    for j = 1:i-1
        a_mat(i,j) = a_mat(i-1,j) + gamma_q(i) * a_mat(i-1,i-j);
    end
end

a = a_mat(Np,:)';

    wzm = r(1)+r(2:Np+1)*a; % wzmocnieni filtra predykcji

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

