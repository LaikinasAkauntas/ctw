function K = cenK(K0)
% Centralize the kernel matrix.
%
% Input
%   K0      -  original kernel matrix, n x n
%
% Output
%   K       -  new kernel matrix, n x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-26-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

n = size(K0, 1);

% matrix form:
%   P = eye(n) - ones(n, n) / n;
%   K = P * K0 * P;
K = K0;
vals = sum(K0, 1);
for i = 1 : n
    K(:, i) = K(:, i) - vals(i) / n;
end
for i = 1 : n
    K(i, :) = K(i, :) - vals(i) / n;
end
K = K + sum(vals) / n ^ 2;
