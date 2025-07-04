clear all;
close all;
Fs= 1e6; % częstotliwość próbkowania w Hz
prefSize=16;%rozmiar prefiksu wyrażony w próbkach
%TODO 1: przyjmujac że częstotliwośc próbkowania oraz długośc prefiksu cyklicznego nie ulegają zmianie
%narysuj wykres obrazujący czas trwania symbolu OFDM w funkcji liczby podnośnych. Przyjmij że liczba podnośnych stanowi kolejne potęgi dwójki
%rozważ rozmiary transformat od 64 do 4096
N_vals = [];
T_ofdm = [];
T_cp = prefSize / Fs; 
for i = 6:1:12
    N_vals(end+1) = 2^i; 
    T_ofdm(end+1) = (N_vals(i-5) / Fs) + T_cp;
end
T_ofdm = (N_vals / Fs) + T_cp; 


figure;
plot(N_vals, T_ofdm, 'o-', 'LineWidth', 2);
grid on;