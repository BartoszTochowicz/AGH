clear all;
close all;

[x, fpr] = audioread("mowa1.wav");

x_dzwieczny = x(49537:49537+239);
% x_dzwieczny = x(287*180:287*180+239);
x_bez_dzwieczny = x(82816:82816+239);
x_przejsciowy = x(30744:30744+239);

figure;
plot(x); title('Sygnał mowy');

N = length(x_przejsciowy);
Mlen = 240;
Mstep = 180;
Np = 10;
gdzie = Mstep + 1;

lpc = [];
s = [];
ss = [];
bs = zeros(1,Np);
Nramek = floor((N - Mlen)/Mstep + 1);

x_przejsciowy = filter([1 -0.9735],1,x_przejsciowy);
x_bez_dzwieczny = filter([1 -0.9735],1,x_bez_dzwieczny);
x_dzwieczny = filter([1 -0.9735],1,x_dzwieczny);
x_all = {x_dzwieczny, x_bez_dzwieczny, x_przejsciowy}';
labels = {'Dźwięczna', 'Bezdźwięczna', 'Przejściowa'};

for i = 1:3
    fragment = x_all{i};
    label = labels{i};

    % a) sygnał czasowy i widmo przed i po preemfazie
    figure('Name', ['(a) ' label]);
    subplot(2,2,1); plot(fragment); title(['Sygnał czasowy - ' label]);
    subplot(2,2,2); pwelch(fragment); title('Widmo gęstości mocy (przed preemfazą)');

    fragment_preemf = filter([1 -0.9735],1,fragment);
    subplot(2,2,3); plot(fragment_preemf); title('Po preemfazie');
    subplot(2,2,4); pwelch(fragment_preemf); title('Widmo po preemfazie');

    s = [];
    for nr = 1:Nramek
        n = 1+(nr-1)*Mstep : Mlen+(nr-1)*Mstep;
        bx = fragment_preemf;
        bx = bx - mean(bx);

        % Autokorelacja
        for k = 0:Mlen-1
            r(k+1) = sum(bx(1:Mlen-k) .* bx(1+k:Mlen));
        end
        
        rr(1:Np,1) = r(2:Np+1)';
        for m = 1:Np
            R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))];
        end

        offset = 20;
        rmax = max(r(offset:Mlen));
        imax = find(r == rmax);

        if (rmax > 0.35*r(1))
            T = imax;
        else
            T = 0;
        end
        T
        a = -inv(R)*rr;
        wzm = r(1) + r(2:Np+1)*a;
        H = freqz(1, [1; a]);

        % Wykresy zgrupowane w jednej figurze
        figure('Name', ['(b) Analiza ' label ' - ramka #' num2str(nr)]);
        subplot(3,2,1); plot(n,bx); title('Fragment sygnału mowy');
        subplot(3,2,2); plot(r); hold on; yline(0.35*r(1), 'r--', 'Próg'); title('Autokorelacja');
        subplot(3,2,3); plot(abs(H)); title('Widmo filtra traktu głosowego');
        subplot(3,2,4); plot(bx); title('Sygnał przed progowaniem');
        subplot(3,2,5); plot(bx .* (rmax > 0.35*r(1))); title('Sygnał po progowaniu');

        lpc = [lpc; T; wzm; a];

        % SYNTEZA
        if T ~= 0
            gdzie = gdzie - Mstep;
            f0 = fpr / T;
            disp(['Fragment ' label ' to głoska dźwięczna, f0 = ' num2str(f0) ' Hz']);
        end

        for n = 1:Mstep
            if T == 0
                pob = 2*(rand(1,1) - 0.5);
                gdzie = gdzie + T;
            else
                if n == gdzie
                    pob = 1;
                    gdzie = gdzie + T;
                else
                    pob = 0;
                end
            end

            ss(n) = wzm*pob - bs*a;
            bs = [ss(n) bs(1:Np-1)];
        end

        s = [s ss];
    end

    s = filter(1, [1 -0.9735], s);

    % Porównanie oryginału i syntezy
    figure('Name', ['(c) Porównanie - ' label]);
    subplot(2,1,1); plot(fragment); title('Oryginalny fragment');
    subplot(2,1,2); plot(s); title('Zsyntezowany fragment');

    % Widmo porównawcze
    figure('Name', ['(d) Widma - ' label]);
    subplot(2,1,1); pwelch(fragment); title('Widmo oryginału');
    subplot(2,1,2); pwelch(s); title('Widmo syntezy');
end
