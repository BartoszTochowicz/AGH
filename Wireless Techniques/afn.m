function [Y] = afn(P, A, b)
   Y = (A*P')' + b;
end