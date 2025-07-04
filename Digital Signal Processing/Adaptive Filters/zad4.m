clear all;
close all;
load("ECG100.mat");
ecg = val(1,:);
fm = 50;
fpr = 360;
N_ecg = length(ecg);
t = 0:1/fpr:(N_ecg-1)/fpr;
z = sin(2*pi*t*fm);

d = ecg+z;

M = 250;
mi = 0.00001;

bx = zeros(M,1);
h = zeros(M,1);
y = zeros(1, N_ecg);      % wyjście filtra = aproksymacja zakłócenia
e = zeros(1, N_ecg);      % wyjście układu = "oczyszczony" sygnał

for n = 1:N_ecg
    bx = [z(n); bx(1:M-1)];        % bufor wejściowy = zakłócenie 50 Hz
    y(n) = h' * bx;                % wyjście filtra adaptacyjnego
    e(n) = d(n) - y(n);            % oczyszczony sygnał
    h = h + 2 * mi * e(n) * bx;    % aktualizacja wag (LMS)
end

subplot(3,1,1);
plot(t, ecg);
title('Oryginalny sygnał EKG');

subplot(3,1,2);
plot(t, d);
title('Sygnał EKG z zakłóceniem 50 Hz');

subplot(3,1,3);
plot(t, e);
title('Sygnał EKG po filtracji adaptacyjnej');
xlabel('Czas [s]');


Fs = fpr;
nfft = 2^nextpow2(N_ecg);
f = Fs*(0:(nfft/2))/nfft;
E = abs(fft(e, nfft));
D = abs(fft(d, nfft));

figure;
plot(f, 20*log10(D(1:nfft/2+1)), 'r');
hold on;
plot(f, 20*log10(E(1:nfft/2+1)), 'b');
legend('Przed filtracją', 'Po filtracji');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
title('Widmo przed i po filtracji');


% opcjonalne 

% load("ECG100.mat");
% ecg = val(1,:);
% fm = 50;
% fpr = 360;
% N_ecg = length(ecg);
% t = 0:1/fpr:(N_ecg-1)/fpr;
% z = sin(2*pi*t*fm);
% 
% ecg_noisy = ecg+z;
% 
% M = 250;
% mi = 0.00001;
% 
% bx = zeros(M,1);
% h = zeros(M,1);
% y = zeros(1, N_ecg);     
% e = zeros(1, N_ecg);      
% 
% 
% emg_noise = 2*(randn(size(ecg))-0.5); 
% [b_emg, a_emg] = butter(4, 50/(fpr/2), 'low'); 
% emg_filtered = filter(b_emg, a_emg, emg_noise);
% ecg_noisy_emg = ecg_noisy + emg_filtered;
% 
% 
% % for n = 1:N_ecg
% %     bx = [z(n); bx(1:M-1)];        % bufor wejściowy = zakłócenie 50 Hz
% %     y(n) = h' * bx;                % wyjście filtra adaptacyjnego
% %     e(n) = d(n) - y(n);            % oczyszczony sygnał
% %     h = h + 2 * mi * e(n) * bx;    % aktualizacja wag (LMS)
% % end
% 
% x_ref = z(:);
% d = ecg_noisy_emg(:);
% gamma = 1e-6; lambda = 0.99; delta = 1000; % nieużywane w LMS
% ialg = 1; 
% 
% [y_LMS, e_LMS, h_LMS] = adaptTZ(d, x_ref, M, mi, gamma, lambda, delta, ialg);
% 
% 
% M = 10;
% mi = 0.0001;
% h_pred = zeros(M,1);
% e_pred = zeros(size(d));
% y_pred = zeros(size(d));
% bx = zeros(M,1);
% 
% epsilon = 1e-6;
% for n = M+1:length(d)
%     x = d(n-1:-1:n-M);
%     y_pred(n) = h_pred' * x;
%     e_pred(n) = d(n) - y_pred(n);
% 
%     norm_factor = x' * x + epsilon;
%     h_pred = h_pred + (mi / norm_factor) * e_pred(n) * x;
% end
% 
% 
% figure;
% subplot(3,1,1); plot(d); title('Zakłócony sygnał EKG');
% subplot(3,1,2); plot(e_LMS); title('Po filtrze LMS (usuwanie interferencji)');
% subplot(3,1,3); plot(e_pred); title('Po ALP (predykcja liniowa)');
% 
% 
% snr_orig = snr(ecg, d' - ecg);                % przed
% snr_LMS = snr(ecg, e_LMS' - ecg);             % po LMS
% snr_ALP = snr(ecg, e_pred' - ecg);            % po predykcji
% 
% fprintf('SNR przed filtracją: %.2f dB\n', snr_orig);
% fprintf('SNR po LMS: %.2f dB\n', snr_LMS);
% fprintf('SNR po predykcji: %.2f dB\n', snr_ALP);
