nadajnik1 = [5.5,4.5];
nadajnik2 = [5.5,20];
nadajnik3 = [5.5,34];
odbiornik1 = [54,10.5];
odbiornik2 = [54,16.5];
odbiornik3 = [54,24.5];
odbiornik4 = [54,30.5];
pomieszczenie = [0:0.5:60,0:0.5:40];
odleglosci = zeros([12,1]);
odleglosci(1,1) = sqrt((nadajnik1(1)-odbiornik1(1))^2+(nadajnik1(2)-odbiornik1(2))^2);
odleglosci(2,1) = sqrt((nadajnik1(1)-odbiornik2(1))^2+(nadajnik1(2)-odbiornik2(2))^2);
odleglosci(3,1) = sqrt((nadajnik1(1)-odbiornik3(1))^2+(nadajnik1(2)-odbiornik3(2))^2);
odleglosci(4,1) = sqrt((nadajnik1(1)-odbiornik4(1))^2+(nadajnik1(2)-odbiornik4(2))^2);
odleglosci(5,1) = sqrt((nadajnik2(1)-odbiornik1(1))^2+(nadajnik2(2)-odbiornik1(2))^2);
odleglosci(6,1) = sqrt((nadajnik2(1)-odbiornik2(1))^2+(nadajnik2(2)-odbiornik2(2))^2);
odleglosci(7,1) = sqrt((nadajnik2(1)-odbiornik3(1))^2+(nadajnik2(2)-odbiornik3(2))^2);
odleglosci(8,1) = sqrt((nadajnik2(1)-odbiornik4(1))^2+(nadajnik2(2)-odbiornik4(2))^2);
odleglosci(9,1) = sqrt((nadajnik3(1)-odbiornik1(1))^2+(nadajnik3(2)-odbiornik1(2))^2);
odleglosci(10,1) = sqrt((nadajnik3(1)-odbiornik2(1))^2+(nadajnik3(2)-odbiornik2(2))^2);
odleglosci(11,1) = sqrt((nadajnik3(1)-odbiornik3(1))^2+(nadajnik3(2)-odbiornik3(2))^2);
odleglosci(12,1) = sqrt((nadajnik3(1)-odbiornik4(1))^2+(nadajnik3(2)-odbiornik4(2))^2);
figure;
hold on;
sektor = [30,7];
rectangle('Position',[sektor(1),sektor(2),1,1],'EdgeColor','r','LineWidth',2);
plot(nadajnik1(1), nadajnik1(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Nadajnik');   
plot(nadajnik2(1), nadajnik2(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Nadajnik');
plot(nadajnik3(1), nadajnik3(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Nadajnik');

plot(odbiornik1(1), odbiornik1(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Odbiornik');
plot(odbiornik2(1), odbiornik2(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Odbiornik');
plot(odbiornik3(1), odbiornik3(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Odbiornik');
plot(odbiornik4(1), odbiornik4(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Odbiornik');

if(wektorsektor(nadajnik1(1),nadajnik1(2),odbiornik1(1),odbiornik1(2),sektor(1),sektor(2),1,1)<0)
    plot([nadajnik1(1), odbiornik1(1)], [nadajnik1(2), odbiornik1(2)], 'g--');
else
    plot([nadajnik1(1), odbiornik1(1)], [nadajnik1(2), odbiornik1(2)], 'y--');
    for i = 0:60
        for j = 0:40
            if(wektorsektor(nadajnik1(1),nadajnik1(2),odbiornik1(1),odbiornik1(2),i,j,1,1)<0)
                continue;
            else
                rectangle('Position',[i,j,1,1],'EdgeColor','r','LineWidth',2);
            end
        end
    end
end

plot([nadajnik1(1), odbiornik2(1)], [nadajnik1(2), odbiornik2(2)], 'g--');
plot([nadajnik1(1), odbiornik3(1)], [nadajnik1(2), odbiornik3(2)], 'g--');
plot([nadajnik1(1), odbiornik4(1)], [nadajnik1(2), odbiornik4(2)], 'g--');

plot([nadajnik2(1), odbiornik1(1)], [nadajnik2(2), odbiornik1(2)], 'g--');
plot([nadajnik2(1), odbiornik2(1)], [nadajnik2(2), odbiornik2(2)], 'g--');
plot([nadajnik2(1), odbiornik3(1)], [nadajnik2(2), odbiornik3(2)], 'g--');
plot([nadajnik2(1), odbiornik4(1)], [nadajnik2(2), odbiornik4(2)], 'g--');

plot([nadajnik3(1), odbiornik1(1)], [nadajnik3(2), odbiornik1(2)], 'g--');
plot([nadajnik3(1), odbiornik2(1)], [nadajnik3(2), odbiornik2(2)], 'g--');
plot([nadajnik3(1), odbiornik3(1)], [nadajnik3(2), odbiornik3(2)], 'g--');
plot([nadajnik3(1), odbiornik4(1)], [nadajnik3(2), odbiornik4(2)], 'g--');


grid on;
legend('Location', 'best');
title('Pomieszczenie z nadajnikami, odbiornikami oraz drogami propagacji');
xlabel('X [m]');
ylabel('Y [m]');
xlim([0, 60]);
ylim([0, 40]);
hold off;

% for i = 0:60
%     for j =0:40