function [Y, Vs, mes, R] = genTranSpatio(X, k)
% Generate parameter for spatio transformation.
%
% Input
%   X       -  original sequence, d x n
%   k       -  number of basis
%
% Output
%   Y       -  original sequence, b x n
%   Vs      -  transformation set, 1 x k (cell), d x b
%   mes     -  mean matrix, 1 x k (cell), d x 1
%   rs      -  weight, 1 x k (cell), n x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-30-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[d, n] = size(X); b = d;
[Ys, Vs, mes] = cellss(1, k);
R = ones(k, n);
for c = 1 : k
    % transformation
    if d == 2
        ang = rand(1) * pi;
        s1 = rand(1) * 2;
        s2 = rand(1) * 2;

        Vs{c} = [s1 * cos(ang), s2 * sin(ang); ...
                -s1 * sin(ang), s2 * cos(ang)];

    else
        error('unsupported yet');
    end

    % mean
    mi = min(X, [], 2);
    ma = max(X, [], 2);
    mes{c} = mi + (ma - mi) .* (rand(d, 1) - .5) * 2;

    % weight
    if k > 1
        cen = round(rand(1) * n);
        var = round(rand(1) * n * .1);
        var = max(1, var);
        R(c, :) = gaussBump(n, cen, var) + 1;
    end
end

% new weights
R = R ./ repmat(sum(R, 1), k, 1);

% new sequence
Y = zeros(b, n);
for c = 1 : k
    X1 = X - repmat(mes{c}, 1, n);
    X2 = X1 * diag(R(c, :));
    Ys{c} = Vs{c} * X2;

    Y = Y + Ys{c};
end
