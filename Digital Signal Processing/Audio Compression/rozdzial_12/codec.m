% program uproszczonego kodera CELP

function speechout=codec(speech, fe, N, K, M_sf, P_perc, gamma, dico_celp, Nbre_fen,  visu)

% wartosci poczatkowe
speechout=zeros(length(speech),1);
inits=0;
initso=0;
L2 = size(dico_celp,2); % liczba wektorow w slowniku

pn_r = zeros(N,1); % ramka sygnalu percepcyjnego
xn_r = zeros(N,1); % ramka sygnalu mowy

etat_ma_perc_r  = zeros(P_perc,1); % pamieci filtrow
etat_ar_perc_r  = zeros(P_perc,1);
etat_ar_mod  = zeros(P_perc,1);
etat_ma_perc = zeros(P_perc,1);
etat_ar_perc = zeros(P_perc,1);
ringing = zeros(M_sf,1);  % "dzwonienie" (zero input response)

visu_xn      = zeros(6*N,1); % bufory wizualizacji
visu_pn      = zeros(6*N,1);
visu_xn_hat = zeros(6*N,1);
visu_pn_hat = zeros(6*N,1);
visu_entr   = zeros(6*N,1);

axe_freq = (0:N/2-1)'/N*fe/1000;

snr_x=zeros(Nbre_fen,1); % snr w segmentach mowy
snr_p=zeros(Nbre_fen,1); % snr w segmentach sygnalu percepcyjnego

