function h = shStrs(strs, varargin)
% Show string.
%
% Input
%   strs     -  string list, 1 x m (cell)
%   varargin
%     show option
%     h0     -  original handle, {[]}
%     cl     -  string color, {'r'}
%     ftNme  -  font name, {'Arial'}
%     ftSiz  -  font size, {13}
%     ftWei  -  font weight, {'Normal'}
%
% Output
%   h        -  new handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-05-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
h0 = ps(varargin, 'h0', []);
cl = ps(varargin, 'cl', 'r');
ftNme = ps(varargin, 'ftNme', 'Arial');
ftWei = ps(varargin, 'ftWei', 'Normal');
ftSiz = ps(varargin, 'ftSiz', 13);

n = length(strs);

% string color
if ~iscell('cl')
    cl0 = cl;
    cl = cell(1, n);
    for i = 1 : n
        cl{i} = cl0;
    end
end

% string width in percentage
lens0 = cellDim(strs, 2);
lens = [0 lens0] / sum(lens0);

if isempty(h0)
    h.hStrs = cell(1, n);
    for i = 1 : n
        pos = sum(lens(1 : i)) + lens(i + 1) / 2;
        h.hStrs{i} = text('Position', [pos, .5], 'HorizontalAlignment', 'center', 'Units', 'normalized', ...
            'String', strs{i}, 'Color', cl{i}, ...
            'FontName', ftNme, 'FontSize', ftSiz, 'FontWeight', ftWei);
    end
else
    for i = 1 : n
        set(h0.hStrs{i}, 'String', strs{i});
    end
    h = h0;
end
