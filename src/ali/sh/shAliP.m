function shAliP(P, varargin)
% Show warping paths in 2-D figure.
%
% Input
%   P        -  warping path vectors, l x m
%   varargin
%     show option
%     nor    -  normalization flag, 'y' | {'n'}
%     lnWid  -  line width, {1}
%     n      -  maximum value in y axis
%     algs   -  algorithm name (used for legend), {[]}
%     cls    -  colors, {[]}
%     eq     -  axis equal flag, 'y' | {'n'}
%     G      -  label, {[]}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-08-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-26-2013

% show option
psSh(varargin);

% function option
isNor = psY(varargin, 'nor', 'n');
G = ps(varargin, 'G', []);
ln = ps(varargin, 'ln', {'-'});
cl = ps(varargin, 'cl', {'r'});
lnWid = ps(varargin, 'lnWid', 1);
nMi = ps(varargin, 'nMi', 1);
n = ps(varargin, 'n', []);
isEq = psY(varargin, 'eq', 'n');
isSq = psY(varargin, 'sq', 'n');
algs = ps(varargin, 'algs', []);

% dimension
[t, m] = size(P);

% normalization
if isNor
    ma = max(P(end, :));
    for i = 1 : size(P, 2)
        P(:, i) = P(:, i) / P(end, i) * ma;
    end
end

% label
if isempty(G)
    G = ones(1, m);
end
k = size(G, 1);

% marker & color
if length(lnWid) == 1
    lnWid = zeros(1, k) + lnWid;
end
if length(ln) == 1
    ln = cellRep(ln{1}, k);
end
if length(cl) == 1
    cl = cellRep(cl{1}, k);
end

% main plot
hold on;
hPs = cell(1, k);
x = [1 : t, nan];
for c = 1 : k
    vis = G(c, :) == 1;
    mc = length(find(vis));
    
    Pc = [P(:, vis); nan(1, mc)];
    Xc = repmat(x', 1, mc);
    
    hPs{c} = plot(Xc(:), Pc(:), ln{c}, 'Color', cl{c}, 'LineWidth', lnWid(c));
end

% axis
if isEq
    axis equal;
end
if isSq
    axis square;
end

if isempty(n)
    n = max(P(end, :));
end
axis([1, t, nMi, n]);

% legend
if ~isempty(algs)
    legend(algs{:});
end
