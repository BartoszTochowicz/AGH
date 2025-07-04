close all;
[inSig, Fs] = audioread('voice_spectrev.wav'); % Load the encoded signal

% Analyze the encoded signal's spectrum
figure;
pwelch(inSig, 4096, [], [], Fs, 'centered');
title('Encoded Signal Spectrum');

% Decode the signal using Hilbert transform and modulation
y1 = hilbert(inSig) .* exp(1j * 4000 * 2 * pi .* (0:1/Fs:(length(inSig)-1)/Fs))';

% Combine the modulated signal with its time-reversed version
signal_out = real(y1 + flip(y1));

% Analyze the decoded signal's spectrum
figure;
pwelch(signal_out, 4096, [], [], Fs, 'centered');
title('Decoded Signal Spectrum');

% Play the decoded signal
soundsc(signal_out, Fs); % Play the decoded signal