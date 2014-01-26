function [Xs, X0s] = weiAliDataX(wsData, feats, parPca)
% Obtain Weizmann mocap feature for alignment.
%
% Input
%   wsData  -  wei data
%   feats   -  1 x m (cell)
%   parPca  -  pca parameter, see function pca for more details
%
% Output
%   Xs      -  feature matrix, 1 x m (cell), di x ni
%   X0s     -  feature matrix with same dimension, 1 x m (cell), min(d1, ..., dm) x ni
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(feats);

% projection
XBs = pcas(wsData.XBs, parPca);
XEs = pcas(wsData.XEs, parPca);
XPs = pcas(wsData.XPs, parPca);
XCs = pcas(wsData.XCs, parPca);
XVs = pcas(wsData.XVs, parPca);

% feature
Xs = cellss(1, m);
for i = 1 : m

    if strcmp(feats{i}, 'XB')
        Xs{i} = XBs{i};

    elseif strcmp(feats{i}, 'XE')
        Xs{i} = XEs{i};

    elseif strcmp(feats{i}, 'XP')
        Xs{i} = XPs{i};

    elseif strcmp(feats{i}, 'XC')
        Xs{i} = XCs{i};

    elseif strcmp(feats{i}, 'XV')
        Xs{i} = XVs{i};

    else
        error('unknown feature type: %s', feats{i});
    end
end

X0s = pcas(Xs, st('d', min(cellDim(Xs, 1)), 'cat', 'n'));
