function wsMask = weiAliMask(srcs, varargin)
% Obtain mask data of Weizmann sequence.
%
% Input
%   src      -  Weizmann source, 1 x m (cell)
%   varargin
%     save option
%
% Output
%   wsMask
%     Pt0ss  -  mask points (original), 1 x m (cell), 1 x nFi (cell)
%     Ptss   -  mask points (normalized), 1 x m (cell), 1 x nFi (cell)
%     siz    -  mask size (normalized), 1 x 2
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'subx', 'mask', ...
                             'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    prom('m', 'old wei ali mask\n');
    wsMask = matFld(path, 'wsMask');
    return;
end
prom('m', 'new wei ali mask\n');

m = length(srcs);
[Pt0ss, PtNss] = cellss(1, m);

for i = 1 : m
    % src
    Pt0ss{i} = srcs{i}.Pts;

    % direction
    flip = select(srcs{i}.dire == 'l', 'y', 'n');

    % bounded
    PtBs = maskBd(Pt0ss{i}, 'flip', flip, 'bd', 'corner');

    % normalize the height
    PtNss{i} = maskNorm(PtBs);
end

% join all cell arrays
[PtNs, s] = cellCat(PtNss);

% match
PtNs = maskMatch(PtNs);
[Pts, Siz] = maskBd(PtNs, 'bd', 'none');

% divide
Ptss = cellDiv(Pts, s);

% store
wsMask.Pt0ss = Pt0ss;
wsMask.Ptss = Ptss;
wsMask.siz = Siz(:, 1)';

% save
if svL > 0
    save(path, 'wsMask');
end
