function wsMask = weiMask(src, parF, varargin)
% Obtain mask data for Weizmann sequence.
%
% Input
%   src     -  wei src
%   parF    -  parameter
%     siz   -  destined mask size, {[70 35]}
%   varargin
%     save option
%
% Output
%   wsMask
%     prex  -  name
%     siz0  -  mask size (original), 1 x 2
%     siz   -  mask size (normalized), 1 x 2
%     Pt0s  -  mask points (original), 1 x nF (cell)
%     Pts   -  mask points (normalized), 1 x nF (cell)
%     PtCs  -  contour, 1 x nF (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% function parameter
siz = ps(parF, 'siz', [70, 35]);
% siz = ps(parF, 'siz', [12, 10] * 12);

% save option
prex = sprintf('%s_%d_%d', src.nm, siz(1), siz(2));
[svL, path] = psSv(varargin, 'subx', 'mask', ...
                             'fold', 'wei/mask', ...
                             'prex', prex);

% load
if svL == 2 && exist(path, 'file')
    prInOut('weiMask', 'old, %s', prex);
    wsMask = matFld(path, 'wsMask');
    return;
end
prIn('weiMask', 'new, %s', src.nm);

% original mask
WEI = weiHuman;
nm = src.nm;
Pt0s = WEI.(nm).Pts;

% video
wsVdo = weiVdo(src, 'svL', 2);
[Fs, nF] = stFld(wsVdo, 'Fs', 'nF');

% attach pixel value to point
Pt0s = maskPix(Pt0s, Fs);

% boundary of the bounding box
[PtBs, ~, Bd] = maskBd(Pt0s, 'corner', []);
[Box0, Box] = zeross(2, 2, nF);
for iF = 1 : nF
    Box0(:, 1, iF) = Bd(:, iF);
end

% normalize the height
[PtNs, sca] = maskNorm(PtBs, siz(1));
for iF = 1 : nF
    Box(:, 1, iF) = round(Box0(:, 1, iF) / sca);
end

% match
wsMe = weiMe(src.trlNm, 'svL', 2);
PtT = wsMe.PtT;
Sh = maskMatch(PtNs, PtT);

% adjust
nPts = cellDim(PtNs, 2);
PtN2s = cell(1, nF);
for iF = 1 : nF
    PtN2s{iF} = PtNs{iF};
    PtN2s{iF}([1 2], :) = PtNs{iF}([1 2], :) + repmat(Sh(:, iF), 1, nPts(iF));

    Box0(:, 1, iF) = Box0(:, 1, iF) - round(Sh(:, iF) * sca);
    Box(:, 1, iF) = Box(:, 1, iF) - Sh(:, iF);
end

% bound
[Pts, Siz, Bd] = maskBd(PtN2s, 'center', siz);
for iF = 1 : nF
    Box0(:, 1, iF) = Box0(:, 1, iF) + round(Bd(:, iF) * sca) + 1;
    Box0(:, 2, iF) = Box0(:, 1, iF) + round(Siz(:, iF) * sca) - 1;

    Box(:, 1, iF) = Box(:, 1, iF) + Bd(:, iF) + 1;
    Box(:, 2, iF) = Box(:, 1, iF) + Siz(:, iF) - 1;
end
% Box0 = round(Box * sca);

% distance transform
[PtC0s, MBs, MEs, MPs] = shpDst(siz, Pts);

% shape context
[Ctxs, PtCs] = shpCtxs(PtC0s, parF);
[XC, Idx] = ctx2hst(Ctxs, parF);

% store
wsMask.prex = prex;
wsMask.sca = sca;
wsMask.siz = siz;
wsMask.Pt0s = Pt0s;
wsMask.Pts = Pts;
wsMask.Box0 = Box0;
wsMask.Box = Box;
wsMask.PtC0s = PtC0s;
wsMask.MBs = MBs;
wsMask.MEs = MEs;
wsMask.MPs = MPs;
wsMask.PtCs = PtCs;
wsMask.Ctxs = Ctxs;
wsMask.XC = XC;
wsMask.Idx = Idx;

% save
if svL > 0
    save(path, 'wsMask');
end

prOut;
