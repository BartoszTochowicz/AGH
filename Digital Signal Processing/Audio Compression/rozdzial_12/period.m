% estymacja widma mocy sygnalu xn
function spectre_db = period(xn)

N = length(xn);
vn = 0.5*(1-cos(2*pi*(0:N-1)'/N));
temp = fft(xn.*vn);
spectre = abs(temp(1:N/2).^2)/N;
spectre_db = 10*log10(spectre+0.0001);