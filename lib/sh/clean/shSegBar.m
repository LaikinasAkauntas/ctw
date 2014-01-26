function shSegBar(seg, varargin)
% Show segmentation indicated by bar for 1-D sequence.
%
% Input
%   seg      -  segmentation
%   varargin
%     show option
%     lnWid  -  line width, {1}
%     cShs   -  index of classes that will be shown, {[]}
%     pShs   -  position of segments that will be shown, {[]}
%     last   -  flag of show the last class, {'y'} | 'n'
%               only used when cShs == []
%     parAx  -  axis parameter, {[]}, see function setAx for more details
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 01-03-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 03-06-2012

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 1);
cShs = ps(varargin, 'cShs', []);
pShs = ps(varargin, 'pShs', []);
isLast = psY(varargin, 'last', 'y');
parAx = ps(varargin, 'parAx', []);

% segmentation
G = seg.G;
s = seg.s;
l = G2L(G);
[k, m] = size(G);

% classes that will be shown
if isempty(cShs)
    if isLast
        cShs = 1 : k;
    else
        cShs = 1 : k - 1;
    end
end
cVis = idx2vis(cShs, k);

% segments that will be shown
if isempty(pShs)
    pShs = 1 : m;
end
pVis = idx2vis(pShs, m);

% sort
if cluEmp(G)
    idx = 1 : m;
else
    [idx, vis] = zeross(1, m);
    for c = 1 : k
        idx(c) = find(l == c, 1);
        vis(idx(c)) = 1;
    end
    idx(k + 1 : end) = find(vis == 0);
end

% default axis parameter
if isempty(parAx)
    parAx = st('mar', [.01 .1], 'ax', 'n');
end

% plot
hold on;
[mks, cls] = genMkCl;
for j = 1 : m
    i = idx(j);
    c = l(i);

    % skip segment
    if ~cVis(c) || ~pVis(i)
        continue;
    end

    x = [s(i), s(i + 1), s(i + 1), s(i)];
    y = [0, 0, 1, 1];

    if i == m
        x(2) = x(2) - 1;
        x(3) = x(3) - 1;
    end

    % color
    cc = mod(c - 1, length(cls)) + 1;
    cl = cls{cc};

    if lnWid == 0
        fill(x, y, cl, 'EdgeColor', cl);
    else
        fill(x, y, cl, 'EdgeColor', 'w', 'LineWidth', lnWid);
    end
end

% axix
ha.box = xBox([1, s(end) - 1; 0, 1], parAx);
setAx(ha.box, parAx);

set(gca, 'Visible', 'off');