function [X, A, P, mu] = tranSpatio(X0, hy)
% Apply affine transformation on sequence.
%
% Remark:
%   bases, Mes, Vars, weis are cell arrays with 5 elements
%     1: angle
%     2: scale in x
%     3: scale in y
%     4: translate in x
%     5: translate in y
%
% Input
%   X0       -  original sample matrix, 2 x n
%   hy       -  hyper-parameter
%     bases  -  bases for transformation, 1 x 5 (cell)
%     Mes    -  means for bumps, 1 x 5 (cell), 1 x mi
%     Vars   -  varaiances for bumps, 1 x 5 (cell), 1 x mi
%     weis   -  weights
%
% Output
%   X        -  new sample matrix, 2 x n
%   A        -  affine transformation, 5 x n
%   P        -  transformation, 2 x 2 x n
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-04-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[dim, n] = size(X0);
[bases, Mes, Vars, weis] = stFld(hy, 'bases', 'Mes', 'Vars', 'weis');

% parameter of transformation
A = zeros(5, n); P = zeros(2, 2, n); mu = zeros(2, n);
for i = 1 : 5
    base = bases{i}; mes = Mes{i}; vars = Vars{i}; wei = weis{i};

    if isempty(base)
        % angle
        if i == 1
            base = rand(1) * 180;

        % scale in x
        elseif i == 2
            base = rand(1) * 2;

        % scale in y
        elseif i == 3
            base = rand(1) * 2;

        % translation in x
        elseif i == 4
            mi = min(X0(1, :)); ma = max(X0(1, :));
            base = (ma - mi) * rand(1) * 2;

        % translation in y
        else
            mi = min(X0(2, :)); ma = max(X0(2, :));
            base = (ma - mi) * rand(1) * 2;
        end
    end

    % local weight
    mes = round(mes * n);
    vars = round(vars * n);
    tmp = gaussBump(n, mes, vars);

    % put together
    A(i, :) = base + tmp * wei;
end

% move center to 0
% me = mean(X0, 2);
% X0 = X0 - repmat(me, 1, n);

% affine transformation
X = zeros(dim, n);
for i = 1 : n
    ang = A(1, i) * pi / 180;
    sx  = A(2, i);
    sy  = A(3, i);
    tx  = A(4, i);
    ty  = A(5, i);
    x0  = X0(:, i);

    if dim == 1
        X(:, i) = sx * x0 + tx;
    else
        Rot  = [cos(ang), sin(ang); -sin(ang), cos(ang)];
        Sca = [sx, 0; 0, sy];
        tra = [tx; ty];
        X(:, i) = Rot * Sca * x0 + tra;
    end

    P(:, :, i) = Rot * Sca;
    mu(:, i) = tra;
end

% restore the original center
% X = X + repmat(me, 1, n);
