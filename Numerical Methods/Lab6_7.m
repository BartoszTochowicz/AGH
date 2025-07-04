clear all;
x = linspace(-1, 1, 1000); % Wektor x od -1 do 1 z dużą liczbą punktów
C = zeros(8,length(x));
for i = 1:1:8
    C(i,:) = czebyszew(i,x);
end
figure;
hold on;
for n = 0:7
    plot(x,C(n+1,:),'DisplayName',['C',num2str(n),'(x)']);
end
hold off;
grid on;
title('Wielomiany Czzebyszewa od C_0(x) do C_7(x)');
xlabel('x');
ylabel('C_n(x)');
legend show;