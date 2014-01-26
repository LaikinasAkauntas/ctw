function wsData = hsaAliData(wsSrc, varargin)
% Obtain Humansensing Accelerometer data for alignment.
%
% Input
%   wsSrc   -  hsa src
%   varargin
%     save option
%
% Output
%   wsData
%     pFss  -  frame index, 1 x m (cell), 1 x nF
%     XEs   -  distance transform, 1 x m (cell), dimE x nF
%     XCs   -  shape context, 1 x m (cell), dimE x nF
%     XVs   -  optical flow, 1 x m (cell), dimE x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2013

% save option
prex = wsSrc.prex;
[svL, path] = psSv(varargin, 'prex', prex, ...
                             'subx', 'data', ...
                             'fold', 'hsa/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('old hsa ali data: %s', prex);
    wsData = matFld(path, 'wsData');
    return;
end
prIn('new hsa ali data: %s', prex);

% src
[srcs, parImgs, parMasks, parFlows, rans] = stFld(wsSrc, 'srcs', 'parImgs', 'parMasks', 'parFlows', 'rans');
m = length(srcs);

% data
[XAs, pFss] = cellss(1, m);
for i = 1 : m
    % mask
%     wsMask = hsaMask(srcs{i}, parMasks{i}, parImgs{i}, 'svL', 2);
%     [MEs, PtC0ss{i}] = stFld(wsMask, 'MEs', 'PtC0s');
%     XEs{i} = mcat('horz', cellVec(MEs));

    % init
%     wsInit = hsaInit(srcs{i}, parImgs{i}, 'svL', 2);

    % flow
%     wsFlow = hsaFlow(srcs{i}, wsInit, wsMask, parFlows{i}, parImgs{i}, 'svL', 2);

    % ace
    wsAce = hsaAce(srcs{i}, 'svL', 2);
    XAs{i} = stFld(wsAce, 'X');

    % range
    if ~isempty(rans) && ~isempty(rans{i})
        ran = rans{i};
    else
        ran = [1 size(XAs{i}, 2)];
    end
    pFss{i} = ran(1) : ran(2);

    XAs{i} = XAs{i}(:, pFss{i});
end

% store
wsData.pFss = pFss;
wsData.XAs = XAs;

% save
if svL > 0
    save(path, 'wsData');
end

prOut;
