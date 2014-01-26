function [Xs, X0s] = hsaAliDataX(wsData, feats, parPca)
% Obtain Humansensing Accelerometer feature for alignment.
%
% Input
%   wsData  -  hsa data
%   feats   -  1 x m (cell)
%   parPca  -  pca parameter, see function pca for more details
%
% Output
%   Xs      -  feature matrix, 1 x m (cell), di x ni
%   X0s     -  feature matrix, 1 x m (cell), min(d1, ..., dm) x ni
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(feats);

% projection
XAs = pcas(wsData.XAs, parPca);

% feature
Xs = cellss(1, m);
for i = 1 : m

    if strcmp(feats{i}, 'XA')
        Xs{i} = XAs{i};

    else
        error('unknown feature type: %s', feats{i});
    end
end

X0s = pcas(Xs, st('d', min(cellDim(Xs, 1)), 'cat', 'n'));
