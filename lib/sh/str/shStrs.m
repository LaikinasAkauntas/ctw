function h = shStrsIni(strs, varargin)
% Show a string list (Initialization).
%
% Input
%   strs     -  string list, 1 x n (cell)
%   varargin
%     show option
%     ti     -  title, {[]}
%     cl     -  string color, {[.4 .4 .4]}
%     ftNme  -  font name, {'Arial'}
%     ftSiz  -  font size, {23}
%
% Output
%   h        -  handle container
%     hStrs  -  string handle
%     vis    -  visit flag, 1 x n
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-31-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
ti = ps(varargin, 'ti', []);
cl = ps(varargin, 'cl', [.4 .4 .4]);
ftNme = ps(varargin, 'ftNme', 'Monoca');
ftSiz = ps(varargin, 'ftSiz', 23);

% title
if ~isempty(ti)
    tiWid = .1;
    text('Position', [tiWid, .5], 'HorizontalAlignment', 'right', 'Units', 'normalized', ...
         'String', ti, 'Color', 'w', ...
         'FontName', ftNme, 'FontSize', 15, 'FontWeight', 'normal');
else
    tiWid = 0;
end

% string list
n = length(strs);
h.hStrs = cell(1, n);

% string width in percentage
lens0 = cellDim(strs, 2);
lens = [0 lens0] / sum(lens0);

Extent = zeros(n, 4);
for i = 1 : n
    pos = tiWid + (1 - tiWid) * (sum(lens(1 : i)) + lens(i + 1) / 2);
    h.hStrs{i} = text('Position', [pos, .5], 'HorizontalAlignment', 'center', 'Units', 'Normalized', ...
        'String', strs{i}, 'Color', cl, 'LineWidth', 1, ...
        'FontName', ftNme, 'FontSize', ftSiz, 'FontWeight', 'bold', 'Margin', 1);
    Extent(i, :) = get(h.hStrs{i}, 'Extent');
end

% adjust extent position again
exSum = sum(Extent(:, 3));
gap = (1 - exSum) / (n + 1);
for i = 1 : n
    pos = gap * i + Extent(i, 3) / 2;
    if i > 1
        pos = pos + sum(Extent(1 : i - 1, 3));
    end
    set(h.hStrs{i}, 'Position', [pos, .5]);
end

h.vis = zeros(1, n);
