function dq = kwant_adapt(amp,we)
    x = we;
    x = double( x(:,1) );
    a = 0.9545; % parametr a kodera
    x=x*1/max(abs(x));
    N = length(x);
    n_bit = 4;
    L = n_bit^2;
    xm=[0.8,0.8,0.8,0.8,1.2,1.6,2.,2.4];
    zmax=1.;
    zmin=0.001*zmax;
    z=0.2*zmax; % poczatkowy zakres pracy
    delta=1.e-5;
    dl=1.e-10;
    w=0.99;
    
    mp = 1; % ilosc wspolczynnikow predykcji
    
    beta = 0.4;
    
    ai = zeros(mp,1); % wspolczynniki predykcji
    
    buf=zeros(mp,1);
    
    for i=1:N
        snp=buf'*ai; % predykcja
        en=x(i)-snp;       % blad predykcji
        [nr,wy]=kwant_rown(L,z,en);  % kwantyzator rownomierny
        z=z*xm(abs(nr)); %adaptacja kwantyzatora metoda "wstecz"
        
        if z <= zmin
            z=zmin;
        end
        if z > zmax
            z=zmax;
        end
        
        qsig(i)=wy+snp;  % syg. wyjsciowy
        
        ai=ai+beta*wy*buf; % adaptacja predyktora
        
        buf=[qsig(i);buf(1:mp-1)];
        
        unstab=norm(ai);  % wykrywanie niestabilnosci numerycznej
        if unstab > 10^6
            'niestabilnosc - zmniejsz beta!'
        end
        
    end
        dq = qsig;
end