function wsFeat = weiFeat(src, wsMask, wsFlow, parShp, varargin)
% Obtain the feature of Weizmann sequence.
%
% Input
%   src     -  wei src
%   wsMask  -  mask data
%   wsFlow  -  flow data
%   parShp  -  parameter for shape-related feature
%   varargin
%     save option
%
% Output
%   wsFeat
%     PtCs  -  contour points, 1 x nF (cell)
%     MBs   -  binary box, 1 x nF (cell)
%     MEs   -  Euclidean distance transform, 1 x nF (cell)
%     MPs   -  Possion distance transform, 1 x nF (cell)
%     Ctxs  -  histogram of shape context, nBin x nBd x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'fold', 'wei/feat', ...
                             'prex', src.nm, ...
                             'subx', 'feat');

% load
if svL == 2 && exist(path, 'file')
    prInOut('weiFeat', 'old, %s', src.nm);
    wsFeat = matFld(path, 'wsFeat');
    return;
end
prIn('weiFeat', 'new, %s', src.nm);

% mask
[siz, Pts] = stFld(wsMask, 'siz', 'Pts');

% shape
[PtCs, MBs, MEs, MPs] = shpFeat(siz, Pts, parShp);

% flow

% store
wsFeat.PtCs = PtCs;
wsFeat.MBs = MBs;
wsFeat.MEs = MEs;
wsFeat.MPs = MPs;

% save
if svL > 0
    save(path, 'wsFeat');
end

prOut;
