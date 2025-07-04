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
% soundsc(y,fs)


dq_adapt = kwant_adapt(1,d);

y_adapt = zeros(size(dq_adapt));
for n = 2:length(dq_adapt)
    y_adapt(n) = dq_adapt(n) + a*y_adapt(n-1);
end
N = length(x);
n = 1:N;
figure; plot( n, y_adapt*2e4, 'r' );
figure; plot( n, x, 'b', n, y_adapt*2e4, 'r' );
figure; plot(n(1:1000), d(1:1000), 'b', n(1:1000), dq(1:1000), 'r');
figure; plot(n(1:1000), d(1:1000), 'b', n(1:1000), dq_adapt(1:1000)*2e4, 'r');
figure; plot(n(1:1000), dq_adapt(1:1000)*2e4, 'r');