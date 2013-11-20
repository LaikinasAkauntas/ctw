function X = seqMean(Xs, P)
% Compute the mean sequence of a set of sequences.
%
% Input
%   X0s     -  original sequence, 1 x m (cell), dim x n
%   P       -  warping path, l x m | 1 x m (cell), li x 1
%   par     -  parameter
%     inp   -  interpolation algorithm, {'exact'} | 'nearest' | 'linear'
%
% Output
%   Xs      -  new sequence, 1 x m (cell), dim x li
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-06-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
dim = size(Xs{1}, 1);
[n, m] = size(P);

% interpolation
Ys = seqInp(Xs, P, st('inp', 'nearest'));

% mean
X = zeros(dim, n);
for j = 1 : m
    X = X + Ys{j};
end
X = X / m;
