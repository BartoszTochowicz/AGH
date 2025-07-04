clear all; close all;
P = 2; %W
czestotliwosc_srodkowa = 36*10^9;
B = 15*10^6;
G = 25; %dBi
czestotliwosc_skanowania_obszaru = 1;
Ts = 600; %temperatura szumowa systemu w K
L = 6;%dB
v = 22;%m/s
pozycja_mysliwca = [-160,-100];
radar = [0,0];
RCS_db = -16; %db
RCS = 10^(RCS_db/10);
k = 1.38*10^-23;
L_liniowo = 10^(L/10);
lampda = 3*10^8/czestotliwosc_srodkowa;
figure;
polaraxes;
SNR_db = zeros(20,1);
v_radialne = zeros(20,1);
fazy = zeros(20,1);
hold on
for i = 1:20
    r = sqrt((pozycja_mysliwca(1)-radar(1))^2+(pozycja_mysliwca(2)-radar(2))^2);
    A = lampda^2*G/(4*pi);
    N = k*Ts*B;
    SNR = (P*(10^(G/10))^2*lampda^2*RCS)/((4*pi)^3*r^4*N*L_liniowo);
    SNR_db(i,1) = 10*log10(SNR);
    [theta,rho] = cart2pol(pozycja_mysliwca(1),pozycja_mysliwca(2));
    fazy(i,1) = theta;
    if(SNR_db(i,1) > 5)
        polarplot(theta,rho,'bo',MarkerSize = 8);
        delta_r = 3*10^8/(2*B);
        epsilon = (rand-0.5)*delta_r;
        r_est = r + epsilon;
        polarplot(theta,r_est,'rx',MarkerSize=8);
        v_radialne(i,1) = czestotliwosc_srodkowa + czestotliwosc_srodkowa*(v/(3*10^8));
    else
        %polarplot(theta,rho,'ro',MarkerSize = 8);
    end
    pozycja_mysliwca(1) = pozycja_mysliwca(1)+ v*cosd(45);
    pozycja_mysliwca(2) = pozycja_mysliwca(2)+ v*sind(45);
end
hold off
figure

hold on
for i = 1:20
    r = sqrt((pozycja_mysliwca(1)-radar(1))^2+(pozycja_mysliwca(2)-radar(2))^2);
    A = lampda^2*G/(4*pi);
    N = k*Ts*B;
    SNR = (P*(10^(G/10))^2*lampda^2*RCS)/((4*pi)^3*r^4*N*L_liniowo);
    SNR_db(i,1) = 10*log10(SNR);
    [theta,rho] = cart2pol(pozycja_mysliwca(1),pozycja_mysliwca(2));
    if(SNR_db(i,1) > 5)
        stem(pozycja_mysliwca(1),pozycja_mysliwca(2));
        v_radialne(i,1) = czestotliwosc_srodkowa + czestotliwosc_srodkowa*(v/(3*10^8));
        epsilon2 = (rand-0.5)*v_radialne(i,1);
        v_est = v + epsilon2;
        stem()
    else
        %polarplot(theta,rho,'ro',MarkerSize = 8);
    end
    pozycja_mysliwca(1) = pozycja_mysliwca(1)+ v*cosd(45);
    pozycja_mysliwca(2) = pozycja_mysliwca(2)+ v*sind(45);
end