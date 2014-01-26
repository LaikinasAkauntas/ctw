function [Pt, t] = maskCtr(M)
% Obtain the contour of a binary image.
%
% Input
%   M       -  image, h x w
%
% Output
%   Pt      -  position of points on boundary, 2 x nBd
%   t       -  direction of points on boundary, 1 x nBd
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-08-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% extract a set of boundary points w/oriented tangents
C = contourc(M, [.5 .5]);
[G1, G2] = gradient(M);

% multiple contours (for objects with holes)
fz = C(1, :) ~= .5;
C(:, ~fz) = nan;
Pt = C(:, fz);

% direction
PtD = round(Pt);
nBd = size(Pt, 2);
t = zeros(1, nBd);
for i = 1 : nBd
   x = PtD(1, i);
   y = PtD(2, i);

   t(i) = atan2(G2(y, x), G1(y, x));
end
t = t + pi / 2;
