clear all;
close all;
N = 20;
macierz_analizy = zeros(N,N);
for k = 0:N-1
    if k == 0
        s = sqrt(1/N);
    else
        s = sqrt(2/N);
    end
    for n = 0:N-1
        macierz_analizy(k+1,n+1) = s*cos(pi*(k/N) *(n+0.5));
    end
end
dokladnosc = 10;
for i = 1:N
    for j = i+1:N
        x = round(macierz_analizy(i,:)*macierz_analizy(j,:)',dokladnosc);
        if (x~=0)
            disp("Wiersz "+i+" i "+j+" nie są ortonormalne")
        end
    end
end

macierz_syntezy = macierz_analizy';
I_sprawdzenie = macierz_analizy * macierz_syntezy;

if isequal(round(I_sprawdzenie, dokladnosc), eye(N))
    disp("Macierz A*A' jest identycznościowa");
else
    disp("Macierz A*A' NIE jest identycznościowa!");
end
x = randn(N,1);
X = macierz_analizy*x;
xs = macierz_syntezy*X;
err = sum(abs(x-xs))/N