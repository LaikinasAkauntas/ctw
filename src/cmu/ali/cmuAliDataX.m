function [Xs, X0s] = cmuAliDataX(wsData, feats, parPca)
% Obtain feature for alignment.
%
% Input
%   wsData  -  cmu data
%   feats   -  1 x m (cell)
%   parPca  -  pca parameter, see function pca for more details
%
% Output
%   Xs      -  feature matrix, 1 x m (cell), di x ni
%   X0s     -  feature matrix, 1 x m (cell), min(d1, ..., dm) x ni
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% dimension
m = length(feats);

% projection
XQs = pcas(wsData.XQs, parPca);
XPs = pcas(wsData.XPs, parPca);

% feature
Xs = cellss(1, m);
for i = 1 : m

    if strcmp(feats{i}, 'XQ')
        Xs{i} = XQs{i};

    elseif strcmp(feats{i}, 'XP')
        Xs{i} = XPs{i};

    else
        error('unknown feature type: %s', feats{i});
    end
end

X0s = pcas(Xs, st('d', min(cellDim(Xs, 1)), 'cat', 'n'));
