function wsMask = kitVdoMask(src, wsBk, par, varargin)
% Obtain mask data of Weizmann sequence.
%
% Input
%   src     -  Weizmann source
%   varargin
%     save option
%
% Output
%   wsMask
%     Ln0s  -  mask points (original), 1 x nF (cell)
%     Lns   -  mask points (normalized), 1 x nF (cell)
%     siz   -  mask size (normalized), 1 x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'subx', 'mask', ...
                             'fold', 'kit/vdo', ...
                             'prex', src.nm);

% load
if svL == 2 && exist(path, 'file')
    prom('m', 'old kit mask: %s\n', src.nm);
    wsMask = matFld(path, 'wsMask');
    return;
end
prom('m', 'new kit mask: %s\n', src.nm);

% mask parameter
th = ps(par, 'th', .7);

% bk
[Me, Var] = stFld(wsBk, 'Me', 'Var');

% path
[~, ~, avipath] = kitPaths(src);

% open avi
hr = vReader(avipath, 'cl', 'gray', 'comp', 'img', 'form', 'double');
nF = ps(varargin, 'nF', hr.nF);

% read each frame
[Ln0s, Lns] = cellss(1, nF);
se = strel('disk', 3, 4);
for iF = 1 : nF
    promCo('t', iF, nF, .001);

    F = vRead(hr, iF);

    % threshold
    M0 = exp(-(F - Me) .^ 2 ./ Var) > th;
    Ln0s{iF} = maskM2L(M0);

    % morphological operation
    M = imerode(M0, se);
    M = imdilate(M, se);
    Lns{iF} = maskM2L(M);
end

% store
wsMask.Ln0s = Ln0s;
wsMask.Lns = Lns;

% save
if svL > 0
    save(path, 'wsMask');
end
