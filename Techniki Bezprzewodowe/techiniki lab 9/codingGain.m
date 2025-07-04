clear all;
close all;

EbNoVec=0:7;
freeDist=distspec(poly2trellis(7, [171 133]));
ber(:,1) = berawgn(EbNoVec,'psk',4,'nodiff')'; 
ber(:,2)=bercoding(EbNoVec,'conv','soft',0.5,freeDist); 

maxNumErrs=100;
maxNumBits=1e8;
open('qpsk_coded_sim');


for EbNo=0:7
  %symulacja dla kodera splotowego o stopie 3/4
  set_param('qpsk_coded_sim/Convolutional Encoder','usePuncVector','on')
  set_param('qpsk_coded_sim/Convolutional Encoder','punctureVector','[1; 1; 0; 1; 1; 0]')
  set_param('qpsk_coded_sim/Viterbi Decoder','isPunctured','on')
  set_param('qpsk_coded_sim/Viterbi Decoder','punctureVector','[1; 1; 0; 1; 1; 0]')
  set_param('qpsk_coded_sim/AWGN Channel','Tsym','1.5')
  set_param('qpsk_coded_sim/Bernoulli Binary Generator','sampPerFrame','188*1000*3')
  sim('qpsk_coded_sim');                        
  ber(EbNo+1,3)=BER(1,1);
end
save_system('qpsk_coded_sim');
close_system('qpsk_coded_sim');

semilogy(EbNoVec,ber)
yMin = 10.^(-8);
yMax = 10.^(0);
xMin = min(0);
xMax = max(7);
axis([xMin xMax yMin yMax]);

grid on;
title('Symulacja kodowania splotowego dla QPSK');
xlabel('EbNo [dB]')
ylabel('BER');
legend('BER bez kodowania splotowego','BER z kodowaniem splotowym o stopie 1/2','BER z kodowaniem splotowym o stopie 3/4','Location','southwest');



