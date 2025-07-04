close all; clearvars; clc;

[x,fs] = audioread('DontWorryBeHappy.wav');
x = x(:,1);
startSec = 3; dur = 1;
seg = x(startSec*fs+1 : (startSec+dur)*fs);
% seg=x;
t = (startSec:1/fs:startSec+dur)';
% t = (1:length(x))' * 1/fs;

Q = 2.8; % ok. 64 kbps
% Q = 1000000; % err nie spada poniżej ~0.02
N_arr = [32,128];

for N = N_arr
    [y,y_bps] = kodtr(seg,N,Q);
    seg_re = dektr(y,N,Q);
    
    min_len = min(length(seg_re),length(seg_re));
    seg = seg(1:min_len);
    seg_re = seg_re(1:min_len);
    t = t(1:min_len);
    fprintf('N = %d, Q = %d\n', N, Q);
    fprintf('Error: %d\n', max((seg-seg_re).^2));
    fprintf('kbps: %d\n\n', y_bps*fs/1e3);
    fprintf('BPS: %d\n\n', y_bps);
    % figure;plot(t,seg,'r',t,seg_re,'b');title(sprintf('N = %d, Q = %d', N, Q));
end
