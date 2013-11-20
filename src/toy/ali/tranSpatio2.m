function [X, As, W] = tranSpatio2(X0, Para, mes, vars, weis)
% Apply weighted affine transformation on sequence.
%
% Remark:
%   X(:, i) = \sum_{c = 1}^k W(c, i) * A(:, :, i) * X0(:, i)
%
% Input
%   X0      -  original sample matrix, dim x n
%   Para    -  parameter of affine transformation, 5 x m
%   mes     -  means for bumps, 1 x m
%   vars    -  varaiances for bumps, 1 x m
%   weis    -  weights of transformation, 1 x m
%
% Output
%   X       -  new sample matrix, dim x n
%   As      -  affine transformation, 3 x 3 x (m + 1)
%   W       -  weights of transformation (W^T * 1_m == 1_n), (m + 1) x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-04-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[dim, n] = size(X0);
m = size(Para, 2);

As = zeros(3, 3, m + 1);
W = zeros(m + 1, n);

% affine transformation
for c = 1 : m
    para = Para(:, c);

    ang = para(1); s1 = para(2); s2 = para(3); t1 = para(4); t2 = para(5);
    if isnan(ang)
        ang = rand(1) * 180;
    end
    if isnan(s1)
        s1 = rand(1) * 2;
    end
    if isnan(s2)
        s2 = rand(1) * 2;
    end
    if isnan(t1)
        mi = min(X0(1, :)); ma = max(X0(1, :));
        t1 = (ma - mi) * rand(1) * 2;
    end
    if isnan(t2)
        mi = min(X0(2, :)); ma = max(X0(2, :));
        t2 = (ma - mi) * rand(1) * 2;
    end

    ang = pi * ang / 180;
    As(:, :, c) = [s1 * cos(ang), s2 * sin(ang), t1; ...
                  -s1 * sin(ang), s2 * cos(ang), t2; ...
                               0,             0,  1];

   % weights
   if ~isnan(mes(c))
       me = round(mes(c) * n);
       var = round(vars(c) * n);
       W(c, :) = gaussBump(n, me, var) * weis(c);
   end
end

% trival transformation
As(:, :, m + 1) = eye(3);
a = sum(W, 1); ma = max(a);
if m == 0
    W(m + 1, :) = 1;
else
    W(m + 1, :) = (ma - a) / ma;
end

% transform
X = zeros(dim, n);
for i = 1 : n
    x0 = [X0(:, i); 1];
    x = zeros(dim + 1, 1);

    for c = 1 : m + 1
        x = x + W(c, i) * As(:, :, c) * x0;
    end

    X(:, i) = x(1 : dim);
end
