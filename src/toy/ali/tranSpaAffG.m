function [P, mu] = tranSpaAffG(n, par, box)
% Generater affine transformation (global).
%
% Input
%   n        -  #sample
%   par      -  parameter
%     bases  -  bases for transformation, 1 x 5 (cell)
%     Mes    -  means for bumps, 1 x 5 (cell), 1 x mi
%     Vars   -  varaiances for bumps, 1 x 5 (cell), 1 x mi
%     weis   -  weights
%  box       -  data range, 2 x 2
%               box(1, 1) = min(X0(1, :)); box(1, 2) = max(X0(1, :));
%               box(2, 1) = min(X0(2, :)); box(2, 2) = max(X0(2, :));
%
% Output
%   P        -  projection, 2 x 2
%   mu       -  translation, 2 x 1
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-04-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parameter
[bases, Mes, Vars, weis] = stFld(par, 'bases', 'Mes', 'Vars', 'weis');

% parameter of transformation
A = zeros(5, n);
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
            mi = box(1, 1); ma = box(1, 2);
            base = (ma - mi) * rand(1) * 2;

        % translation in y
        else
            mi = box(2, 1); ma = box(2, 2);
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

% affine transformation
P = zeros(2, 2, n); Mu = zeros(2, n);
for i = 1 : n
    ang = A(1, i) * pi / 180;
    sx  = A(2, i);
    sy  = A(3, i);
    tx  = A(4, i);
    ty  = A(5, i);

%   X(:, i) = Rot * Sca * x0 + tra;
    Rot = [cos(ang), sin(ang); -sin(ang), cos(ang)];
    Sca = [sx, 0; 0, sy];
    tra = [tx; ty];

    P(:, :, i) = Rot * Sca;
    Mu(:, i) = tra;
end

P = P(:, :, 1);
mu = Mu(:, 1);
