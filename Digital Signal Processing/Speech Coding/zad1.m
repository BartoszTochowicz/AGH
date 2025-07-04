clear all;
close all;

[x, fpr] = audioread("mowa3.wav");

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

    offset = 20; rmax = max( r(offset:Mlen)); % max funkcji autokorelacji
    imax = find(r==rmax);
    if ( rmax> 0.35*r(1)) % gloscka dzwiecza czy bezdzwieczna
        T = imax;
    else
        T = 0;
    end
    if T > 50
        nr
        T
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
    s = [s ss]; %zapamietanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny
% figure;
% plot(s); title('mowa zsyntezowana'); 
% soundsc(s, fpr)

% fs = fpr;
% frame_count = size(lpc)/(Np+2);
% 
% bit_configs = [8 6 6 4 4;
%                6 6 6 6 6;
%                8 8 8 8 8;
%                4 4 4 4 4];
% 
% results = [];
% 
% for config_idx = 1:size(bit_configs,1)
%     bit_allocation = bit_configs(config_idx,:);    
%     bitrate_total = 0;
% 
%     for i = 1:frame_count
%         idx = (i-1)*(Np+2);
%         T = lpc(idx+1);
%         wzm = lpc(idx+2);
%         a = lpc(idx+3:idx+Np+2);
% 
%         A = [1; a]; 
%         roots_a = roots(A);
%         [~,sort_idx] = sort(abs(roots_a),'ascend');
%         roots_a = roots_a(sort_idx);
% 
%         pairs = [];
%         used = false(length(roots_a),1);
%         for j = 1:length(roots_a)
%             if(used(j)), continue, end
%             rj = roots_a(j);
%             for k=j+1:length(roots_a)
%                 if(used(k)), continue, end
%                 rk = roots_a(k);
%                 if abs(rj-conj(rk))<1e-3
%                     pairs = [pairs; [rj rk]];
%                     used(j) = true; used(k) = true;
%                     break;
%                 end
%             end
%         end
% 
%         bits_used = 0;
%         for k = 1:min(length(bit_allocation),size(pairs,1))
%             r = pairs(k,1);
%             mag = abs(r); ang = angle(r);
%             % Kwantyzacja
%             mag_q = round(mag*(2^bit_allocation(k)-1)) / (2^bit_allocation(k)-1);
%             ang_q = round((ang+pi)/(2*pi)*(2^bit_allocation(k)-1)) / (2^bit_allocation(k)-1)*2*pi-pi;
%             bits_used = bits_used + bit_allocation(k)*2;
%         end
%         bitrate_total = bitrate_total + 8 + 6 + bits_used;
%     end
%     duration_sec = length(x)/fpr;
%     bitrate_bps = bitrate_total / duration_sec;
% 
%     results = [results; bit_allocation, bitrate_bps];
% end
% 
% % Wyświetl wyniki:
% col_names = {'b1','b2','b3','b4','b5','Bitrate_bps'};
% disp(array2table(results,'VariableNames',col_names));
% 
% 
% 


% Co robi ten fragment?
% Dla każdej ramki:
% 
% Wydobywa współczynniki a, okres T, wzmocnienie G.
% 
% Liczy bieguny transmitancji H(z) i dobiera je w sprzężone pary.
% 
% Dla 5 par biegunów stosuje odpowiednią kwantyzację: [8, 6, 6, 4, 4] bitów.
% 
% Oblicza liczbę bitów zużytych na jedną ramkę.
% 
% Sumuje całkowitą liczbę bitów i dzieli przez czas trwania sygnału, aby uzyskać bitrate.
% 
