% Parametry
N = 10000; % Liczba próbek
mu = 3;    % Średnia docelowa
sigma = 2; % Odchylenie standardowe docelowe

% Generowanie liczb losowych r1 i r2
r1 = rand(1, N);
r2 = rand(1, N);

% Transformacja Boxa-Mullera
n1 = sqrt(-2 * log(r1)) .* cos(2 * pi * r2);
n2 = sqrt(-2 * log(r1)) .* sin(2 * pi * r2);

% Przekształcenie do N(mu, sigma^2)
n1_transformed = sigma * n1 + mu;
n2_transformed = sigma * n2 + mu;

% Wizualizacja
figure;

% Wykres 2D dla n1 i n2
subplot(2, 2, 1);
plot(n1, n2, 'b.', 'MarkerSize', 5);
title('Liczby n1 vs n2 (N(0,1))');
xlabel('n1'); ylabel('n2');
grid on;

% Histogram dla n1
subplot(2, 2, 2);
hold on;
histogram(n1, 20, 'FaceColor', 'blue', 'FaceAlpha', 0.7, 'DisplayName', 'N(0,1)');
histogram(n1_transformed, 20, 'FaceColor', 'red', 'FaceAlpha', 0.5, 'DisplayName', sprintf('N(%d,%d)', mu, sigma^2));
hold off;
title('Histogram n1');
legend;
grid on;

% Histogram dla n2
subplot(2, 2, 3);
hold on;
histogram(n2, 20, 'FaceColor', 'green', 'FaceAlpha', 0.7, 'DisplayName', 'N(0,1)');
histogram(n2_transformed, 20, 'FaceColor', 'magenta', 'FaceAlpha', 0.5, 'DisplayName', sprintf('N(%d,%d)', mu, sigma^2));
hold off;
title('Histogram n2');
legend;
grid on;

% Wykres 2D dla n1_transformed i n2_transformed
subplot(2, 2, 4);
plot(n1_transformed, n2_transformed, 'r.', 'MarkerSize', 5);
title(sprintf('Liczby n1_transformed vs n2_transformed (N(%d,%d))', mu, sigma^2));
xlabel('n1 transformed'); ylabel('n2 transformed');
grid on;

% Dostosowanie układu wykresów
sgtitle('Transformacja Boxa-Mullera i Przekształcenia Rozkładu');
