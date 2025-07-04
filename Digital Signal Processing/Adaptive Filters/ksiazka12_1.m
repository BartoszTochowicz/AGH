clear all; close all;
% Parametry sygnalow
fpr = 1000; % czestotliwosc probkowania
Nx = fpr; % liczba probek, 1 sekunda
dt = 1/fpr; t = 0:dt:(Nx-1)*dt; % czas
f = 0:fpr/1000:fpr/2; % czestotliwosc
if(1) % Scenariusz #1 - adaptacyjne usuwanie interferencji
    M = 50; % liczba wag filtra
    mi = 0.1; % szybkosc adaptacji ( 0<mi<1)
    s = sin(2*pi*10*t).*exp(-25*(t-0.5).^2); % sygnal: sinus*gaussoida, EKG lub mowa
    z = sin(2*pi*200*t); % zaklocenie: harmoniczne, "warkot"
    d = s + 0.5*z; % sygnal + przeskalowane zaklocenie
    x = 0.2*[zeros(1,5) z(1:end-5)]; % opozniona i stlumiona kopia zaklocenia
else % Scenariusz #2 - adaptacyjne odszumianie/uzdatnianie sygnalu
    M = 10; % liczba wag filtra
    mi = 0.0025; % szybkosc adaptacji ( 0<mi<1)
    s = sin(2*pi*10*t); % sygnal: sinus, EKG lub mowa

    z = 0.3*randn(1,Nx); % zaklocenie szumowe
    d = s + z; % zaklocony sygnal
    x = [ 0, d(1:end-1)]; % opozniona kopia zakloconego sygnalu
end
% % Filtracja adaptacyjna
% bx=zeros(M,1); % inicjalizacja bufora na probki sygnalu wejsciowego x(n)
% h = zeros(M,1); % inicjalizacja wag filtra
% y = zeros(1,Nx); % wyjscie puste, jeszcze nic nie zawiera
% e = zeros(1,Nx); % wyjscie puste, jeszcze nic nie zawiera
% for n = 1 : length(x) % Petla glowna
%     % n % indeks petli
%     bx = [ x(n); bx(1:M-1) ]; % wstawienie nowej probki x(n) do bufora
%     y(n) = h' * bx; % filtracja x(n), czyli estymacja d(n)
%     e(n) = d(n) - y(n); % blad estymacji
%     h = h + ( 2*mi * e(n) * bx ); % LMS - adaptacja wag filtra
% end

[y,e,h]=adaptTZ(d,x,M,mi,1e-6,0.98,1e3,2);

P_singal = 1/Nx*mean(s.^2);
P_noise = 1/Nx*mean(s.^2-y.^2);

SNR = 10*log10(P_singal/P_noise);