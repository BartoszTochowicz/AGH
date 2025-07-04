function [C] = czebyszew(n,x)
    if n == 0
        C = 1;
        return;
    end
    if n == 1
        C = x;
        return;
    end
    C = 2*x.*czebyszew(n-1,x)-czebyszew(n-2,x);
end