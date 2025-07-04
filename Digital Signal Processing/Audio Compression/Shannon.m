function H = Shannon(x,N,p,sym)
    H = 0;
    for n = 1:N
        for i = 1:length(sym)
            if x(n) == sym(i)
                p_sym = p(i);
            end
        end
        H = H + p_sym*log2(p_sym);
    end
    H = -H;
end
