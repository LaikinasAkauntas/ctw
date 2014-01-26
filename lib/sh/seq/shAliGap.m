function shAliGap(Xs, ali, varargin)
% Show sequences with the correspondances on their frames.
%
% Input
%   Xs       -  sequence set, 1 x m (cell), dim x ni
%   ali      -  alignment
%   varargin
%     show option
%     lnWid  -  line width, {1}
%     step   -  step for warping, {0}
%     unit   -  unit in z axis, {1}
%     vang   -  view angle, {[15 30]}
%     c      -  correspondence color, {1}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-06-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 01-24-2013

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 1);
mkSiz = ps(varargin, 'mkSiz', 0);
step = ps(varargin, 'step', 0);
unit = ps(varargin, 'unit', 1);
vang = ps(varargin, 'vang', [135, 35]);
c = ps(varargin, 'c', 1);

% dimensionality of sample
m = length(Xs);
dim = size(Xs{1}, 1);
ns = cellDim(Xs, 2);

% markers
[markers, colors] = genMkCl;

% gap
Ys = cell(1, m);
if dim == 1
    error('dimension has to be bigger than 2');
elseif dim == 2
    Ys{1} = [Xs{1}; ones(1, ns(1)) * unit * 1];
    Ys{2} = [Xs{2}; ones(1, ns(2)) * unit * 2];
else
    X0 = cat(2, Xs{:});
    s = n2s(ns);
    X = embed(X0, [], 2, 'alg', 'pca');
    for i = 1 : m
        Xs{i} = X(:, s(i) : s(i + 1) - 1);
    end
    Ys{1} = [Xs{1}; ones(1, ns(1)) * unit * 1];
    Ys{2} = [Xs{2}; ones(1, ns(2)) * unit * 2];
end

% show sequences
hold on;
for i = 1 : m
    Y = Ys{i};

    if dim == 1
        hTmp = plot(Y(1, :), Y(2, :));
    else
        hTmp = plot3(Y(1, :), Y(2, :), Y(3, :));
    end
    
    % line
    if lnWid > 0
        set(hTmp, 'LineStyle', '-', 'LineWidth', lnWid, 'Color', colors{i});
    else
        set(hTmp, 'LineStyle', 'none');
    end

    % marker
    if mkSiz > 0
        set(hTmp, 'Marker', markers{c}, 'MarkerSize', mkSiz, 'MarkerFaceColor', colors{i});

%         if isMkEg
%             set(hTmp, 'MarkerEdgeColor', 'k');
%         end
    end
end

color2s = {'k', 'r', 'b', 'g', 'm', 'c'};

% show correspondence as lines
P = ali.P;
m = size(P, 1);
if step < 1
    gap = floor(m * step);
else
    gap = step;
end
gap = max(1, gap);
idx = 1 : gap : m;
for p = idx
    y1 = Ys{1}(:, P(p, 1));
    y2 = Ys{2}(:, P(p, 2));
        
    if dim == 1
        line([y1(1), y2(1)], [y1(2), y2(2)], 'LineStyle', '--', 'Color', color2s{c});
    else
        line([y1(1), y2(1)], [y1(2), y2(2)], [y1(3), y2(3)], 'LineStyle', '--', 'Color', color2s{c});
    end
end

% axis
Y = cat(2, Ys{:});

if dim == 1
    setBound(Y, 'mar', [.01 .1]);
    set(gca, 'YTick', []);

else
    setBound(Y, 'mar', [.1 .1 .1]);
    view(vang);
    set(gca, 'ZTick', []);
end
