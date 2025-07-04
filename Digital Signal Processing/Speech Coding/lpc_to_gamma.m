function gamma = lpc_to_gamma(a)
    p = length(a);
    a_mat = zeros(p, p);       % a_mat(i,j) = a^{(i)}_j
    a_mat(p,1:p) = a(:)';      % ostatni wiersz to a_p
    gamma = zeros(p,1);

    for i = p:-1:1
        gamma(i) = -a_mat(i,i); % γ_i = -a_ii

        if abs(gamma(i)) >= 1
            warning('Filter may be unstable: |γ| >= 1 at i = %d', i);
        end

        for j = 1:i-1
            a_mat(i-1,j) = (a_mat(i,j) + gamma(i)*a_mat(i,i-j)) / (1 - gamma(i)^2);
        end
    end
end
