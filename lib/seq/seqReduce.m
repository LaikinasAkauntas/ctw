function X = seqReduce(X0)
% Do sequence reduction.
%
% Input
%   X0      -  original sequence, dim x n0
%
% Output
%   X       -  new sequence, dim x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-08-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% smooth kernel
Wt = [.05 .25 .4 .25 .05];

% dimension
[dim, n0] = size(X0);
n = ceil(n0 / 2);

X = zeros(dim, n);
m = -2 : 2;

for d = 1 : dim
    % Pad the boundaries.
    x0 = X0(d, [1 1 1 : n0 n0 n0]);
    for i = 0 : n - 1
        A = x0(2 * i + m + 3) .* Wt;
        X(d, i + 1)= sum(A(:));
    end
end
