function [res] = fshift(inData,fc,FS)
%shift signal in a freq domain
%inData - input signal
%fc - carier frequency in Hz
%FS - sampling frequency in Hz
t = (0:1:(length(inData)-1))/FS;
res=inData.*exp(1i*2*pi*fc*t)';
end

