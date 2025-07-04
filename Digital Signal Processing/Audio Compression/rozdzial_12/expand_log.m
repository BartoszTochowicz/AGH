function wy = expand_log(we,vmax, mu)

% ekspansja - operacja odwrotna do kompresji logarytmicznej
we=we/vmax;

wy=sign(we)*(vmax/mu)*((1+mu)^abs(we) -1);
