clear all;
close all;

x1 = [ 0, 1, 2, 3, 3, 2, 1, 0 ];
x2 = [ 0, 7, 0, 2, 0, 2, 0, 7, 4, 2 ];
x3 = [ 0, 0, 0, 0, 0, 0, 0, 15 ];

[sym1,p1] = prawdop_sym(x1);
N1 = length(x1);
H1 = Shannon(x1,N1,p1,sym1);

[sym2,p2] = prawdop_sym(x2);
N2 = length(x2);
H2 = Shannon(x2,N2,p2,sym2);

[sym3,p3] = prawdop_sym(x3);
N3 = length(x3);
H3 = Shannon(x3,N3,p3,sym3);

