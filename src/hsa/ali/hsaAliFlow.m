function wsFeat = weiAliFeat(srcs, wsMask, varargin)
% Obtain the shape feature of Weizmann data.
%
% Input
%   src     -  Weizmann source
%   wsMask  -  mask data
%   varargin
%     save option
%
% Output
%   wsFeat
%     PtCs  -  contour points, 1 x nF (cell)
%     MBs   -  binary box, 1 x nF (cell)
%     MEs   -  Euclidean distance transform, 1 x nF (cell)
%     MPs   -  Possion distance transform, 1 x nF (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'subx', 'feat', ...
                             'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    prom('m', 'old wei ali feat\n');
    wsFeat = matFld(path, 'wsFeat');
    return;
end
prom('m', 'new wei ali feat\n');

m = length(srcs);

% mask
[Ptss, siz] = stFld(wsMask, 'Ptss', 'siz');

% feat
[PtCss, MBss, MEss, MPss] = cellss(1, m);
for i = 1 : m
    [PtCss{i}, MBss{i}, MEss{i}, MPss{i}] = shpFeat(siz, Ptss{i});
end

% store
wsFeat.PtCss = PtCss;
wsFeat.MBss = MBss;
wsFeat.MEss = MEss;
wsFeat.MPss = MPss;

% save
if svL > 0
    save(path, 'wsFeat');
end
