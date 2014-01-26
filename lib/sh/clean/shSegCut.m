function ha = shSegCut(X, seg, varargin)
% Show segmentation indicated by cut lines for 1-D sequence.
%
% Input
%   X         -  sequence, d (= 1) x n
%   seg       -  segmentation
%   varargin
%     show option
%     cutWid  -  cut line width, {2}
%     cutCl   -  cut line color, {'k'}
%     parMk   -  marker parameter, {[]}, see function plotmk for more details
%     parAx   -  axis parameter, {[]}, see function setAx for more details
%
% Output
%   ha        -  handle for the figure
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-31-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
cutWid = ps(varargin, 'cutWid', 2);
cutCl = ps(varargin, 'cutCl', 'k');
parMk = ps(varargin, 'parMk', []);
parAx = ps(varargin, 'parAx', []);

% dimension
[d, n] = size(X);
if d ~= 1
    error('incorrect dimension: %d', d);
end
X = [1 : n; X];

% segmentation
G = ps(seg, 'G', 0);
s = ps(seg, 's', [1, n + 1]);
l = G2L(G);
[~, m] = size(G);

% default marker parameter
if isempty(parMk)
    parMk = st('mkSiz', 5, 'mkEg', 'n', 'ln', '-');
end

% default axis parameter
if isempty(parAx)
    parAx = st('mar', [.01 .1]);
end

% main plot
hold on;
ha.mks = cell(1, m);
for i = 1 : m
    c = l(i);
    idx = s(i) : s(i + 1) - 1;

    ha.mks{i} = plotmk(X(:, idx), c, parMk);
end

% axix
ha.box = xBox(X, parAx);
setAx(ha.box, parAx);

% cutlines
if cutWid > 0
    xL = [s(2 : m); s(2 : m)] - 0.5;
    yL = repmat(ha.box(2, :)', 1, m - 1);
    plot(xL, yL, '--', 'LineWidth', cutWid, 'Color', cutCl);
end
