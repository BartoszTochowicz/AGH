function [y, e, h] = adaptTZ(d, x, M, mi, gamma, lambda, delta, ialg)
    h = zeros(M,1);            % wagi filtra
    bx = zeros(M,1);           % bufor wejściowy
    Rinv = delta * eye(M);     % dla RLS, ale nieużywane tutaj

    for n = 1:length(x)
        bx = [x(n); bx(1:M-1)];     % aktualizacja bufora
        y(n,1) = h' * bx;           % filtracja
        e(n,1) = d(n) - y(n);       % błąd

        if ialg == 1
            % LMS
            h = h + mi * e(n) * bx;
        elseif ialg == 2
            % NLMS
            energy = bx' * bx;
            h = h + mi / (gamma + energy) * e(n) * bx;
        else
            % RLS (nieużywane w tym zadaniu)
            Rinv = (Rinv - Rinv*bx*bx'*Rinv/(lambda + bx'*Rinv*bx)) / lambda;
            h = h + Rinv * bx * e(n);
        end

        % % Co 100 próbek rysuj charakterystykę częstotliwościową filtra
        % if mod(n, 100) == 0
        %     f = 0:fs/2000:fs/2;
        %     H = freqz(h, 1, f, fs);
        %     plot(f, abs(H));
        %     % axis([0 fs/2 0 1.2])
        %     xlabel('Częstotliwość [Hz]');
        %     ylabel('|H(f)|');
        %     title(['Charakterystyka filtra adaptacyjnego, próbka n = ', num2str(n)]);
        %     drawnow;
        % end
    end
end