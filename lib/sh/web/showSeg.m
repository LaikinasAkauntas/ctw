function [h, parAx] = showSeg(X, seg, varargin)
% Show segmentation.
%
% Input
%   X         -  sequence, dim x n
%   seg       -  segmentation
%   parMk     -  marker parameter, see function plotmk for more details
%   parAx     -  axis parameter, see function setAx for more details
%   varargin
%     show option
%     cutWid  -  cut line width, {2}
%     cutCl   -  cut line color, {'k'}
%
% Output
%   h         -  handle for the figure
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-31-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 03-06-2012

% show option
psSh(varargin);

% function option
cutWid = ps(varargin, 'cutWid', 2);
cutCl = ps(varargin, 'cutCl', 'k');
mkSiz = ps(varargin, 'mkSiz', 5);
box0 = ps(varargin, 'box0', []);

% parameter
parMk = st('ln', '-', 'mkSiz', mkSiz);
parAx = st('mar', [.01 .1], 'box0', box0);

% dimension
[~, n] = size(X);
X = [1 : n; X];

% segmentation
G = ps(seg, 'G', 0);
s = ps(seg, 's', [1, n + 1]);
l = G2L(G);
[~, m] = size(G);

% main plot
hold on;
h.mks = cell(1, m);
for i = 1 : m
    c = l(i);
    idx = s(i) : s(i + 1) - 1;

    h.mks{i} = plotmk(X(:, idx), c, parMk);
end

% ax
h.box = xBox(X, parAx);
setAx(h.box, parAx);

% cutlines
if cutWid > 0
    xL = [s(2 : m); s(2 : m)] - 0.5;
    yL = repmat(h.box(2, :)', 1, m - 1);
    plot(xL, yL, '--', 'LineWidth', cutWid, 'Color', cutCl);
end
