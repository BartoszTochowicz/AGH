function myPlot(P)
   plot3(P(:, 1), P(:, 2), P(:, 3), '.');
   xlabel('X');
   ylabel('Y');
   zlabel('Z');
   grid on;
end