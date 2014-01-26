function Pt = maskM2P(M)
% Store the binary matrix with the position of non-zero points.
%
% Input
%   M       -  mask matrix, h x w
%
% Output
%   Pt      -  mask point, 3 x nP
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

ind = find(M);
[I, J] = ind2sub(size(M), ind);
Pt = [I, J, M(ind)]';
