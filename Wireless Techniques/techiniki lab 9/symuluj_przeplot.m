BerRaw_w(1,1)=0;
BerRs_w(1,1)=0;
BerFec_w(1,1)=0;
codeRate=0.66;


%przeploty=[1 2 3 4 6 12 17 34];% 51 68 102];
przeploty=[1  12 ];
	for k=1:length(przeploty)
        i=1;
    for EbNo=0:0.1:2.9

    open('dvbs1_batch');
		
        set_param(sprintf('dvbs1_batch/Outer Deinterleaver/Convolutional\nDeinterleaver'),'N',sprintf('%d',przeploty(k)))
        set_param(sprintf('dvbs1_batch/Outer Deinterleaver/Convolutional\nDeinterleaver'),'B',sprintf('%d',204/przeploty(k)))
        set_param(sprintf('dvbs1_batch/Outer Interleaver/Convolutional\nInterleaver'),'N',sprintf('%d',przeploty(k)))
        set_param(sprintf('dvbs1_batch/Outer Interleaver/Convolutional\nInterleaver'),'B',sprintf('%d',204/przeploty(k)))


		set_param('dvbs1_batch/Error Rate Calculation1','N',sprintf('%d',188*8*przeploty(k)))

		
		set_param('dvbs1_batch/Convolutional Encoder','usePuncVector','on')
        set_param('dvbs1_batch/Convolutional Encoder','punctureVector','[1; 1; 0; 1]')
        set_param('dvbs1_batch/Viterbi decoder/Viterbi Decoder','isPunctured','on')
        set_param('dvbs1_batch/Viterbi decoder/Viterbi Decoder','punctureVector','[1; 1; 0; 1]')

        set_param('dvbs1_batch/QPSK Demodulator Baseband','DecType','Approximate log-likelihood ratio')                      
        set_param('dvbs1_batch/QPSK Demodulator Baseband','Variance',sprintf('(1.0/(2*%g))*10^(-EbNo/10)',codeRate))           
        set_param('dvbs1_batch/Viterbi decoder/Viterbi Decoder','dectype','Unquantized')         

        set_param('dvbs1_batch/AWGN Channel','SNRdB',sprintf('EbNo + %g',10*log10(2.0*codeRate)))                
        set_param('dvbs1_batch/Random-Integer Generator','sampPerFrame','188')
	sim('dvbs1_batch');
	BerRs_w(i,k)=BerRs(1,1);
    BerRaw_w(i,1)=BerRaw(1,1);
	BerFec_w(i,1)=BerFec(1,1);
    i=i+1;
    end
    end

    EbNo=0:0.1:2.9;
semilogy(EbNo,BerRaw_w,'xr-');
hold on
semilogy(EbNo,BerFec_w,'xg-');
semilogy(EbNo,BerRs_w(:,1),'xb-');
semilogy(EbNo,BerRs_w(:,2),'xc-');
% semilogy(EbNo,BerRs_w(:,3),'xm-');
% semilogy(EbNo,BerRs_w(:,4),'xy-');
% semilogy(EbNo,BerRs_w(:,5),'xk-');
% semilogy(EbNo,BerRs_w(:,6),'xr-');
% semilogy(EbNo,BerRs_w(:,7),'xg-');
% semilogy(EbNo,BerRs_w(:,8),'xb-');
            xlabel('Eb/No (dB)');
            ylabel('BER');
            grid on;
            set(gca, 'YMinorGrid', 'off');
yMin = 10.^(floor(log10(min(BerRs_w(:,8)))));
yMax = 10.^(ceil(log10(max(BerRaw_w))));
xMin = min(EbNo(:));
xMax = max(EbNo(:));
axis([xMin xMax yMin yMax]);

title('Symulacja modemu DVB-S');
xlabel('EbNo [dB]')
ylabel('BER');
%legend('BER po demodulatorze','BER pod vitterbim','BER out bez przeplotu','BER out przeplot 2','BER out przeplot 3','BER out przeplot 4','BER out przeplot 6','BER out przeplot 12','BER out przeplot 17','BER out przeplot 34','location','best');
legend('BER po demodulatorze','BER pod vitterbim','BER out bez przeplotu','BER out przeplot 12 ramek','location','best');



