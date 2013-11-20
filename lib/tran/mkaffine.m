function [P, A] = mkaffine(P0, PR)
% Find affine transformation from P0 to PR.
%
% Input
%   P0      -  original points, nP x 2
%   PR      -  reference points, nP x 2
%
% Output
%   P       -  aligned points, nP x 2
%   A       -  transformation matrix, 3 x 3
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

P0 = P0 .';
PR = PR .';

% Homogeneous coordinates
P0 = [P0; ones(1, size(P0, 2))];
PR = [PR; ones(1, size(PR, 2))];

% A * pts = ptsref
A = PR / P0;

P = (A * P0) .';
P = P(:, 1 : 2);
