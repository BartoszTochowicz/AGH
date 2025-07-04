function x_hat = dekodowanie_podpasmowe(sbq, ch, bps_per_band, sf)
% sbq         - zakodowane podpasma (matryca MxN)
% ch          - struktura z filtrami i parametrami (np. ch.analysis_filter)
% bps_per_band - liczba bitów przypisana każdemu z M podpasm
% sf          - współczynnik skalowania (ten sam co w koderze)

% Oblicz kwantyzator na podstawie liczby bitów na pasmo
q = 2.^bps_per_band(:);           % Liczba poziomów kwantyzacji
qq = diag(sparse(q));
qq_1 = diag(sparse(1./q));

% Odwrotne skalowanie
sbq_rescaled = full(qq_1 * sf^-1 * sbq);

% Zastosuj filtry syntezy (rekonstrukcja sygnału)
x_hat = synthesis(sbq_rescaled, ch);

end
