function x_hat = synthesis(sbq, ch)
% sbq - MxN zakodowane podpasma
% ch  - struktura z filtrami

M = size(sbq,1);  % liczba podpasm
N = size(sbq,2);  % liczba ramek

x_hat = zeros(1, N*M);  % prealokacja

for m = 1:M
    % Upsampling każdego pasma
    upsampled = upsample(sbq(m,:), M);
    
    % Przefiltrowanie filtrem syntezy
    filtered = filter(ch.synthesis_filter(m,:), 1, upsampled);
    
    % Sumowanie sygnałów z różnych podpasm
    x_hat = x_hat + filtered;
end

end
