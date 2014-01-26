function [s, P] = tranSca(P1, P2)
% Compute the optimal scaling transformation.
%
% Math
%   min_s || P1 - s P2 ||_F
%
% Input
%   P1      -  1st point set, d x n
%   P2      -  2nd point set, d x n
%
% Output
%   s       -  scale
%   P       -  new 2nd points set, d x n
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-10-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-31-2012
 
% dimension
[d, n] = size(P1);
prIn('tranSca', 'd %d, n %d', d, n);

% optimal solution
s = sum((P1(:) .* P2(:))) / sum(P2(:) .* P2(:));

% apply transformation
P = s * P2;

prOut;
