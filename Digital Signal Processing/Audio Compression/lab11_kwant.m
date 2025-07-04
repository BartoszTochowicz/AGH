function dq = lab11_kwant(d, L)
    % Kwantyzacja typu mid-riser z ograniczeniem outlierów (clipping)
    perc = 99.2;  % użyj 99% energii sygnału
    lim = prctile(abs(d), perc);  % np. 99-ty percentyl amplitudy

    xmax = lim;  % ogranicz zasięg
    delta = 2 * xmax / L; % krok kwantyzacji

    indices = floor((d + xmax) / delta);
    indices = max(0, min(indices, L-1));

    dq = -xmax + delta/2 + indices * delta;
end
