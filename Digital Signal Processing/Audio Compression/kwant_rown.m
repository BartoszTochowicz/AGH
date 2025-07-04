function [ind, wy] = kwant_rown(L,xmax,we)
%
%  kwantyzator rownomierny, symetryczny:
%  midtread dla nieparzystej liczby poziomów,
%  midriser dla parzystej liczby poziomów.

%  L: liczba poziomów
%  xmax: zakres pracy "w gore" (kwantowanie w zakresie od -xmax do xmax)
%  we: probka we
%  wy: probka wy
%  ind: nr poziomu kwantyzacji: numeracja od 1 do L/2 ze znakiem dla mid-riser
%                                         od 0 do (L-1)/2 ze znakiem dla mid-tread

if L == 0
    wy = 0;
    ind = 0;
elseif fix(L/2)*2 == L  % parzyste L
    delta = 2*abs(xmax)/L; % odstep miedzy sasiednimi poziomami kwantyzacji
    xx=delta*((L-1)/2);  % najwyższy poziom kwantyzacji
    if abs(we) >= abs(xmax)
        tmp = xx;  % probka w stanie przesterowania
        ind=L/2;
    else
        tmp = abs(we); % probka w zakresie pracy kwantyzatora
        ind=round((tmp+delta/2)/delta); % tu nastepuje kwantowanie przez zaokrąglenie do najblizszej liczby calkowitej 1,2,...,L/2
    end
    wy =ind*delta-delta/2;
else   % nieparzyste L
    delta = 2*abs(xmax)/L; % odstep miedzy sasiednimi poziomami kwantyzacji
    xx=delta*((L-1)/2);  % najwyższy poziom kwantyzacji
    if abs(we) >= abs(xmax)
        tmp = xx;  % probka w stanie przesterowania
        ind=(L-1)/2;
    else
        tmp = abs(we); % probka w zakresie pracy kwantyzatora
        ind=round(tmp/delta); % tu nastepuje kwantowanie przez zaokrąglenie do najblizszej liczby calkowitej 0,1,...,(L-1)/2
    end
    wy =ind*delta;
end

if  we <= 0     % odzyskanie znaku próbki
    wy = -wy;
    ind=-ind;
end