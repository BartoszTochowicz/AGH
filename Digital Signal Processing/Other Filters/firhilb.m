function h = firhilb(M, win)
    % M = rząd filtra (parzysty!), win = wektor okna np. hamming(M+1)
    h = zeros(1, M+1);
    for n = 1:M+1
        k = n - (M+1)/2;
        if mod(k,2)==1
            h(n) = 2/(pi*k);
        else
            h(n) = 0;
        end
    end
    h = h .* win(:)'; % zastosuj okno
end