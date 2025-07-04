close all;
clear all;
fs1 = 10000; % 10 kHz
fs2 = 51;   % 51 Hz
fs3 = 50;   % 50 Hz
fs4 = 49;   % 49 Hz
 
% fs2 = 26;   % 51 Hz
% fs3 = 25;   % 50 Hz
% fs4 = 24;   % 49 Hz

T = 1;
f = 50;
t1 = 0:1/fs1:T;
x1 = sin(2*pi*f*t1);

t2 = 0:1/fs2:T;
x2 = sin(2*pi*f*t2);

t3 = 0:1/fs3:T;
x3 = sin(2*pi*f*t3);

t4 = 0:1/fs4:T;
x4 = sin(2*pi*f*t4);

figure;
hold on;
plot(t1,x1,'b-');
plot(t2, x2, 'g-o'); 
plot(t3, x3, 'r-o'); 
plot(t4, x4, 'k-o'); 
hold off;