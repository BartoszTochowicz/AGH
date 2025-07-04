clear all;
close all;

f1 = 1001.2; fs1 = 8000;
f2 = 303.1;  fs2 = 32000;
f3 = 2110.4; fs3 = 48000;

t1 = (0:1/fs1:1-1/fs1)';
t2 = (0:1/fs2:1-1/fs2)';
t3 = (0:1/fs3:1-1/fs3)';
x1 = sin(2*pi*f1*t1);
x2 = sin(2*pi*f2*t2);
x3 = sin(2*pi*f3*t3);  

fs4 = 48000;
t_common = (0:1/fs4:1-1/fs4)';
function y_interp = sinc_interp(x, t_original, t_target, fs_source)
    y_interp = zeros(size(t_target));
    span = 30;  % liczba próbek lewo/prawo do wzięcia pod uwagę
    for i = 1:length(t_target)
        t = t_target(i);
        idxs = find(abs(t_original - t) < span/fs_source); 
        sinc_vals = sinc(fs_source * (t - t_original(idxs)));
        y_interp(i) = sum(x(idxs) .* sinc_vals);
    end
end

% Interpolacja
x1_sinc = sinc_interp(x1, t1, t_common, fs1);
x2_sinc = sinc_interp(x2, t2, t_common, fs2);
x3_interp = x3;  % już w 48 kHz

% Sumowanie
x4 = x1_sinc + x2_sinc + x3_interp;

% Oczekiwany sygnał
x4_expected = sin(2*pi*f1*t_common) + sin(2*pi*f2*t_common) + sin(2*pi*f3*t_common);

% Obliczanie błędu rekonstrukcji
error = x4_expected - x4;
MAE = mean(abs(error));
MSE = mean(error.^2);

fprintf("MAE = %.5f\n", MAE);
fprintf("MSE = %.5f\n", MSE);

% Wykres
figure;
plot(t_common, x4); hold on;
plot(t_common, x4_expected, '--r');
legend('x4 z sinc', 'x4 oczekiwany');
title('x4 – po rekonstrukcji metodą sinc');





% t_max = min([t1(end), t2(end), t3(end)]);
% t_common = (0:1/fs4:t_max)';
% 
% % Interpolacja liniowa
% x1_interp_2 = interp1(t1, x1, t_common, 'linear', 'extrap');
% x2_interp_2 = interp1(t2, x2, t_common, 'linear', 'extrap');
% x3_interp = interp1(t3, x3, t_common, 'linear', 'extrap');
% 
% % Sumowanie
% x4 = x1_interp_2 + x2_interp_2 + x3_interp;
% 
% % Normalizacja
% % x4 = x4 / max(abs(x4));
% 
% % Wzorzec
% x4_expected = sin(2*pi*f1*t_common) + sin(2*pi*f2*t_common) + sin(2*pi*f3*t_common);
% 
% % Błędy
% error = x4_expected - x4;
% MAE = mean(abs(error));
% MSE = mean(error.^2);
% 
% % Wyniki
% fprintf("MAE = %.5f\n", MAE);
% fprintf("MSE = %.5f\n", MSE);
% 
% % Wykres
% figure;
% plot(t_common, x4); hold on;
% plot(t_common, x4_expected, '--r');
% legend('x4 z TOiWT', 'x4 oczekiwany');
% title('x4 po interpolacji liniowej');