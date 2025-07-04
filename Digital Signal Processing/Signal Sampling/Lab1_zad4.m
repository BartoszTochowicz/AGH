close all;
clear all;
fpr = 1600;
f =11;
T = 0.1;
name = 'Bartosz';
ascii_name = double(name);
binary_stream = dec2bin(ascii_name,8);
binary_stream = binary_stream(:)'-'0';
samples_per_bit = round(T*fpr);
t = linspace(0,T,samples_per_bit);
x = [];
idx = 1;
c = [];
d = [];
for bit = binary_stream
    if bit == 0
        sig_bit = sin(2*pi*f*t);
       
    else
        sig_bit = -sin(2*pi*f*t);
  
    end
    x = [x,sig_bit];
end
t_total = linspace(0,length(binary_stream)*T,length(x));

hold on
figure;
plot(t_total, x, 'LineWidth', 1);
xlabel('Czas [s]');
ylabel('Amplituda');
title(['Sygnał transmitujący ASCII imienia: ', name]);
grid on;