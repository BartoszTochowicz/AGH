clear all;
close all;
fs = 3.2e6;
load('stereo_samples_fs1000kHz_LR_IQ.mat');
t = (0:length(I)-1)/fs;

x = unwrap(angle(I + 1j*Q));
x = diff(x);
x = [x;0];
x = x/max(abs(x));

figure;
plot(t(1:5000), x(1:5000));
title('Fragment sygnału FM po demodulacji');
xlabel('Czas [s]');
ylabel('Amplituda');

f_nyq = fs/2;
M = 750;
N_pilot = 2*M+1;
beta = 14; 
w_kaiser = kaiser(N_pilot+1, beta);
b_pilot = fir1(N_pilot, [18.9e3 19.1e3]/f_nyq, "bandpass", w_kaiser);

pilot = filter(b_pilot,1,x);

nfft = 2^20;
[Pxx,f] = pwelch(pilot,[],[],nfft,fs);
figure;
plot(f,10*log10(Pxx));
xlim([18e3 20e3]);
title('Widmo sygnału pilota');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');

% Odczytaj rzeczywiste fpl
[~,idx] = max(Pxx(f>18e3 & f<20e3));
fpl = f(f>18e3 & f<20e3);
fpl = fpl(idx);
disp(['f_pl = ' num2str(fpl) ' Hz']);


%2 stereo
N_stereo = 800;
w_stereo = blackmanharris(N_stereo+1); % okno Blackmana-Harrisa
fc = 2*fpl;

b_stereo = fir1(N_stereo, [fc-fpl,fc+fpl]/f_nyq, "bandpass", w_stereo);

stereo = filter(b_stereo,1,x);

figure;
[Pxx_stereo,f_stereo] = pwelch(stereo,[],[],nfft,fs);
plot(f_stereo,10*log10(Pxx_stereo));
xlim([0 100e3]);
title('Widmo sygnału stereo (L-R)');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');

% 3 odfiltrowanie

c = cos(2*pi*fc*t(:));

stereo_shifted = stereo .*c;

figure;
[Pxx_shifted,f_shifted] = pwelch(stereo_shifted,[],[],nfft,fs);
plot(f_shifted,10*log10(Pxx_shifted));
xlim([-100e3 100e3]);
title('Widmo po przesunięciu sygnału stereo');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');

%4 antyaliasing

fpr_new = 30e3;

N_aa = 300;
w_aa = blackmanharris(N_aa+1);
b_aa = fir1(N_aa,15e3/f_nyq,'low',w_aa);

stereo_shifted_filtered = filter(b_aa,1,stereo_shifted);

fpr_new = 30e3;
[P, Q] = rat(fpr_new/fs); % Określ proporcje

% Antyaliasing już wbudowany w resample
ys = resample(stereo_shifted_filtered, P, Q);

b_mono = fir1(N_aa,15e3/f_nyq,"low",w_aa);
ym_filtered = filter(b_mono,1,x);
ym = resample(ym_filtered, P, Q);

% 5

delay_stereo = (N_stereo + N_aa)/2;
delay_mono = N_aa/2;
delay_diff = delay_stereo-delay_mono;

ym = ym(delay_diff+1:end);
ys = ys(1:end-delay_diff);

Nmin = min(length(ym),length(ys));
ym = ym(1:Nmin);
ys = ys(1:Nmin);

yl = 0.5*(ym+ys);
yr = 0.5*(ym-ys);

figure;
subplot(2,1,1);
plot(yl);
title('Lewy kanał');
subplot(2,1,2);
plot(yr);
title('Prawy kanał');

% 7. Odtwarzanie audio
soundsc([yl yr], 30e3);