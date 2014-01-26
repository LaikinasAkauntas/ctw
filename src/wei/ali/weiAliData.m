function wsData = weiAliData(wsSrc, varargin)
% Obtain Weizmann data for alignment.
%
% Input
%   wsSrc   -  wei src
%   varargin
%     save option
%
% Output
%   wsData
%     pFss  -  frame index, 1 x m (cell), 1 x nF
%     XBs   -  binary mask, 1 x m (cell), dimB x nF
%     XEs   -  distance transform, 1 x m (cell), dimE x nF
%     XPs   -  Poisson equation, 1 x m (cell), dimP x nF
%     XCs   -  shape context, 1 x m (cell), dimE x nF
%     XVs   -  optical flow, 1 x m (cell), dimE x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% save option
prex = wsSrc.prex;
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'data', ...
                   'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    wsData = matFld(path, 'wsData');
    prInOut('weiAliData', 'old, %s', prex);
    return;
end
prIn('weiAliData', 'new, %s', prex);

% src
[srcs, parFs, rans] = stFld(wsSrc, 'srcs', 'parFs', 'rans');

% dimension
m = length(srcs);

% data
[XBs, XEs, XPs, PtC0ss, XVs, pFss] = cellss(1, m);
for i = 1 : m
    % mask
    wsMask = weiMask(srcs{i}, parFs{i}, 'svL', 2);
    [MBs, MEs, MPs, PtC0ss{i}] = stFld(wsMask, 'MBs', 'MEs', 'MPs', 'PtC0s');
    XBs{i} = mcat('horz', cellVec(MBs));
    XEs{i} = mcat('horz', cellVec(MEs));
    XPs{i} = mcat('horz', cellVec(MPs));

    % flow
%     wsFlow = weiFlow(srcs{i}, wsMask, parFs{i}, 'svL', 2, 'debg', 'n');
%     iH = 2;
%     VH = wsFlow.VHs{iH};
%     XVs{i} = reshape(VH, [], size(VH, 4));

    % sub-sequence
    if ~isempty(rans) && ~isempty(rans{i})
        ran = rans{i};
    else
        ran = [1 size(XEs{i}, 2)];
    end
    pFss{i} = ran(1) : ran(2);

    XBs{i} = XBs{i}(:, pFss{i});
    XEs{i} = XEs{i}(:, pFss{i});
    XPs{i} = XPs{i}(:, pFss{i});
%     XVs{i} = XVs{i}(:, pFss{i});
    PtC0ss{i} = PtC0ss{i}(pFss{i});
end

% shape context
[PtC0s, s] = cellCat(PtC0ss);
[PtCs, Ctxs] = shpCtxs(PtC0s, parFs{1});
[XC, Idx] = ctx2hst(Ctxs, parFs{1});
PtCss = cellDiv(PtCs, s);
Ctxss = cellDec(Ctxs, s);
XCs = cellDec(XC, s);
Idxs = cellDec(Idx, s);

% store
wsData.pFss = pFss;
wsData.XBs = XBs;
wsData.XEs = XEs;
wsData.XPs = XPs;
wsData.XVs = XVs;
wsData.PtCss = PtCss;
wsData.Ctxs = Ctxss;
wsData.XCs = XCs;
wsData.Idxs = Idxs;

% save
if svL > 0
    save(path, 'wsData');
end

prOut;
