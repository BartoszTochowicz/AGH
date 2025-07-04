function [sym,p] = prawdop_sym(x)
    sym = [];
    p = [];
    for i = 1:length(x)
        if ismember(x(i),sym)
            continue
        end
        sym(end+1) = x(i);
    end
    for i = 1:length(sym)
        count = sum(x(:)==sym(i));
        p(i) = count/length(x);
    end
end