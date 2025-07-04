function [d] = demodulate(y, fc, h)
    fsx = 400e3;
    t = (0:length(y)-1)' / fsx;
    carrier = cos(2*pi*fc*t);
    d = real(filter(h, 1, y .* carrier));
end