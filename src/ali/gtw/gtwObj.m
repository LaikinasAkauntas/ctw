function [obj, Xs] = gtwObj(Xs, ali, parV, parP)
% Computing the objective of GTW, which is defined as
%   obj = sum_i sum_j 1 / 2 || Vi' Xi W(Pi) - Vj' Xj W(Pj) ||_F^2 + sum_i Phi_i(Vi) + sum_i Psi_i(W(Pi))
%   Vi' ((1 - lami) Xi W(Pi) W(Pi)' Xi' + lami Idi) Vi = Id / m
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
%   obj     -  objective
%   Xs      -  sequence, 1 x m (cell), d x t
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-06-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

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
    Xs = cellTim(cellTra(ali.Vs), Xs);
end

% temporal warping
if isfield(ali, 'P') && ~isempty(ali.P)
    Xs = seqInp(Xs, ali.P, parP);
end

% pairwise distance
obj = 0;
for i = 1 : m
    for j = i + 1 : m
        tmp = (Xs{i} - Xs{j}) .^ 2;
        obj = obj + sum(tmp(:));
    end
end

% regularization
obj2 = 0;
if isfield(ali, 'Vs') && ~isempty(ali.Vs)
    for i = 1 : m
        tmp = ali.Vs{i} .^ 2;
        obj2 = obj2 + lams(i) / (1 - lams(i)) * sum(tmp(:));
    end
end
obj = obj + obj2;
