% rand_transform2.m
% Przeksztalcenie Boxa-Millera
close all;clear all;
disp('Rownomierny R[0,1] --> Normalny (0,1)')
N = 10000;
r1 = rand(1,N);
r2 = rand(1,N);
n1 = sqrt(-2*log(r1)) .* cos(2*pi*r2);
n2 = sqrt(-2*log(r1)) .* sin(2*pi*r2);
figure;
subplot(111); plot(n1,n2,'b*'); pause
figure;
subplot(211); hist(n1,20); title('n1');
subplot(212); hist(n2,20); title('n2'); pause