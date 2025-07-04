L = load('adsl_x.mat');
x = L.x;

M = 32;  % Długość prefiksu
N = 512; % Długość bloku danych
segment_length = M + N;
K = round(length(x) / segment_length);

prefix_starts = zeros(1, K);
for k = 1:K
    segment_start = (k-1) * segment_length + 1;
    prefix = x(segment_start:segment_start+M-1);
    if k == 4
        suffix = x(segment_start+N:2049);
    else
        suffix = x(segment_start+N:segment_start+N+M-1);
    end
    
    % Korelacja krzyżowa
    [corr_val, lag] = xcorr(prefix, suffix);
    [~, max_idx] = max(corr_val);
    prefix_starts(k) = segment_start + max_idx;
end

% Wyświetlenie wyników
figure;
plot(x);
hold on;
stem(prefix_starts, x(prefix_starts), 'r');
title('Wykryte początki prefiksów w sygnale ADSL');
xlabel('Próbki'); ylabel('Amplituda'); grid on;
