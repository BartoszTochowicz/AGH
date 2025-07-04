clear all;
close all;
[x,fs] = audioread("mowa.wav");
figure
plot(x);
M = 10;
N = 256;
xk = zeros(N,M);
probki = zeros(M,1);
for k = 1:M
    i = randi([1,length(x)-N]);
    probki(k) = i;
    xk(:,k) = x(i:i+N-1);
end
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
y = A*xk;
f = (0:N-1)*fs/(2*N);
for k = 1:M
    figure;
    subplot(2,1,1);
    plot(xk(:,k));
    title(['Fragment ', num2str(k)]);
    xlabel('Numer próbki');
    ylabel('Amplituda');

    subplot(2,1,2);
    plot(f,y(:,k));
    title(['Widmo DCT fragmentu ', num2str(k)]);
    xlabel('Częstotliwość [Hz]');
    ylabel('Amplituda');
end