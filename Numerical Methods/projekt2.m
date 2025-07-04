% Symulacja rozkładu ciepła na płytce 2D metodą Monte Carlo w Matlabie

% Parametry symulacji
n = 50;               % Rozmiar siatki
num_particles = 1000; % Liczba cząsteczek ciepła
num_steps = 5000;     % Liczba kroków symulacji
temp = zeros(n, n);   % Macierz temperatury

% Losowa inicjalizacja cząsteczek ciepła
particles = randi([1, n], num_particles, 2);

% Główna pętla symulacji Monte Carlo
for step = 1:num_steps
    for p = 1:num_particles
        % Losowy ruch cząsteczki ciepła
        direction = randi(4);
        switch direction
            case 1, particles(p,1) = max(particles(p,1)-1, 1); % góra
            case 2, particles(p,1) = min(particles(p,1)+1, n); % dół
            case 3, particles(p,2) = max(particles(p,2)-1, 1); % lewo
            case 4, particles(p,2) = min(particles(p,2)+1, n); % prawo
        end
        % Zwiększenie temperatury w aktualnej pozycji
        temp(particles(p,1), particles(p,2)) = temp(particles(p,1), particles(p,2)) + 1;
    end
end

% Normalizacja temperatury
temp = temp / max(temp(:));

% Wizualizacja końcowego rozkładu ciepła
figure;
imagesc(temp);
colormap(hot);
colorbar;
title('Symulacja rozkładu ciepła metodą Monte Carlo');
