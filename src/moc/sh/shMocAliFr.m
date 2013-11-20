function shMocAliFr(wsSrc, wsData, ali, l, Ax, varargin)
% Show data as points with different labels for different classes in 2-D figure.
%
% Input
%   wsSrc    -  moc src
%   ali      -  alignment
%   l        -  #number of steps
%   Ax       -  axes set, 1 x m (cell)
%   varargin
%     vwAgl  -  view angle, {[10 20]}
%     all    -  flag of plotting all frames, 'y' | {'n'}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 04-27-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% function option
vwAgl = ps(varargin, 'vwAgl', [10 20]);

% src
srcs = stFld(wsSrc, 'srcs');
m = length(srcs);

% data
pFss = stFld(wsData, 'pFss');
nFs = cellDim(pFss, 2);

% mocap
wsMocs = cellss(1, m);
for i = 1 : m
%    wsMocs{i} = cmuMoc(srcs{i}, 'svL', 2);
    wsMocs{i} = kitMocOld(srcs{i}, 'svL', 2);
    wsMocs{i}.cord = wsMocs{i}.cord(:, :, pFss{i});
end

% warping
P = ali.P;
Ran = [ones(1, m); nFs];
Ps = pAll(P, Ran, l);
for i = 1 : m
    wsMocs{i}.cord = wsMocs{i}.cord(:, :, round(Ps{i}));
end

% mocap
[skels, cords, conns] = cellss(1, m);
for i = 1 : m
    [skels{i}, cords{i}, conns{i}] = stFld(wsMocs{i}, 'skel', 'cord', 'conn');
end

% main plot
for i = 1 : m
    for iF = 1 : l
        [~, cl] = genMkCl(i);
        shMocG(cords{i}, 'ax', Ax{i, iF});
        shMocF(cords{i}(:, :, iF), conns{i}, skels{i}, 'cl', cl);
        view(vwAgl);
    end
end
