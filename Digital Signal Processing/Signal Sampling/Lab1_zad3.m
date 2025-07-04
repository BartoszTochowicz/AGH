load('adsl_x.mat'); 
x = x(:); % Zamiana na wektor

M = 32;
N = 512;
block_size = M + N; % 544

% Pobranie pierwszego prefiksu (ostatnie 32 próbki pierwszego bloku)
prefix = x(N+1:N+M);

% Korelacja krzyżowa
[corr, lags] = xcorr(x, prefix);

% Znalezienie największych wartości korelacji co 544 próbek
[~, locs] = findpeaks(corr, 'MinPeakDistance', block_size);

% Konwersja do indeksów w oryginalnym sygnale
prefix_starts = lags(locs) + 1;

% Usunięcie ujemnych indeksów
prefix_starts = prefix_starts(prefix_starts > 0);

disp('Indeksy początków prefiksów:');
disp(prefix_starts);
