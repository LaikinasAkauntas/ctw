function [a, W, A] = aliLK(X, Z, P, para, a0)
% Align two sequences.
% Minimize
%   || X * W(P * a)^T - Z ||_F^2  s.t. a >=0
% 
% Input
%   X        -  input sequence, dim x n
%   Z        -  latent sequence, dim x m
%   P        -  factored warping path, m x k
%   para     -  parameter
%     th     -  stop threshold, {.01}
%     nItMa  -  maximum iteration number, {100}
%   a0       -  initial weight, k x 1
%
% Output
%   a        -  weight, k x 1
%   W        -  warping matrix, ny x nx
%   A        -  weights found in the procedure, k x nIt
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parameter
th = ps(para, 'th', .0001);
nItMa = ps(para, 'nItMa', 100);

% dimension
[dim, nx] = size(X);
[m, k] = size(P);

% derivative
% Lx = X * lapl(nx);
Lx = [zeros(dim, 1), diff(X, 1, 2)];

% iterate
a = a0;
A = zeros(k, nItMa);
for nIt = 1 : nItMa
    A(:, nIt) = a;

    % corresponding value
    p = round(P * a);

    % min_a || G da + h ||^2

    % derivative
    [hs, Gs] = cellss(m, 1);
    for i = 1 : m
        hs{i} = X(:, p(i)) - Z(:, i);
        Gs{i} = Lx(:, p(i)) * P(i, :);
    end
    h = cat(1, hs{:});
    G = cat(1, Gs{:});

    % nnls
    da = lsqnonneg(G, -h);
%     norm(da)

    % stop condition
    if norm(da) < th
        break;
    end

    % update
    a = a + da;
    a = a / sum(a);
end
A(:, nIt + 1 : end) = [];

W = zeros(m, nx);
W(sub2ind([m, nx], 1 : m, p')) = 1;
