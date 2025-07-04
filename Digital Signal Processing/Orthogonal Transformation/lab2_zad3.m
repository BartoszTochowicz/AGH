clear all;
close all;
N = 100;
fs = 1000;
f1 = 50;
f2 = 100;
f3 = 150;
A1 = 50;
A2 = 100;
A3 = 150;

t = 0:1/fs:(N-1)/fs;
x = A1*sin(2*pi*t*f1)+A2*sin(2*pi*t*f2)+A3*sin(2*pi*t*f3);
A = zeros(N,N);
for k = 0:N-1
    if k == 0
        s = sqrt(1/N);
    else
        s = sqrt(2/N);
    end
    for n = 0:N-1
        A(k+1,n+1) = s*cos(pi*(k/N) *(n+0.5));
    end
end
S = inv(A);
% hold on
% figure;
% for i = 1:N
%     plot(A(i, :)); hold on;
%     plot(S(:, i)); 
%     hold off;
%     title(['Wiersz ' num2str(i) ' macierzy A i kolumna ' num2str(i) ' macierzy S']);
%     pause(0.2);
% end

y = A * x'; % Obliczenie współczynników DCT
% Wyskalowanie osi częstotliwości
f = (0:N-1) * fs / (2*N);
figure;
stem(f, y);
title('Widmo sygnału po DCT');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');
legend('Współczynniki DCT');

% Perfekcyjna rekonstrukcja
xr = S * y;
if all(abs(xr' - x) < 1e-10)
    disp('Perfekcyjna rekonstrukcja!');
else
    disp('Rekonstrukcja niedokładna.');
end

% Zmiana f2 na 105 Hz
f2 = 105;
x2 = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);
y2 = A * x2';

figure;
stem(f, y2);
title('Widmo sygnału po DCT dla f2 = 105 Hz');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');

% Sprawdzenie rekonstrukcji
xr2 = S * y2;
if all(abs(xr2' - x2) < 1e-10)
    disp('Perfekcyjna rekonstrukcja dla f2 = 105 Hz!');
else
    disp('Rekonstrukcja niedokładna dla f2 = 105 Hz.');
end


% Zwiększenie częstotliwości o 2.5 Hz
f1 = 52.5;
f2 = 102.5;
f3 = 152.5;
x3 = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);
y3 = A * x3';

figure;
stem(f, y3);
title('Widmo sygnału po DCT dla przesunięcia częstotliwości o 2.5 Hz');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');
