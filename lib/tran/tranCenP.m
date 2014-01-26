function [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X)
% Centralize the point set given the correspondence.
%
% Input
%   P1      -  1st point set, d x n1
%   P2      -  2nd point set, d x n2
%   X       -  correspondence, n1 x n2
%
% Output
%   BP1     -  1st point set after centerizing, d x n1
%   BP2     -  2nd point set after centerizing, d x n2
%   bp1     -  1st mean, d x 1
%   bp2     -  2nd mean, d x 1
%   rowX    -  row sum of X, n1 x 1
%   colX    -  column sum of X, n2 x 1
%   nor     -  all sum of X
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-11-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-21-2012

% dimension
[n1, n2] = size(X);

% centralize
nor = sum(X(:));
rowX = sum(X, 2);
colX = sum(X', 2);
bp1 = P1 * rowX / nor;
bp2 = P2 * colX / nor;
BP1 = P1 - repmat(bp1, 1, n1);
BP2 = P2 - repmat(bp2, 1, n2);
