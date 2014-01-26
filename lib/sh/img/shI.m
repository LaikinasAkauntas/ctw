function shI(I, varargin)
% Show spatio segments.
%
% Input
%   I       -  indicator matrix, k x n
%   varargin
%     show option
%     mkEg  -  flag of marker edge, {'y'} | 'n'
%     mkSiz   -  size of markers, {5}
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-19-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parse show option
psShow(varargin);
isMkEg = psY(varargin, 'mkEg', 'y');
mkSiz = ps(varargin, 'mkSiz', 5);

% markers
[markers, colors] = genMarkers;

hold on;
[k, n] = size(I);
for c = 1 : k
    x = find(I(c, :));
    y = ones(size(x)) * c;
    
    hTmp = plot(x, y, ...
         markers{c}, 'MarkerSize', mkSiz, 'MarkerFaceColor',... 
         colors{c}, 'Color', colors{c});
    % marker
    if isMkEg
        set(hTmp, 'MarkerEdgeColor', 'k');
    end
end

% set boundary
xlim([0 n + 1]);
ylim([0 k + 1]);
