close all;
clear all;
fs1 = 10000; % 10 kHz
fs2 = 500;   % 500 Hz
fs3 = 200;   % 200 Hz
T = 0.1;
A = 230;
f = 50;

t1 = 0:1/fs1:T;
x1 = sin(2*pi*f*t1);

t2 = 0:1/fs2:T;
x2 = sin(2*pi*f*t2);

t3 = 0:1/fs3:T;
x3 = sin(2*pi*f*t3);

figure;
hold on;
plot(t1,x1,'b-','LineWidth',1.5);
plot(t2, x2, 'r-o'); 
plot(t3, x3, 'k-x', 'MarkerSize', 5, 'LineWidth', 1.2); 
hold off;
