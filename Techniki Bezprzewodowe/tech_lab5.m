clear all;
sciana1 = 0:1:80;
sciana2 = 0:1:70;
pozycje_robotow =zeros(90,2);
for i = 1:1:90
    pozycje_robotow(i,1) = randi([0,80]);
    pozycje_robotow(i,2)=randi([0,70]);
end
antena1 = [0,0];
antena2 = [80,0];
antena3 = [0,70];
antena4 = [80,70];
r =zeros(90,2);
% N =randn(1,1);
for i = 1:1:90
    tg1 = (pozycje_robotow(i,1)-antena1(1))/(pozycje_robotow(i,2)-antena1(2));
    tg2 = (pozycje_robotow(i,1)-antena2(1))/(pozycje_robotow(i,2)-antena2(2));
    tg3 = (pozycje_robotow(i,1)-antena3(1))/(pozycje_robotow(i,2)-antena3(2));
    tg4 = (pozycje_robotow(i,1)-antena4(1))/(pozycje_robotow(i,2)-antena4(2));
    arctg1 = atand(tg1);
    arctg2 = atand(tg2);
    arctg3 = atand(tg3);
    arctg4 = atand(tg4);
    faza1 = arctg1;
    faza2 = arctg2;
    faza3 = arctg3;
    faza4 = arctg4;
    A = [1-tand(faza1);
        1-tand(faza2);
        1-tand(faza3);
        1-tand(faza4)];
    b = [antena1(1)-antena1(2)*tand(faza1);
        antena2(1)-antena2(2)*tand(faza2);
        antena3(1)-antena3(2)*tand(faza3);
        antena4(1)-antena4(2)*tand(faza4);];
    r(i,:) = (A' * A) \ (A' * b);
end
disp(r);