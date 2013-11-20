function [Vs, mes] = mcca(Xs, par)
% Multi-set Canonical Correlation Analysis (MCCA).
%
% Input
%   Xs      -  original sample matrix. 1 x m (cell), di x n or (di + 1) x n
%   par     -  parameter
%     cen   -  flag of centrarization, {'y'} | 'n'
%     homo  -  flag of using homogeneous coordinate in Xs, {'y'} | 'n'
%                'y': input data is using homogeneous coordinate
%                'n': input data is not using homogeneous coordinate
%     reg   -  regularization method, {'fix'} | 'eig'
%                'fix': manually specified
%                'eig': based on eigen-decomposition
%     lams  -  manually specified regularization value (used if reg == 'fix'), {0}
%     d     -  deciding the dimensions after projection, {.999}
%                d < 1:  percentage of energy to keep
%                1 <= d: #dimensions to keep
%
% Output
%   Vs      -  transformation matrix, 1 x m (cell), (di + 1) x (d + 1)
%   mes     -  mean, 1 x m (cell), di x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% function parameter
isCen = psY(par, 'cen', 'y');
isHomo = psY(par, 'homo', 'y');
reg = ps(par, 'reg', 'fix');
lams = ps(par, 'lams', 0);
d = ps(par, 'd', .999);

% dimension
m = length(Xs);
ds = cellDim(Xs, 1);

% regularization
if isempty(lams)
    lams = zeros(1, m);
elseif length(lams) == 1
    lams = zeros(1, m) + lams;
end

% input is using homogeneous coordinate
if isHomo
    ds = ds - 1;
    for j = 1 : m
        Xs{j}(end, :) = [];
    end
end

% centralize
mes = cell(1, m);
for i = 1 : m
    if isCen
        [Xs{i}, mes{i}] = cenX(Xs{i});
    else
        mes{i} = zeros(ds(i), 1);
    end
end

% core implementation
Vs = mccaCore(Xs, ds, reg, lams, d);

% using homogeneous coordinate in output
for j = 1 : m
    Vs{j} = [Vs{j}, zeros(ds(j), 1); ...
             -mes{j}' * Vs{j}, 1];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Vs = mccaCore(Xs, ds, reg, lams, d)
% Core implementation of MCCA.
%
% Input
%   Xs    -  original sample matrix. 1 x m (cell), di x n
%   ds    -  dimension, 1 x m
%   reg   -  regularization method
%   lams  -  regularization weight, 1 x m
%   b     -  #dimension to keep
%
% Output
%   Vs    -  transformation matrix, 1 x m (cell), di x b

% dimension
dSum = sum(ds);
m = length(ds);
s = n2s(ds);

% convariance
[CD, CO] = zeross(dSum, dSum);
for i = 1 : m
    % diagonal part
    idxi = s(i) : s(i + 1) - 1;
    CD(idxi, idxi) = Xs{i} * Xs{i}';

    % off-diagonal part
    for j = i + 1 : m
        idxj = s(j) : s(j + 1) - 1;
        CO(idxi, idxj) = Xs{i} * Xs{j}';
        CO(idxj, idxi) = CO(idxi, idxj)';
    end
end

% regularization
if strcmp(reg, 'fix')
    lam2s = lams;
elseif strcmp(reg, 'eig')
    lam2s = zeros(1, m);
    for i = 1 : m
        idx = s(i) : s(i + 1) - 1;
        CDi = CD(idx, idx);
        [~, Di] = eig(CDi);
        Lamb = sort(sum(Di, 2), 'descend');
        ind = find(Lamb < 1e-4, 1); ind = ind - 1;
        lam1 = Lamb(ind);
        lam2 = min(Lamb);
        lami = (lam1 - lam2) / 2;
        lam2s(i) = lami;
    end
else
    error('unknown reg: %s', reg);
end
for i = 1 : m
    idx = s(i) : s(i + 1) - 1;
    CD(idx, idx) = (1 - lam2s(i)) * CD(idx, idx) + lam2s(i) * eye(ds(i));
end

% generalized eigen-decomposition
[V, Lamb] = eig(CO, CD);
[lambs, idx] = sort(sum(Lamb, 2), 'descend');
V = V(:, idx);

% energy
lambs = lambs(1 : min(ds));
if d < 1
    d = thEgy(lambs, d);
end

% split
Vs = cell(1, m);
Us = cell(1, m);
for i = 1 : m
    Vs{i} = V(s(i) : s(i + 1) - 1, 1 : d);
    
    % constraint
    Us{i} = Vs{i}' * CD(s(i) : s(i + 1) - 1, s(i) : s(i + 1) - 1) * Vs{i};
end
U = sum(cat(3, Us{:}), 3);
