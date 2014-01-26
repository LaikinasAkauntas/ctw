function ali = utw(Xs, bas, aliT)
% Uniform Time Warping.
%
% Reference
%   Scaling and time warping in time series querying, VLDB, 2008
%
% Input
%   Xs      -  sequences or sequence lengths, 1 x m (cell), di x ni | 1 x m
%   bas     -  bases, [] | 1 x m (cell)
%   aliT    -  ground-truth alignment, [] | struct
%
% Output
%   ali     -  alignment
%     P     -  correspondence matrix, l x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-11-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-26-2013

% dimension
if iscell(Xs)
    m = length(Xs);
    ns = cellDim(Xs, 2);
else
    m = length(Xs);
    ns = Xs;
end

% fit without basis
if isempty(bas)
    prIn('utw: without basis');
    l = max(ns);
    P = zeros(l, m);
    for i = 1 : m
        P(:, i) = round((ns(i) - 1) * ((1 : l)' - 1) / (l - 1) + 1);
    end

% fit with basis
else
    prIn('utw: with basis');
    l = size(bas{1}.P, 1);
    as = cellss(1, m);
    P = zeros(l, m);
    for i = 1 : m
        as{i} = baTemFit(linspace(1, ns(i), l), bas{i});
        P(:, i) = bas{i}.P * as{i};
    end
    ali.a = mcat('vert', as);
end

% store
ali.alg = 'utw';
ali.P = P;

% ground-truth
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end

prOut;
