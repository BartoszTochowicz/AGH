function rxBitstream=ofdmRx(rxSig,prefLen,fftSize,M,guardInt,pilotInt,Cir)

%prefLen - cyclic prefix length in samples
%fftSize - FFT size
%M - modulation index 4- QPSK 16- 15 QAM etc.
%guardInt - guard band width in percent i.e. 10% guardInt & fftSize = 512
%==> 25 empty carriers on each side. Default 10%
%pilotInt - pilot interval ie. 5 means pilot carier on every 5 data
%carriers default 0 -no pilot carriers
%Cir - channel impluse response (default unknown estimate by ZF one tap equalizer)




%% sprawdzanie parametrów wywolania - ustalenie wartości domyślnych. Uwaga nie ma żadnej walidacji parametrów!!!

showPlots=0; %aby wlaczyc wizualizacje zmien wartosc zmiennej na 1

narginchk(4,7);

if nargin == 4
    guardInt=10;
    pilotInt=0;
elseif nargin == 5
    pilotInt=0;        
end


NumGuard=floor(0.005*guardInt*fftSize); %liczba nośnych ochronnych po każdej stronie pasma

%% oznaczenie numerów nośnych danych i pilota
    if pilotInt > 0
        pilotInd=NumGuard+1:pilotInt:fftSize-NumGuard;% pilot subcarier numbers
            if pilotInd(end) ~= fftSize-NumGuard
                pilotInd = [pilotInd (fftSize-NumGuard)];
            end
        pilotBits=ones(log2(M),1);% arbitrary pilot symbol
        pilotSym = qammod(pilotBits,M,'InputType','bit');

        dataInd=1:fftSize;% data subcarier numbers    
        dataInd([1:NumGuard pilotInd (fftSize-NumGuard+1):fftSize])=[]; % data subcarier numbers
    else
        dataInd=1:fftSize;% data subcarier numbers
        dataInd([1:NumGuard (fftSize-NumGuard+1):fftSize])=[]; % data subcarier numbers        
    end


%% deserializacja

rxSig=reshape(rxSig,(prefLen+fftSize),length(rxSig)/(prefLen+fftSize)).';

%% usunięcie prefiksu cyklicznego

rxSig=rxSig(:,prefLen+1:end);

%% przejscie do dziedziny czestotliwosci

rxData=fft(rxSig,fftSize,2);
rxData=circshift(rxData,fftSize/2,2);

%% estymacja kanału

    if nargin == 7
    %tutaj odpowiedz impulsowa kanalu jest znana odbiornikowi
        Hf_est=fft(Cir,fftSize); 
        mag_interp=abs(Hf_est);
        phi_interp=angle(Hf_est);
    else
    %tutaj odpowiedz impulsową kanalu estymujemy na podstawie symboli
    %pilotujących
        if showPlots
            Hf_est=zeros(size(rxData,1),fftSize);%odkomentuj przy wyswietalniu wykresow
            Hf_est(:,pilotInd)=rxData(:,pilotInd)/pilotSym;%odkomentuj przy wyswietalniu wykresow
        end
        % interpolacja charakterystyki amplitudowej i fazowej
        f_axis=1:fftSize;
        mag_interp=(interp1(pilotInd,abs(rxData(:,pilotInd)/pilotSym).',f_axis,'cubic')).';
        phi_interp=(interp1(pilotInd,angle(rxData(:,pilotInd)/pilotSym).',f_axis,'cubic')).';          
%        mag_interp=interp1(pilotInd,abs(rxData(:,pilotInd)/pilotSym).',f_axis,'cubic');
%        phi_interp=interp1(pilotInd,angle(rxData(:,pilotInd)/pilotSym).',f_axis,'cubic');          
        
    end

%% wyswietalnie wynikow estymacji
    if showPlots
        Hf_est_mag=abs(Hf_est);
            if nargin ~= 7
            hold on
                Hf_est_mag(Hf_est_mag==0)=nan;
                plot(Hf_est_mag.','o');
            end
        plot(mag_interp.','g');
        title('Charakterystyka częstotliwościowa kanalu');
    end

%% korekcja kanalowa

rxData = (rxData./mag_interp).*exp(-j*phi_interp);

%% wyświetalnie diagramu konstelacji po korekcji
    if showPlots
        figure
        plot(rxData(:,dataInd),'.');
        title('Diagram konstelacji po korekcji FDE');
    end

%% demodulacja
tmp=rxData(:,dataInd);
tmp=reshape(tmp.',[],1).';
rxBitstream=qamdemod(tmp,M,'outputtype','bit');
rxBitstream=reshape(rxBitstream,1,log2(M)*length(rxBitstream)).';

end