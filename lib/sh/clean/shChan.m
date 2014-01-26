function [h, Y, Z] = shChan(X, varargin)
% Show each channel (dimension) of the given sequence.
%
% Input
%   X         -  sequence, dim x nF
%   varargin
%     show option
%     seg     -  segmentation, {[]}
%     gap     -  gap between two channels, {.5}
%     nms     -  channel names, {[]}
%     xNms    -  channel names in , {[]}
%     lnWid   -  line width, {1}
%     cutWid  -  cut line width, {2}
%     mkSiz   -  size of markers, {5}
%     mkEg    -  flag of marker edge, {'y'} | 'n'
%
% Output
%   h         -  handle for the figure
%     box     -  limitation of the axis
%   Y         -  new sequence (after adjusting the range), dim x n
%   Z         -  new sequence (after adjusting the range and plotting on the figure), dim x n
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 03-31-2009
%   modify    -  Feng Zhou (zhfe99@gmail.com), 03-04-2012

% show option
psSh(varargin);

% function option
seg = ps(varargin, 'seg', []);
gap = ps(varargin, 'gap', .5);
cutWid = ps(varargin, 'cutWid', 2);
lnWid = ps(varargin, 'lnWid', 1);
mkSiz = ps(varargin, 'mkSiz', 5);
isMkEg = psY(varargin, 'mkEg', 'y');
nms = ps(varargin, 'nms', []);
xNms = ps(varargin, 'xNms', []);
pcs = ps(varargin, 'pcs', []);

% channel
[dim, nF] = size(X);
[Y, Z] = zeross(dim, nF);
[mis, mas] = zeross(1, dim);
tiPs = cellss(1, dim);

% labels
G = ps(seg, 'G', 1);
s = ps(seg, 's', [1, nF + 1]);
[k, m] = size(G)
l = G2L(G);

ns = diff(s);
nMas = zeros(1, k);
for c = 1 : k
    nMas(c) = max(ns(l == c));
end
sMa = n2s(nMas);

% markers
[mks, cls] = genMkCl;
hold on;

% each channel
base = 0;
for d = 1 : dim

    x = X(d, :);
    mid = min(x); mis(d) = base;
    mad = max(x); mas(d) = base + 1;

    y = (x - mid) / (mad - mid);
    Y(d, :) = y;
    
    z = y + base;
    Z(d, :) = z;

    % segment
    for i = 1 : m
        c = l(i);

        xx = sMa(c) : sMa(c) + ns(i) - 1;

        idx = s(i) : s(i + 1) - 1;
        yy = z(idx);
        
        if any(pcs == i)
            lnWid2 = lnWid + 1;
        else
            lnWid2 = lnWid;
        end

        hTmp = plot(xx, yy, '-', 'LineWidth', lnWid2, 'Color', cls{c});

        % color
        if isempty(c)
            set(hTmp, 'Color', cls{1});
        else
            set(hTmp, 'Color', cls{c});

            % marker
            if mkSiz > 0
                set(hTmp, 'Marker', mks{c}, 'MarkerSize', mkSiz, 'MarkerFaceColor', cls{c});

                if isMkEg
                    set(hTmp, 'MarkerEdgeColor', 'k');
                end
            end
        end
    end

    % ticks
    tiPs{d} = base + .5;

    % base
    base = base + 1 + gap;
end

% ticks
set(gca, 'ticklength', [0 0]);
set(gca, 'YTick', cat(2, tiPs{:}), 'YTickLabel', nms);
if ~isempty(xNms)
    set(gca, 'XTick', sMa(1 : end - 1) + nMas / 2, 'XTickLabel', xNms);
end

% cutlines
if cutWid > 0
    
%     xL = [sMa(2 : k); sMa(2 : k)] - 0.5;
%     yL = repmat(h.lim(2, :)', 1, k - 1);

    xL = [s(2 : m); s(2 : m)] - 0.5;
    yL = repmat([0; base], 1, m - 1);

    line(xL, yL, 'LineStyle', '--', 'LineWidth', cutWid, 'Color', 'k');
end

mi = 0;
ma = base - gap;

% boundary
axis([1, sMa(end) - 1, mi, ma]);

% handle
h.box = [1, sMa(end) - 1; ...
         mi, ma];
