% test_rand.m
clear all; close all;
% r = rand_mult(10000,123); % multiplikatywny (ile liczb, pierwsza liczba)
r = rand_multadd(10000,123); % kongruentny

figure; plot(r,'bo'); pause
figure; hist(r,20); pause
%##############################

%#################################

