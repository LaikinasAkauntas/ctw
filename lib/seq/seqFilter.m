function X = seqFilter(X0, sigma)
% Sequence smoothing.
%
% Input
%   X0      -  original sequence, dim x n
%   sigma   -  sigma
%
% Output
%   X       -  new sequence, dim x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-08-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% smooth kernel
dx = -sigma * 2 : 1 : sigma * 2;
wt = exp(-dx .^ 2 / (2 * sigma ^ 2));
wt = wt / sum(wt);

% dimension
[dim, n] = size(X0);

X = zeros(dim, n);
for d = 1 : dim
    X(d, :) = conv(X0(d, :), wt, 'same');
end
