function h = shSegTra(X, seg, varargin)
% Show segment as trajectory in 2-D.
%
% Input
%   X         -  frame matrix, d (= 2) x n
%   seg       -  segmentation
%   varargin
%     show option
%     lnWid   -  line width, {1}
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
parMk = ps(varargin, 'parMk', []);
parAx = ps(varargin, 'parAx', []);

% dimension
[d, n] = size(X);
if d ~= 2
    error('incorrect dimension: %d', d);
end

% segmentation
G = ps(seg, 'G', 0);
s = ps(seg, 's', [1, n + 1]);
l = G2L(G);
[k, m] = size(G);

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
