% evd_jacobi.m
clear all; close all;
% A = [ 2 0 1; 0 -2 0; 1 0 2 ], % przyklad z Yang, 2005
% % A = hankel( [1 2 3], [3,4,5] ),
% [N,N] = size(A),
% % Pojedyncza rotacja zerujaca element A(p,q) macierzy A
% p=1; q=3;
% R1 = makeRi(p, q, A)
% R1.' * A * R1,
% [R, D] = solve(A)
A = [1 2 3 4;
    2 3 4 5;
    3 4 5 6;
    4 5 6 7;]
[R, D] = solve(A)
function [R, D] = solve(A)
   D = A;
   [N, N] = size(D);
   R = eye(N);
   while (1)
       Dabs = abs(D - tril(D)); %Macierz wartości bezwzględnych elementów nad przekątną
       [v, x, y] = mmax(Dabs); %Znajdź maksymalny element nad przekątną
       assert(Dabs(y, x) == v);
      
       if (abs(v) > 0.00000000001) % Jeśli element nad przekątną jest znaczący
           Ri = makeRi(y, x, D), % Oblicz macierz rotacji zerującą D(y, x)
           D = Ri.' * D * Ri, % Przekształć macierz D
           R = R * Ri, % Zaktualizuj macierz rotacji
       else
           return % Zakończ iterację, gdy elementy nad przekątną są bliskie zeru
           % W każdej iteracji maksymalny element poza diagonalą (nad
           % przekątną) jest zerowany za pomocą macierzy rotacji Ri
           %Iteracje kończą się, gdy wszystkie elementy poza diagonalą są bliskie zeru
       end
   end
end 
% Funkcja zwraca wartość maksymalną v i jej wspolrzedne  x,y
function [v, x, y] = mmax(A)
   [N, N] = size(A);
   [v, i] = max(A, [], 'all'); %Znajdź maksymalną wartość w macierzy
   % 'i' to jest numer elementu licząc kolumnami
   x = fix(i / N) + 1; % Indeks kolumny
   y = rem(i, N); % Indeks wiersza
   if (x == 0)  % Jeśli jest na końcu wiersza
       % this is the last element of a row
       y = N;
       x = x - 1;
       return
   end
end
function [Ri] = makeRi(p, q, A)
   xi = (A(q,q) - A(p,p)) / 2 / A(p,q);
   if( xi > -eps )
       t =  (abs(xi) + sqrt(1 + xi^2));
   else
       t = -(abs(xi) + sqrt(1 + xi^2));
   end
  
   c = 1 / sqrt(1+t^2); %cos kata rotacji
   s = t * c; %sin kata rotacji
   [N, N] = size(A);
   Ri = eye(N);
   Ri(p, p) = c;
   Ri(q, q) = c;
   Ri(p, q) = -s;
   Ri(q, p) = s;
end
