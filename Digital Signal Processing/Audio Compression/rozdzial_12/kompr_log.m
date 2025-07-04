function wy = kompr_log(we, vmax, mu)
% kompresja logarytmiczna typu mi
% we - probka wejsciowa
% wy - probka poddana kompresji
% mu - parametr krzywej kompresji, w standardzie G.711 rowny 255
% vmax - zakres pracy kompresora, przy przetwarzaniu plikow .wav vmax=1
%
we = we/vmax;
wy = vmax*sign(we)*log(1+mu*abs(we))/log(1+mu);
