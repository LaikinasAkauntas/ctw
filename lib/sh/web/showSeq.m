function showSeq(X, seg, varargin)
% Show sequence.
%
% Input
%   X         -  sequence, dim x n
%   seg       -  segmentation
%   parMk     -  marker parameter, see function plotmk for more details
%   parAx     -  axis parameter, see function setAx for more details
%   varargin
%     show option
%     d       -  dimension after projection, {2}
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-31-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
d = ps(varargin, 'd', 2);

% dimension
[d0, n] = size(X);

% project by PCA
if d0 > d
    X = pca(X, st('d', d));
end

% segmentation
G = ps(seg, 'G', 0);
s = ps(seg, 's', [1, n + 1]);
l = G2L(G);
[~, m] = size(G);

% main plot
hold on;
for i = 1 : m
    c = l(i);
    idx = s(i) : s(i + 1) - 1;

    plotmk(X(:, idx), c, st('lnWid', 1, 'mkSiz', 0, 'ln', '-'));
end

% ax
parAx = st('mar', .1, 'sq', 'y');
box = xBox(X, parAx);
setAx(box, parAx);
