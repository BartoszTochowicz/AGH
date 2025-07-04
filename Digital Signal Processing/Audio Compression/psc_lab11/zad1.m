clear all;
close all;
[x,fs] = audioread( 'DontWorryBeHappy.wav', 'native' ); % wczytanie próbki dźwiękowej
x = double( x(:,1) );
% figure
% print(x)
a = 0.9545; % parametr a kodera
d = x - a*[ 0; x(1:end-1) ]; % KODER

min_d = min(d);
max_d = max(d);

n_bit = 4;
L = n_bit^2;

dq = lab11_kwant( d,L); % kwantyzator
% tutaj wstaw dekoder

y = zeros(size(dq));
for n = 2:length(dq)
    y(n) = dq(n) + a*y(n-1);
end
% figure( 1 );
% n=1:length(x);
% plot( n, x, 'b', n, dq, 'r' );

n = 1:length(x);
figure;
plot(1:length(x), x, 'b', 1:length(x), y, 'r--');
legend('Oryginalny x(n)', 'Zrekonstruowany y(n)');
title('Porównanie DPCM z kwantyzacją 4-bitową');
xlabel('Numer próbki'); ylabel('Amplituda');

% === Obliczenie błędu MSE ===
mse = mean((x - y).^2);
fprintf('MSE błędu rekonstrukcji: %.6f\n', mse);
soundsc(y,fs)