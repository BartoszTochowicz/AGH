function [A] = rotationMatrixDeg(yaw, pitch, roll)
   A = rotationMatrix(yaw/360*2*pi, pitch/360*2*pi, roll/360*2*pi);
end
