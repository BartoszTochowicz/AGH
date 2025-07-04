rrcFilter = rcosdesign(0.35, 32, 256,'normal');
rrcFilter=rrcFilter/max(rrcFilter);
s1=[rrcFilter,zeros(1,512)];
s2=[zeros(1,256) rrcFilter zeros(1,256)];
s3=[zeros(1,512) -1*rrcFilter];
f=(1:4096).*(256/4096);
y=abs(fft(rrcFilter))/max(abs(fft(rrcFilter)));
figure;
subplot(2,2,1);
plot(rrcFilter);
title('Impuls podniesiony cosinus')
grid on;
subplot(2,2,2);
plot(f(1:32),y(1:32));
title('Pasmo impulsu podniesiony cosinus')
grid on;
subplot(2,2,3);
plot(s1,'r');
hold on;
grid on;
plot(s2,'g');
plot(s3,'b');
plot(s1+s2+s3,'k');
title('interferencja miêdzysymbolowa (sekwencja 1,1,-1)')
subplot(2,2,4);
plot(s1+s2+s3,'k');
title('przebieg czasowy w kanale')
grid on;