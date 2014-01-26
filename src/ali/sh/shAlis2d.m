function shAlis2d(alis, varargin)
% Show warping paths in 2-D figure.
%
% Input
%   alis    -  alignment set, 1 x m (cell)
%   varargin
%     show option
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-06-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% show option
psSh(varargin);

% function option
ang = ps(varargin, 'ang', [-20 20]);
legs = ps(varargin, 'legs', {});

% dimension
m = length(alis);

% markers
parMk = st('lns', {'-', ':', ':', '-.', '--', '-'}, ...
           'cls', {'k', 'm', 'b',  'c', 'b', 'r'}, ...
           'mkSiz', 0, ...
           'lnWid', 1);

Ps = cellFld(alis, 'cell', 'P');
Ps = cellTra(Ps);
Ps = pcas(Ps, st('d', 3));
lnWids = ps(varargin, 'lnWids', [2 1 1 1 1 1 1 1]);
cls = ps(varargin, 'cls', []);
lns = ps(varargin, 'lns', []);
if ~isempty(cls)
    parMk.cls = cls;
end
if ~isempty(lns)
    parMk.lns = lns;
end

hold on;
for i = 1 : m
    Ps{i} = Ps{i}([2, 1], :);
    plotmk(Ps{i}, i, stAdd(parMk, 'lnWid', lnWids(i)));
end

% boundary
parAx = st('mar', 0, 'ij', 'y', 'eq', 'n', 'sq', 'y', 'ang', ang);
box = xBox(cat(2, Ps{:}), parAx);
setAx(box, parAx);

% xlabel('x'); ylabel('y'); zlabel('z');

% legend
if ~isempty(legs)
    legend(legs{:});
end

