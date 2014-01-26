function shSeqAli1ds(X, seg, Cs, varargin)
% Show alignment of a segmented sequence.
%
% Input
%   X        -  1-D sequence set, 1 x n
%   seg      -  segmentation
%   Cs       -  correspondence matrix, 1 x m (cell)
%   varargin
%     show option
%     lnWid  -  line width, {1}
%     mkSiz  -  size of markers, {5}
%     mkEg   -  flag of marker edge, {'y'} | 'n'
%     leg    -  legends, {[]}
%     vGap   -  gap in vertical, {1}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 1);
mkSiz = ps(varargin, 'mkSiz', 5);
isMkEg = psY(varargin, 'mkEg', 'y');
wGap = ps(varargin, 'wGap', .5);
vGap = ps(varargin, 'vGap', 1);

% dimension
dim = size(X, 1);
if dim ~= 1
    error('dimension must be one');
end

% segmentation
G = seg.G; s = seg.s; l = G2L(G);
[k, m] = size(G);
ns = diff(s);
nMa = max(ns);
xMa = max(X);

% plot segment
[markers, colors] = genMarkers;
hold on;
[cs, xs, ys] = cellss(1, 2);
for i1 = 1 : m
    for i2 = 1 : m
        % position
        p1 = s(i1) : s(i1 + 1) - 1;
        p2 = s(i2) : s(i2 + 1) - 1;
        
        xs{1} = (0 : ns(i1) - 1) + (nMa - 1 + wGap) * (i2 - 1) + wGap;
        xs{2} = (0 : ns(i2) - 1) + (nMa - 1 + wGap) * (i2 - 1) + wGap;

        ys{1} = X(p1) + (xMa * 2 + vGap) * (m - i1) + xMa + vGap;
        ys{2} = X(p2) + (xMa * 2 + vGap) * (m - i1);
        
        cs{1} = l(i1);
        cs{2} = l(i2);

        % alignment
        C = Cs{i1, i2};
        nC = size(C, 2);
        for iC = 1 : nC
            i = C(1, iC);
            j = C(2, iC);
            plot([xs{1}(i), xs{2}(j)], [ys{1}(i), ys{2}(j)], '--', 'Color', 'k', 'LineWidth', 1);
        end

        % segment
        for i = 1 : 2
            hTmp = plot(xs{i}, ys{i}, '-', 'LineWidth', lnWid);

            % color
            if cs{i} == 0
                cc = 1;
            else
                cc = mod(cs{i} - 1, length(colors)) + 1;
            end
            cl = colors{cc};
            set(hTmp, 'Color', cl);

            % marker
            mk = markers{cc};
            if mkSiz > 0
                set(hTmp, 'Marker', mk, 'MarkerSize', mkSiz, 'MarkerFaceColor', cl);

                if isMkEg
                    set(hTmp, 'MarkerEdgeColor', 'k');
                end
            end
        end
    end
end

% bound
axis([0, (nMa - 1) * m + wGap * (m + 1), 0, (xMa * 2 + vGap) * m]);
axis square;
