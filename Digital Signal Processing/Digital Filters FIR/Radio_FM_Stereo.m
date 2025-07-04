clear all;
close all;
load("stereo_samples_fs1000kHz_LR_IQ.mat");
fs = 1e6;

x = unwrap(angle(I+1j*Q));
x = diff(x);
x = [x;0];
x = x/max(abs(x));

t = (0:length(x)-1)/fs;
nfft = 2^20;
[Pxx,f] = pwelch(x,[],[],nfft,fs);
figure;
plot(f,10*log10(Pxx));
xlim([18e3 20e3]);
title('Widmo sygnału pilota');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');

f_pilot = [18.9e3 19.1e3];
f_nyq = fs/2;

M_pilot = 750;
N_pilot = 2*M_pilot+1;
h_pilot = fir1(N_pilot-1,f_pilot/f_nyq,"bandpass",kaiser(N_pilot,14));

pilot = filter(h_pilot,1,x);

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

f_c = 2*fpl;
M_stereo = 50;
N_stereo = 2*M_stereo+1;
win_stereo = hamming(N_stereo);
h_stereo = fir1(N_stereo-1,[f_c-fpl f_c+fpl]/f_nyq,"bandpass",win_stereo);

stereo = filter(h_stereo,1,x);

figure;
[Pxx_stereo,f_stereo] = pwelch(stereo,[],[],nfft,fs);
plot(f_stereo,10*log10(Pxx_stereo));
xlim([0 100e3]);
title('Widmo sygnału stereo (L-R)');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');

c = cos(2*pi*f_c*t);
stereo_shifted = stereo.*c';

figure;
[Pxx_shifted,f_shifted] = pwelch(stereo_shifted,[],[],nfft,fs);
plot(f_shifted,10*log10(Pxx_shifted));
xlim([-100e3 100e3]);
title('Widmo po przesunięciu sygnału stereo');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');

% % Decymacja, najpierw 3 krotne nadprobkowanie a potem 100 krotna decymcja
% L = 100;
% K = 3;
% R=rem(length(stereo_shifted),L); stereo_shifted = stereo_shifted(1:end-R);
% 
% h = K*fir1(N_stereo-1,1/K,kaiser(N_stereo,12));
% for k=1:K
%     yipp(k:K:K*length(stereo_shifted)) = filter( h(k:K:end), 1, stereo_shifted);
% end
% 
% R=rem(length(yipp),L); yipp = yipp(1:end-R); 
% g = fir1(N_stereo-1, 1/L - 0.1*(1/L),kaiser(N_stereo,12));
% yipp = [ zeros(1,L-1) yipp(1:end-(L-1)) ];
% ydpp = zeros(1,length(yipp)/L);
% for k=1:L
%     ydpp = ydpp + filter( (g(k:L:end)), 1, yipp(L-k+1:L:end) );
% end
% ydpp = ydpp';
h_m = fir1(N_stereo-1,[4*fpl-1e3 4*fpl+1e3]/f_nyq,"stop",hamming(N_stereo));
% 
% y_stereo = filter(h_m,1,ydpp);

y_stereo2 = resample(stereo_shifted, 3, 100);
y_stereo = filter(h_m,1,y_stereo2);

M_aa = 50;
N_aa = 2*M_aa+1;
b_mono = fir1(N_aa-1,15e3/f_nyq,"low",blackmanharris(N_aa));
ym_filtered = filter(b_mono,1,x);
y_mono = resample(ym_filtered, 3, 100);


% Delay
delay_Stereo = N_stereo;
delay_Mono = N_aa/2;
delay_diff = delay_Stereo-delay_Mono;



y_mono = y_mono(delay_diff+1:end);
y_stereo = y_stereo(1:end-delay_diff);

Nmin = min(length(y_mono),length(y_stereo));
ym = y_mono(1:Nmin);
ys = y_stereo(1:Nmin);

yl = 0.5*(ym+ys);
yr = 0.5*(ym-ys);

figure;
subplot(2,1,1);
plot(yl);
title('Lewy kanał');
subplot(2,1,2);
plot(yr);
title('Prawy kanał');
% 
soundsc([yl yr], 30e3);

% Parametry dla analizy
fs_audio = 30e3; % Zakładana częstotliwość po resamplingu
nfft = 2^15;

% Widmo kanału lewego
figure;
[Pyl,fyl] = pwelch(yl, [], [], nfft, fs_audio);
plot(fyl, 10*log10(Pyl));
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');
title('Widmo kanału lewego (yl)');
grid on;

% Widmo kanału prawego
figure;
[Pyr,fyr] = pwelch(yr, [], [], nfft, fs_audio);
plot(fyr, 10*log10(Pyr));
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');
title('Widmo kanału prawego (yr)');
grid on;