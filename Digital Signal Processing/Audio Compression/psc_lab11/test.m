close all;
clear all;
x = [1,10,50,100];
p =[];
for i = 1:99
    p(i) = prctile(x,i);
end
plot(p)