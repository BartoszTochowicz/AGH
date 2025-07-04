function [tdTxSig, txData]=ofdmTx(symNum,prefLen,fftSize,M,guardInt,pilotInt)
%symNum - number of generated OFDM symbols
%prefLen - cyclic prefix length in samples
%fftSize - FFT size
%M - modulation index 4- QPSK 16- 15 QAM etc.
%guardInt - guard band width in percent i.e. 10% guardInt & fftSize = 512
%==> 25 empty carriers on each side. Default 10%
%pilotInt - pilot interval ie. 5 means pilot carier on every 5 data
%carriers default 0 -no pilot carriers
%clear all; 
%close all;

%% sprawdzanie parametrów wywolania - ustalenie wartoœci domyœlnych. Uwaga nie ma ¿adnej walidacji parametrów!!!
narginchk(4,6);

if nargin == 4
    guardInt=10;
    pilotInt=0;
elseif nargin == 5
    pilotInt=0;        
end


NumGuard=floor(0.005*guardInt*fftSize); %liczba noœnych ochronnych po ka¿dej stronie pasma


%% oznaczenie nmerów noœnych danych i pilota

if pilotInt > 0 
 pilotInd=NumGuard+1:pilotInt:fftSize-NumGuard;% pilot subcarier numbers
    if pilotInd(end) ~= fftSize-NumGuard
        pilotInd = [pilotInd (fftSize-NumGuard)];
    end
 dataInd=1:fftSize;% data subcarier numbers    
 dataInd([1:NumGuard pilotInd (fftSize-NumGuard+1):fftSize])=[]; % data subcarier numbers
 pilotBits=ones(log2(M),1);% arbitrary pilot symbol
 pilotSym = qammod(pilotBits,M,'InputType','bit');%,'UnitAveragePower',true);
else
    %brak podnoœnych z symbolami referencyjnymi
    dataInd=1:fftSize;% data subcarier numbers
end


%% generacja symboli danych 

    if pilotInt == 0
        txData=randi(2,((fftSize-2*NumGuard)*log2(M))*symNum,1)-1;
        txSyms = qammod(txData,M,'InputType','bit');%,'UnitAveragePower',true); %10 bo siê lepiej skaluje numerycznie i tylko dlatego        
        txSymMatrix = reshape(txSyms,fftSize-2*NumGuard,length(txSyms)/(fftSize-2*NumGuard)).'; % konwertujemy strumien ramki po N podnoœnych        
        txSymMatrix = [zeros(symNum,NumGuard) txSymMatrix zeros(symNum,NumGuard)];
        txSymMatrix=circshift(txSymMatrix,fftSize/2,2);       
        tdTxSig = ifft(txSymMatrix,fftSize,2);
    else
        txData=randi(2,length(dataInd)*log2(M)*symNum,1)-1;
        txSyms = qammod(txData,M,'InputType','bit');%,'UnitAveragePower',true); %10 bo siê lepiej skaluje numerycznie i tylko dlatego
        txSymMatrix = reshape(txSyms,length(dataInd),symNum).'; % konwertujemy strumien ramki po N podnoœnych  
        txMatSig = zeros(symNum,fftSize);
            for i=1:symNum
                txMatSig(i,dataInd)=txSymMatrix(i,:);
                txMatSig(i,pilotInd)=pilotSym;
            end
        txMatSig=circshift(txMatSig,fftSize/2,2);
        tdTxSig = ifft(txMatSig,fftSize,2);
    end

%% dodawanie prefiksu cyklicznego
tdTxSig=[zeros(symNum,prefLen) tdTxSig];
tdTxSig(1:symNum,1:prefLen)=tdTxSig(1:symNum,end-prefLen+1:end);
tdTxSig=reshape(tdTxSig.',1,(fftSize+prefLen)*symNum).';
end




