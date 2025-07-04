function s=rand_mult( N, seed )
    a = 69069;
    p = 2^12;
    s = zeros(N,1);
    for i=1:N
        s(i) = mod(seed*a,p);
        seed = s(i);
    end
    s = s/p;
end