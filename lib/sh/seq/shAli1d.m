function shAli1d(Xs, C, varargin)
% Show alignment of two 1-D sequences.
%
% Input
%   Xs       -  sequence set, 1 x m (cell), 1 x ni
%   C        -  correspondence matrix, 2 x m
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
leg = ps(varargin, 'leg', []);
vGap = ps(varargin, 'vGap', 1);
cs = ps(varargin, 'cs', [1 2]);

X1 = Xs{1};
X2 = Xs{2};

n1 = length(X1);
n2 = length(X2);
X1 = X1 + max(X2) + vGap;

% add one dimension
X1 = [1 : n1; X1];
X2 = [1 : n2; X2];
Xs = {X1, X2};

hold on;

% alignment
nC = size(C, 2);
for iC = 1 : nC
    i = C(1, iC);
    j = C(2, iC);
    line([X1(1, i), X2(1, j)], [X1(2, i), X2(2, j)], 'Color', 'k', 'LineWidth', 1, 'LineStyle', '--');
end

% sequences
[markers, colors] = genMarkers;
for i = 1 : 2
    hTmp = plot(Xs{i}(1, :), Xs{i}(2, :), '-', 'LineWidth', lnWid);
    c = cs(i);
    
    % color
    if isempty(c) 
        set(hTmp, 'Color', colors{1});
    else
        set(hTmp, 'Color', colors{c});        
        
        % marker
        if mkSiz > 0
            set(hTmp, 'Marker', markers{c}, 'MarkerSize', mkSiz, 'MarkerFaceColor', colors{c});

            if isMkEg
                set(hTmp, 'MarkerEdgeColor', 'k');
            end
        end
    end
end

% % legend
% if ~isempty(leg)
%     legend(leg);
% end

% bound
maY = max(X1(2, :));
miY = min(X2(2, :));
miX = 1;
maX = max(n1, n2);
axis([miX - 1 maX + 1 miY - 1 maY + 1]);
