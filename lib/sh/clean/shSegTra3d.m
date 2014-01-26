function shSeg3d(X, seg, varargin)
% Show segmentation in 3-D.
%
% Input
%   X         -  frame matrix, dim x n
%   seg       -  segmentation
%   varargin
%     show option
%     axis    -  axis flag, {'y'} | 'n'
%     lnWid   -  line width, {1}
%     mkSiz   -  size of markers, {5}
%     mkEg    -  flag of marker edge, {'y'} | 'n'
%     lim0    -  predefined limitation, {[]}
%
% Output
%   h         -  handle for the figure
%     lim     -  limitation of the axis
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-31-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 2);
mkSiz = ps(varargin, 'mkSiz', 5);
isMkEg = psY(varargin, 'mkEg', 'y');

% projection
[dim, n] = size(X);
if dim > 3
    X = embed(X, [], 3, 'alg', 'pca');
end

% segmentation
G = ps(seg, 'G', 0);
s = ps(seg, 's', [1, n + 1]);
[k, m] = size(G);

[markers, colors] = genMarkers;

hold on;
for i = 1 : m
    c = find(G(:, i));
    idx = s(i) : s(i + 1) - 1;

    hTmp = plot3(X(1, idx), X(2, idx), X(3, idx), '-', 'LineWidth', lnWid);

    % color
    if isempty(c)
        set(hTmp, 'Color', colors{1});

    else
        cc = mod(c - 1, length(colors)) + 1;
        mk = markers{cc};
        cl = colors{cc};

        set(hTmp, 'Color', cl);

        % marker
        if mkSiz > 0
            set(hTmp, 'Marker', mk, 'MarkerSize', mkSiz, 'MarkerFaceColor', cl);

            if isMkEg
                set(hTmp, 'MarkerEdgeColor', 'k');
            end
        end
    end
end

% grid on;
% axis ij;
% axis equal;

% bound
setBound(X, 'mar', [.1 .1 .1]);
% if isempty(xLim)
%     xLim = [0, n + 1];
% end
% xlim(xLim);
% 
% if isempty(yLim)
%     ma = ma + .1 * gap;
%     if gap < 1e-3
%         ma = ma + 1;
%     end
%     yLim = [mi, ma];
% end
% ylim(yLim);
% 
% if isempty(zLim)
%     mi = min(X1); ma = max(X1); gap = ma - mi;
%     mi = mi - .1 * gap;
%     ma = ma + .1 * gap;
%     zLim = [mi, ma];
% end
% zlim(zLim);

