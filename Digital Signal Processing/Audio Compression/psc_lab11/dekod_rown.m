function wy = dekod_rown(L,xmax,ind)
%
% dekoder kwantyzatora rownomiernego
%  L: liczba poziomow
%  xmax: zakres pracy
%
%  wy: probka wy
%  ind: nr poziomu kwant. (ze znakiem)
%
%
delta = 2*abs(xmax)/L; % odstep miedzy sasiednimi poziomami kwantyzacji

if fix(L/2)*2 == L  % parzyste L
    wy =abs(ind)*delta-delta/2;
else   % nieparzyste L
    wy =abs(ind)*delta;
end

if  ind < 0     % odzyskanie znaku probki
    wy = -wy;
end