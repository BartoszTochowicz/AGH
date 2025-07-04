function s=rand_multadd( N, seed )
    % GNU Compiler Collection
    a = 69069;
    m = 5;
    % POSIX C
    % a = 1103515245;
    % m = 12345;
    p = 2^32;
    s = zeros(N,1);
    for i=1:N
        s(i) = mod(seed*a+m,p);
        seed = s(i);
    end
    s = s/p;
    seed = 123;
    seed_test = seed;
    period = 0;
    max_iterations = 1e6;
    while true
        seed_test = mod(seed_test*a + m, p);
        period = period + 1;
        if seed_test == seed || period > max_iterations
            fprintf('Okres generatora: %d\n', period);
            break;
        end
    end
end