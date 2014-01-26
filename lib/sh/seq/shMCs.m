function shMCs(M, seg, Cs, varargin)
% Show matrix as well as the correspondence of each pair of segments.
%
% Input
%   M        -  2-D matrix, n x n
%   seg      -  segmentation
%   Cs       -  correspondence for each pair of segments, m x m
%   varargin
%     show option
%     lnWid  -  line width (for correspondence), {1}
%     bdWid  -  line width (for boundary), {1}
%     bdCl   -  line color (for boundary), {[.5 .5 1]}
%     img    -  image flag, {'y'} | 'n'
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 2);
bdWid = ps(varargin, 'bdWid', 1);
bdCl = ps(varargin, 'bdCl', [.5 .5 1]);
isImg = psY(varargin, 'img', 'y');

n = size(M, 1);

% markers
[~, colors] = genMkCl;

% matrix content
if isImg
    imagesc(M);
    colormap(gray);
end

% correspondence (path)
hold on;
m = size(Cs, 1);
s = seg.s; G = seg.G;
l = G2L(G);
for i = 1 : m
    for j = 1 : m
        if l(i) == l(j)
            C = Cs{i, j};
            si = s(i); sj = s(j);

            x = C(2, :) + sj - 1;
            x = [x(1) - .2, x, x(end) + .2];
            y = C(1, :) + si - 1;
            y = [y(1) - .2, y, y(end) + .2];
            
            cl = colors{mod(l(i) - 1, length(colors)) + 1};
            plot(x, y, '-', 'Color', cl, 'lineWidth', lnWid);
        end
    end
end

% boundary
axis([1 - .5, n + .5, 1 - .5, n + .5]);
axis ij; axis square; set(gca, 'ticklength', [0 0]);

% boundary of segment
if bdWid > 0
    hold on;
    for i = 2 : m
        line([s(i) s(i)] - .5, [0 n] + .5, 'Color', bdCl, 'LineWidth', bdWid);
        line([0 n] + .5, [s(i) s(i)] - .5, 'Color', bdCl, 'LineWidth', bdWid); 
    end
end
