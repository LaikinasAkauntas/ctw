function [tran, P] = tranPro(P1, P2)
% Compute the optimal procrustes transformation given the correspondence.
%
% Input
%   P1      -  1st point set, dim x n
%   P2      -  2nd point set, dim x n
%
% Output
%   tran    -  optimal transformation
%   P       -  new 2nd points set, dim x n
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-10-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-28-2012

% dimension
[dim, n] = size(P1);
prIn('tranPro', 'dim %d, n %d', dim, n);

% centralize
[BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, eye(n));

% svd: U S V' = P1 P2'
Tmp = BP1 * BP2';
[U, S, V] = svd(Tmp);

% optimal solution
R = U * V';
tmp = trace(ones(n, 2) * (BP2 .^ 2));
s = trace(S) / tmp;
t = bp1 - s * R * bp2;

% apply transformation
P = s * R * P2 + repmat(t, 1, n);

% distance

% store
tran = st('s', s, 'R', R, 't', t);

prOut;
