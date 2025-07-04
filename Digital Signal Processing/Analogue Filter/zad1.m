clear all;
close all;
p12 = -0.5+9.5i;
p21 = -0.5-9.5i;
p34 = -1+10i;
p43 = -1-10i;
p56 = -0.5+10.5i;
p65 = -0.5-10.5i;
z12 = -5i;
z21 = 5i;
z34 = -15i;
z43 = 15i;
Z = [z12,z21,z34,z43];
P =[p12,p21,p34,p43,p56,p65];
K = 1;
% Y = 1;
% w = 10;
% X=1;
% for z = Z 
%     Y = Y*(w*1i-z);
% end
% for p = P 
%     X = X*(w*1i-p);
% end
% H = K*(Y/X);

figure;
hold on;
plot(real(Z), imag(Z), 'o', 'MarkerSize', 10, 'LineWidth', 2); % zera
plot(real(P), imag(P), '*', 'MarkerSize', 10, 'LineWidth', 2); % bieguny
xlabel('Re');
ylabel('Im');
title('Płaszczyzna zespolona: zera (o) i bieguny (*)');
grid on;
legend('Zera', 'Bieguny');
hold off;

b = K * poly(Z); 
a = poly(P);    

w = linspace(0, 50, 1000); 
s = 1i * w;

H = polyval(b, s) ./ polyval(a, s);

magH = abs(H);

% Wykres w skali liniowej
figure;
plot(w, magH, 'LineWidth', 2);
xlabel('\omega [rad/s]');
ylabel('|H(j\omega)|');
title('Charakterystyka amplitudowa (skala liniowa)');
grid on;

% Wykres w skali decybelowej
figure;
plot(w, 20 * log10(magH), 'LineWidth', 2);
xlabel('\omega [rad/s]');
ylabel('20log_{10}|H(j\omega)| [dB]');
title('Charakterystyka amplitudowa (skala decybelowa)');
grid on;