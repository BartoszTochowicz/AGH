clear all;
close all;

fs = 192000;        % Częstotliwość próbkowania (np. 192 kHz)
f_pilot = 19000;     % Częstotliwość sygnału pilota (Hz)
N = fs * 10;         % 5 sekund sygnału
t = ((0:N-1)/fs)';     % wektor czasu

% df = 10;
% fm = 0.1;
% deltaf = df*sin(2*pi*t*fm);
% inst_freq = f_pilot+deltaf;
% phase = cumsum(2*pi*inst_freq/fs);
% p = cos(phase);

phi = pi/4;
p = cos(2*pi*f_pilot*t+phi);
phase = 2*pi*f_pilot*t+phi;

awgn_snr = [20,10,5,0,-10,-200];
for i = 1:6
    p_noise = awgn(p,awgn_snr(i),"measured");
   
    freq = 2*pi*f_pilot/fs;
    theta = zeros(1,length(p_noise)+1);
    alpha = 1e-2;
    beta = alpha^2/4;
    for n = 1 : length(p_noise)
        perr = -p_noise(n)*sin(theta(n));
        theta(n+1) = theta(n) + freq + alpha*perr;
        freq = freq + beta*perr;
    end
    c_pll = cos(theta(1:1000));
    error_phase = abs(unwrap(angle(exp(1j*(phase' - theta(1:end-1))))));
    % Detekcja zbieżności: błąd fazy < 0.1 rad
    idx = find(error_phase < 1e-6, 1);
    if isempty(idx)
        fprintf('SNR = %d dB: brak zbieżności\n', awgn_snr(i));
    else
        fprintf('SNR = %d dB: zbieżność po %.3f s (%d próbek)\n', ...
                awgn_snr(i), idx/fs, idx);
    end
end

% % Petla PLL z filtrem typu IIR do odtworzenia częstotliwości i fazy pilota [7]
% % i na tej podstawie sygnałów nośnych: symboli c1, stereo c38 i danych RDS c57
% freq = 2*pi*f_pilot/fs;
% theta = zeros(1,length(p)+1);
% alpha = 1e-2;
% beta = alpha^2/4;
% for n = 1 : length(p)
%     perr = -p(n)*sin(theta(n));
%     theta(n+1) = theta(n) + freq + alpha*perr;
%     freq = freq + beta*perr;
% end
% c57(:,1) = cos(3*theta(1:end-1)); % nosna 57 kHz
% 
% plot(t(1:1000), p(1:1000), t(1:1000), cos(theta(1:1000)))
% legend('sygnał pilotowy', 'PLL output')
% title('PLL dostraja się do sygnału pilota')