function [Ys, Zs, Us] = gtwTra(Xs, ali, parV, parP)
% Transformation of sequence.
%
% Remark
%   Ys{i} = Vs{i}' * Xs{i} * Ws{i}
%
% Input
%   Xs      -  sequence, 1 x m (cell), di x ni
%   ali     -  alignment
%     Vs    -  projection, 1 x m (cell), di x d
%     P     -  warping path, l x m
%   parV    -  parameter for spatial transformation
%     lams  -  lambda for regularization, {[]}, See function mcca for more details
%   parP    -  parameter for temporal warping, See function seqInp for more details
%
% Output
%   Ys      -  sequence, 1 x m (cell), d x ni
%   Zs      -  sequence, 1 x m (cell), d x l
%   Us      -  constraint, 1 x m (cell), d x d
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-06-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-22-2013

% function parameter
lams = ps(parV, 'lams', []);

% dimension
m = length(Xs);
if isempty(lams)
    lams = zeros(1, m);
elseif length(lams) == 1
    lams = zeros(1, m) + lams;
end

% spatial transformation
if isfield(ali, 'Vs') && ~isempty(ali.Vs)
    Ys = cellTim(cellTra(ali.Vs), Xs);
else
    Ys = Xs;
end

% temporal warping
if isfield(ali, 'P') && ~isempty(ali.P)
    Zs = seqInp(Ys, ali.P, parP);
    X0s = seqInp(Xs, ali.P, parP);
else
    Zs = Ys;
    X0s = Xs;
end

% constraint
Us = cell(1, m);
for i = 1 : m
    X0 = X0s{i}(1 : end - 1, :);
    X = cenX(X0);

    if isfield(ali, 'Vs') && ~isempty(ali.Vs)
        V = ali.Vs{i}(1 : end - 1, 1 : end - 1);
        di = size(X, 1);
        Us{i} = V' * ((1 - lams(i)) * (X * X') + lams(i) * eye(di)) * V;
    else
        Us{i} = 1;
    end
end
U = sum(cat(3, Us{:}), 3);
