function a = gamma_to_lpc(gamma)
    p = length(gamma);
    a_mat = zeros(p, p);  % a_mat(i,j) = a^{(i)}_j

    for i = 1:p
        a_mat(i,i) = -gamma(i);
        for j = 1:i-1
            a_mat(i,j) = a_mat(i-1,j) + gamma(i) * a_mat(i-1,i-j);
        end
    end

    a = a_mat(p,1:p)';
end
