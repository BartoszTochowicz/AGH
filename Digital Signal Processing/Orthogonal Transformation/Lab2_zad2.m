clear all;
close all;
N = 20;
% A = randn(N);
% dokladnosc = 10;
% for i = 1:N
%     for j = i+1:N
%         c = round(A(i,:)*A(j,:)',dokladnosc),
%         if (c~=0)
%             disp("Wiersz "+i+" i "+j+" nie są ortonormalne")
%         end
%     end
% end
% 
A= zeros(N);
for k = 0:N-1
    if k == 0
        s = sqrt(1/N);
    else
        s = sqrt(2/N);
    end
    for n = 0:N-1
        A(k+1,n+1) = s*cos(pi*((k+0.25)/N) *(n+0.5));
    end
end
dokladnosc = 15;
for i = 1:N
    for j = i+1:N
        x = round(A(i,:)*A(j,:)',dokladnosc);
        if (x~=0)
             disp("Wiersz "+i+" i "+j+" nie są ortonormalne")
        end
    end
end

S = inv(A);
I = A*S;
x = randn(N,1);
y = A*x;
xs = S*y;
err = sum(abs(x-xs))/N