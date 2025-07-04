clear all;
close all;

[x, fpr] = audioread("mowa2.wav");
x = filter([1 -0.9735], 1, x); % preemfaza

Mlen = 240;
Mstep = 180;
Np = 10;

N = length(x);
Nramek = floor((N - Mlen) / Mstep + 1);
lpc = [];
gdzie = Mstep + 1;

for nr = 1:Nramek
    n = 1 + (nr - 1) * Mstep : Mlen + (nr - 1) * Mstep;
    bx = x(n);
    bx = bx - mean(bx);

    for k = 0:Mlen-1
        r(k+1) = sum(bx(1:Mlen-k).*bx(1+k:Mlen));
    end

    offset = 20; rmax = max(r(offset:Mlen)); 
    imax = find(r == rmax);
    if rmax > 0.35*r(1)
        T = imax(1);
    else
        T = 0;
    end

    rr = r(2:Np+1)';
    for m = 1:Np
        R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))];
    end

    a = -inv(R)*rr;
    G = r(1) + r(2:Np+1)*a;
    lpc = [lpc; T; G; a];
end

% KWANTYZACJA I SYNTEZA
bit_allocation = [8 6 6 4 4];
fs = fpr;
frame_count = size(lpc,1)/(Np+2);
bitrate_total = 0;
s_quant = [];
gdzie = 1;

for i = 1:frame_count
    idx = (i-1)*(Np+2);
    T = lpc(idx+1);
    G = lpc(idx+2);
    a = lpc(idx+3:idx+Np+2);

    A = [1; a];
    roots_a = roots(A);
    [~,sort_idx] = sort(abs(roots_a),'ascend');
    roots_a = roots_a(sort_idx);

    % Tworzenie par sprzężonych
    pairs = [];
    used = false(length(roots_a),1);
    for j = 1:length(roots_a)
        if used(j), continue; end
        rj = roots_a(j);
        for k = j+1:length(roots_a)
            if used(k), continue; end
            rk = roots_a(k);
            if abs(rj - conj(rk)) < 1e-3
                pairs = [pairs; [rj rk]];
                used(j) = true;
                used(k) = true;
                break;
            end
        end
    end

    % KWANTYZACJA
    new_roots = [];
    bits_used = 0;
    for k = 1:min(length(bit_allocation), size(pairs,1))
        r = pairs(k,1);
        mag = abs(r);
        ang = angle(r);

        mag_q = round(mag*(2^bit_allocation(k)-1)) / (2^bit_allocation(k)-1);
        ang_q = round((ang+pi)/(2*pi)*(2^bit_allocation(k)-1)) / (2^bit_allocation(k)-1)*2*pi - pi;

        rq = mag_q * exp(1j * ang_q);
        new_roots = [new_roots; rq; conj(rq)];
        bits_used = bits_used + bit_allocation(k)*2;
    end

    % Dodaj pozostałe bieguny
    rest = roots_a(~used);
    needed = Np - length(new_roots);
    if length(rest) >= needed
        new_roots = [new_roots; rest(1:needed)];
    else
        new_roots = [new_roots; rest; 0.9*exp(1j*2*pi*rand(needed - length(rest),1))];
    end

    new_a = -real(poly(new_roots(1:Np)));
    if any(isnan(new_a)) || any(isinf(new_a))
        continue;
    end

    % SYNTEZA
    bs = zeros(1,Np);
    ss = zeros(1,Mstep);
    for n = 1:Mstep
        if T == 0
            pob = 2*(rand-0.5);
        else
            if n == gdzie
                pob = 1;
                gdzie = gdzie + T;
            else
                pob = 0;
            end
        end
        ss(n) = G*pob - bs.*new_a';
        bs = [ss(n) bs(1:Np-1)];
    end
    s_quant = [s_quant ss];
    bitrate_total = bitrate_total + 8 + 6 + bits_used;
end

% Deemfaza
s_quant = filter(1, [1 -0.9735], s_quant);

% Bitrate
duration_sec = length(x) / fs;
bitrate_bps = bitrate_total / duration_sec;

fprintf('\n>>> Przepływność bitowa po kwantyzacji biegunów: %.2f bitów/s\n', bitrate_bps);

% Wykresy i dźwięk
figure;
subplot(2,1,1); plot(x); title("Oryginalny sygnał mowy");
subplot(2,1,2); plot(s_quant); title("Sygnał po kwantyzacji biegunów");
soundsc(s_quant, fs);
