clear all; close all; 

[x, fs] = audioread("mowa1.wav");
x = filter([1 -0.9735], 1, x); % preemfaza
x = x(:);

Mlen = 256;
Mstep = 180;
Np = 10;

N = length(x);
Nramek = floor((N - Mlen) / Mstep + 1);

lpc = [];
s = [];
residuals = {};

for nr = 1:Nramek
    n = 1 + (nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    if n(end) > length(x)
        break;
    end
    bx = x(n);
    bx = bx - mean(bx);

    % Autokorelacja
    for k = 0:Mlen-1
        r(k+1) = sum(bx(1:Mlen-k).*bx(1+k:Mlen));
    end

    offset = 20; rmax = max(r(offset:Mlen));
    imax = find(r == rmax, 1);
    if rmax > 0.35 * r(1)
        T = imax;
        isVoiced = true;
    else
        T = 0;
        isVoiced = false;
    end

    rr(1:Np,1) = r(2:Np+1)';
    for m = 1:Np
        R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))];
    end

    a = -inv(R)*rr;
    wzm = r(1) + r(2:Np+1)*a;

    if isVoiced
        % Oblicz resztkę (residual)
        residual = filter([1; a], 1, bx);

        % Widmo
        w = abs(fft(residual));
        % w = w(1:128);

        % Filtrowanie dolnoprzepustowe
        lp_filt = fir1(20,0.25 ,"low");  % filtr LP 21-elementowy
        w_filtered = conv(w, lp_filt, 'same');

        % Aproksymacja wielomianem
        p_order = 5;
        x_widmo = linspace(0, 1, length(w_filtered));
        poly_coeffs = polyfit(x_widmo, w_filtered(:)', p_order);

        % Odtworzenie uproszczonego widma w dekoderze
        w_approx = polyval(poly_coeffs, x_widmo);

        % Rekonstrukcja widma z symetrią
        full_spectrum = [w_approx, fliplr(w_approx)];
        pobudzenie = real(ifft(full_spectrum));

        % Dopasuj długość do ramki
        pobudzenie = pobudzenie(1:Mstep);
    else
        T = 0;
        pobudzenie = randn(1, Mstep);
    end

    % SYNTEZA
    bs = zeros(1, Np);
    ss = zeros(1, Mstep);

    for n = 1:Mstep
        if n <= length(pobudzenie)
            pob = pobudzenie(n);
        else
            pob = 0;
        end
        ss(n) = wzm * pob - bs * a;
        bs = [ss(n) bs(1:Np-1)];
    end

    s = [s ss];
end

% Deemfaza
s = filter(1, [1 -0.9735], s);

% Wynik
figure; plot(s); title('Mowa zsyntetyzowana z uproszczonego sygnału resztkowego');
soundsc(s, fs);