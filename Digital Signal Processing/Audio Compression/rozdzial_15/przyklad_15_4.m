% przyklad 15.4

% Przygotowanie wektora kolumnowego probek funkcji liniowo rosnacej
x = (1:100)';
% Obliczenie transformaty i odwrotnej transformaty
F = dct4(x);
y = idct4(F);

% Wykresy 
figure(1)
plot([x [-x(end/2:-1:1); x(end:-1:end/2+1)] y])
legend('Oryginalny','Nakladki','Wynik transformaty odwrotnej')

disp('Prosze nacisnac dowolny klawisz');
pause

% Przygotowanie wektora probek przykladowego sygnalu
t = (1:1e3)';
x = exp(-3*t/1e3).*cos(2*pi*t.^2/1e5);
% Obliczenie transformaty i odwrotnej transformaty
F = dct4(x);
y = idct4(F);

% Wykresy 
plot([x [-x(end/2:-1:1); x(end:-1:end/2+1)] y])
legend('Oryginalny','Nakladki','Wynik transformaty odwrotnej')


disp('Prosze nacisnac dowolny klawisz');
pause

% Przygotowanie wektora probek przykladowego sygnalu
t = linspace(-5,5,1e4)';
x = sinc(t);
% Obliczenie transformaty i odwrotnej transformaty
F = dct4(x);
y = idct4(F);

% Wykresy 
plot([x [-x(end/2:-1:1); x(end:-1:end/2+1)] y])
legend('Oryginalny','Nakladki','Wynik transformaty odwrotnej')
