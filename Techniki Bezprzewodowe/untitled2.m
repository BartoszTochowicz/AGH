clear all;
function [dist] = d(a, b)
   dist = pdist([a.x, a.y; b.x, b.y], 'euclidean');
end
% get phase necesary for constructive interference in radians
function [phi] = phase(dist, freq)
   lambda = 3 * 10^8 / freq;
   phi = rem(dist, lambda) / lambda * 2 * pi;
end
function H = transm(d, lambda, phi)
   H = lambda / (4 * pi * d )* exp(-j * 2 * pi * d / lambda) * exp(-j * phi);
end
function [snr] = SNR(signal_dB, noise_dB)
   snr = signal_dB - noise_dB;
end
r.x = 30;
r.y = 20;
r.pow = -20; % power anteny pojedynczej, 13dBm == 20mW, połowa to jest -3dB
r.freq = 6 * 10 ^ 9;
r.lambda = 3 * 10^8 / r.freq;

% wspolrzedne anteny 1 AP
r.a1.x = 30.0125;
r.a1.y = 20;
% wspolrzedne anteny 2 AP
r.a2.x = 29.9875;
r.a2.y = 20;
% users and coordinates
u1.x = 100;
u1.y = 100;
u2.x = 140;
u2.y = 0;
noise = -130; % dBW
% spodziwamy sie tlumienia 20/30 dB
% tłumienie się odbywa jak w przestrzeni swobodnej
% użytkownicy dysponują odbiornikami z pojedynczymi antenami izotropowymi,
% poziom szumów na wejściu odbiorników obu użytkowników wynosi -130 dBW


%r.pow = r.pow - 3; % dwa razy mniejsza moc

% user 1
a1u1 = d(r.a1, u1)
a2u1 = d(r.a2, u1)
phi1 = phase(a1u1 - a2u1, r.freq)

% user 2
a1u2 = d(r.a1, u2)
a2u2 = d(r.a2, u2)
phi2 = phase(a1u2 - a2u2, r.freq);

% H1 = transm(a1u1, r.lambda, 0) + transm(a2u1, r.lambda, phi1)
% P1 = r.pow + 20 * log10(abs(H1))
% snr1w = SNR(P1, noise)
r.pow = -23;
%wyciszenie do U1
H1 = transm(a1u1, r.lambda, 0) + transm(a2u1, r.lambda, phi1 - pi)
P1 = r.pow + 20 * log10(abs(H1))

% wyciszenie do U2
H2 = transm(a1u2, r.lambda, 0) + transm(a2u2, r.lambda, phi2 - pi)
P2 = r.pow + 20 * log10(abs(H2))
snr1w = SNR(P1, noise)
snr2w = SNR(P2, noise)

% transmisja do U1
H2 = transm(a1u1, r.lambda, 0) + transm(a2u1, r.lambda, phi2 - pi)
P2 = r.pow + 20 * log10(abs(H2))

% transmisja do U2
H1 = transm(a1u2, r.lambda, 0) + transm(a2u2, r.lambda, phi1 - pi)
P1 = r.pow + 20 * log10(abs(H1))
snr1 = SNR(P1,noise)
snr2 = SNR(P2, noise)



