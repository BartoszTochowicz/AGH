clear all;
function [L] = myCholesky(A)
    [N, ~] = size(A);
    L = zeros(N);  % Inicjalizacja macierzy L jako macierzy zerowej

    % L(1,1) = sqrt(A(1,1));
    % for i = 1:N
    %     sum = 0;
    %     % Obliczanie elementów na przekątnej
    %     for k = 1:i-1
    %         sum = sum + L(i,k)*L(i,k);
    %     end
    %     L(i,i) = sqrt(A(i,i) - sum);
    %     % Obliczanie elementów poniżej przekątnej
    %     for j = i+1:N
    %         sum = 0;
    %         for k = 1:i-1
    %             sum =sum + L(j,k)*L(i,k);
    %         end
    %         L(j,i) = (1/L(i,i))*(A(j,i)-sum);
    %     end
    % end
    L = eye(N);
   for j=1:N
       value=0;
       for k=1:j-1
           value = value + L(j,k)*L(j,k);
       end
       L(j,j) = sqrt(A(j,j) - value);%wartosci na przekatnej
       for i=j+1:N
           value = 0;
           for k=1:j-1
               value = value + L(i,k)*L(j,k);
           end
           L(i,j) = (1/L(j,j)) * (A(i,j) - value);%obliczanie wartosci ponizej przekatnej
       end
   end

    % else % trudniej, szybciej ---------------------------------------
    %     U=A; L=eye(N);
    %     for i=1:N-1
    %         for j=i+1:N
    %             L(j,i) = U(j,i) / U(i,i);
    %             U(j,i:N) = U(j,i:N) - L(j,i)*U(i,i:N);
    %         end
    %     end
    % end
end
% A = [1 2 3;
%     2 8 10;
%     3 10 22];
A = [5 7 6 5;
    7 10 8 7;
    6 8 10 9;
    5 7 9 10];
L = myCholesky(A),
A_hat = L*L',
L2 = chol(A),
A_hat2 = L2'*L2,
err1 = norm(A-A_hat),
err2 = norm(A-A_hat2),
