% Symulacja przewodnictwa cieplnego metodą Monte Carlo i równaniami różniczkowymi

% Parametry symulacji
L = 1;  % długość przewodnika [m]
Nx = 50; % liczba węzłów w siatce
Tmax = 1; % czas symulacji [s]
Nt = 100; % liczba kroków czasowych
dx = L/(Nx-1);
dt = Tmax/Nt;
alpha = 0.01; % współczynnik przewodnictwa cieplnego

% Warunki początkowe i brzegowe
T = zeros(Nx,1);
T(1) = 100; % temperatura na lewym brzegu [C]

% Monte Carlo - generowanie losowych trajektorii
num_particles = 10000; % liczba cząstek
final_temperatures = zeros(Nx,1);

for p = 1:num_particles
    x = 1; % start na lewym brzegu
    time = 0;
    while time < Tmax
        x = x + sign(randn); % losowy ruch w lewo lub prawo
        x = max(1, min(Nx, x));
        time = time + dt;
    end
    final_temperatures(x) = final_temperatures(x) + 1;
end

% Normalizacja temperatury
final_temperatures = final_temperatures / num_particles * T(1);

% Rozwiązanie równania przewodnictwa cieplnego metodą różnic skończonych
T_fd = T;
for t = 1:Nt
    T_new = T_fd;
    for i = 2:Nx-1
        T_new(i) = T_fd(i) + alpha*dt/dx^2 * (T_fd(i-1) - 2*T_fd(i) + T_fd(i+1));
    end
    T_fd = T_new;
end

% Wizualizacja wyników
x = linspace(0, L, Nx);
figure;
plot(x, final_temperatures, 'r', 'LineWidth', 2);
hold on;
plot(x, T_fd, 'b--', 'LineWidth', 2);
legend('Monte Carlo', 'Różnice Skończone');
xlabel('Pozycja [m]'); ylabel('Temperatura [C]');
title('Symulacja przewodnictwa cieplnego');