% Petla ramek
for no_fen = 1:Nbre_fen
    if visu
        fprintf('%3d ', no_fen)
    end
    
    xn_r = speech(inits+1:inits+N); % odczytanie ramki sygnalu
    inits=inits+N;
    
    rk = zeros(P_perc+1, 1);    % autokorelacje
    for k = 0:P_perc
        rk(k+1) = xn_r(1:N-k)'*xn_r(k+1:N)/N;
    end
    rk(1) = rk(1)*1.001+10^(-10);  % zabezpieczenie przed sygnalem zerowym
    ai = [1; -inv(toeplitz(rk(1:P_perc)))*rk(2:P_perc+1)]; % wspolczynniki predykcji
    ai_gamma = ai.*gamma.^(0:P_perc)';                     % jw, z tlumieniem
    
    % preemfaza
    [temp, etat_ma_perc_r]= filt_ma(ai, xn_r(1:N), etat_ma_perc_r);
    [temp, etat_ar_perc_r]= filt_ar(1, ai_gamma, temp, etat_ar_perc_r);
    pn_r(1:N) = temp;       % sygnal percepcyjny
    
    % Modelowanie CELP: en  => en_hat
    en = pn_r(1:N);
    dico_f = zeros(size(dico_celp));
    energies = zeros(1,L2);
    for l = 1:L2   % filtracja slownika CELP
        dico_f(:,l) = filter(1, ai_gamma, dico_celp(:,l));
        energies(l) = dico_f(:,l)'*dico_f(:,l);
    end
    en_hat = zeros(N,1);
    entry  = zeros(N,1);   % bufor dla wizualizacji sygnalu pobudzajacego
    
    Nbre_sfen = N/M_sf;           % petla "podramek" (wektorow)
    for no_sous_fen = 1:Nbre_sfen
        entree=zeros(M_sf,1);
        n1 = (no_sous_fen-1)*M_sf + 1;
        n2 = no_sous_fen*M_sf;
        target = en(n1:n2) - ringing; % sygnal docelowy
        
        targ=target;
        
        for iter=1:K                           % modelowanie w K krokach
            temp = ((targ'*dico_f).^2)./energies;
            [val_max, index_max] = max(temp);     % wybor wektora ze slownika
            gain = targ'*dico_f(:,index_max)/energies(index_max); % wzmocnienie
            targ=targ-gain*dico_f(:,index_max);
            entree = entree+gain*dico_celp(:,index_max);
        end
        
        [temp, etat_ar_mod] = filt_ar(1, ai_gamma, entree, etat_ar_mod);
        en_hat(n1:n2) = temp;  % model sygnalu percepcyjnego
        entry(n1:n2) = entree;
        
        ringing = filt_ar(1, ai_gamma, zeros(M_sf,1), etat_ar_mod); % "dzwonienie"
    end
    pn_hat = en_hat;
    %%% pn_hat=pn_r;  % test: odblokowanie tej instrukcji prowadzi do bezblednego modelowania
    
    % Filtracja  pn_hat => xn_hat  (deemfaza)
    temp = pn_hat(1:N);
    [temp, etat_ma_perc]= filt_ma(ai_gamma, temp, etat_ma_perc);
    [temp2, etat_ar_perc]= filt_ar(1, ai, temp, etat_ar_perc);
    xn_hat = temp2;  % model sygnalu mowy (sygnal wyjsciowy dekodera CELP)
    
    speechout(initso+1:initso+N)=xn_hat; % zapis ramki sygnalu wyjsciowego
    initso=initso+N;
    
    % snr
    temp = norm(pn_r(1:N))/(norm(pn_r(1:N)-pn_hat)+10^(-10));
    rsb_pn = max([20*log10(temp+0.000001),0]);
    snr_p(no_fen)= rsb_pn;    % snr dla ramki sygnalu percepcyjnego
    temp = norm(xn_r(1:N))/(norm(xn_r(1:N)-xn_hat)+10^(-10));
    rsb_xn = max([20*log10(temp+0.000001),0]);
    snr_x(no_fen)= rsb_xn;    % snr dla ramki mowy
    fprintf(' snr_percep = %4.1f snr_speech = %4.1f \n', rsb_pn, rsb_xn)
    
    % wizualizacje
    if visu
        
        n5 = length(visu_xn);
        n1 = n5 - N + 1;
        
        visu_xn(1:n1-1) = visu_xn(N+1:n5);
        visu_xn(n1:n5) = xn_r(1:N);
        
        visu_xn_hat(1:n1-1) = visu_xn_hat(N+1:n5);
        visu_xn_hat(n1:n5) = xn_hat;
        
        visu_err_mod = visu_xn(1:n5) - visu_xn_hat(1:n5);
        Vmax_xn = max(abs(visu_xn))+10^(-10);
        
        Xk = period(visu_xn(n1:n5));
        
        Xk_hat = period(visu_xn_hat(n1:n5));
        
        Ek_mod = period(visu_err_mod(n1:n5));
        
        
        visu_pn(1:n1-1) = visu_pn(N+1:n5);
        visu_pn(n1:n5) = pn_r(1:N);
        
        visu_pn_hat(1:n1-1) = visu_pn_hat(N+1:n5);
        visu_pn_hat(n1:n5) = pn_hat;
        
        visu_err_pmod = visu_pn(1:n5) - visu_pn_hat(1:n5);
        Vmax_pn = max(abs(visu_pn))+10^(-10);
        
        Pk = period(visu_pn(n1:n5));
        
        Pk_hat = period(visu_pn_hat(n1:n5));
        
        Ek_pmod = period(visu_err_pmod(n1:n5));
        
        visu_entr(1:n1-1) = visu_entr(N+1:n5);
        visu_entr(n1:n5) = entry(1:N);
        
        Vmax_en = max(abs(visu_entr))+10^(-10);
        
        Enk = period(visu_entr(n1:n5));
        
        
        figure(1), hold off
        plot(visu_xn), hold on
        plot(visu_xn_hat, 'r')
        plot(visu_err_mod, 'g')
        plot([n1 n1], [-1.1*Vmax_xn 1.1*Vmax_xn], ':')
        plot([n1 n1], [-1.1*Vmax_xn 1.1*Vmax_xn])
        plot([n5 n5], [-1.1*Vmax_xn 1.1*Vmax_xn], ':')
        axis([1 length(visu_xn) -1.1*Vmax_xn 1.1*Vmax_xn])
        title('sygnal we, wy, blad')
        
        figure(2), hold off
        plot(axe_freq, Xk), hold on
        plot(axe_freq, Xk_hat, 'r')
        plot(axe_freq, Ek_mod, 'g')
        % axis([0 16 0 100])
        title('widma s. we, wy, bledu')
        
        figure(3), hold off
        plot(visu_pn), hold on
        plot(visu_pn_hat, 'r')
        plot(visu_err_pmod, 'g')
        plot([n1 n1], [-1.1*Vmax_pn 1.1*Vmax_pn], ':')
        plot([n1 n1], [-1.1*Vmax_pn 1.1*Vmax_pn])
        plot([n5 n5], [-1.1*Vmax_pn 1.1*Vmax_pn], ':')
        axis([1 length(visu_pn) -1.1*Vmax_pn 1.1*Vmax_pn])
        title('sygnal percepcyjny: we, wy, blad')
        
        figure(4), hold off
        plot(axe_freq, Pk), hold on
        plot(axe_freq, Pk_hat, 'r')
        plot(axe_freq, Ek_pmod, 'g')
        title('widma s. percep.: we, wy, bledu')
        
        figure(5), hold off
        plot(visu_entr), hold on
        plot([n1 n1], [-1.1*Vmax_en 1.1*Vmax_en], ':')
        plot([n1 n1], [-1.1*Vmax_en 1.1*Vmax_en])
        plot([n5 n5], [-1.1*Vmax_en 1.1*Vmax_en], ':')
        axis([1 length(visu_entr) -1.1*Vmax_en 1.1*Vmax_en])
        title('sygnal pobudzajacy filtr syntezy')
        
        figure(6), hold off
        plot(axe_freq, Enk), hold on
        title('widmo sygnalu pobudzajacego')
        drawnow
        fprintf('pause \n'); pause
    end
end

fprintf('\n')
SNR_dB=mean(snr_x)
SNR_percep_dB=mean(snr_p)

figure(7), hold off
plot(snr_x), hold on
plot(snr_p,'r'), hold on
title('SNR(dB) w segmentach: syg. mowy (nieb.) i percepcyjny (czerw.)')
