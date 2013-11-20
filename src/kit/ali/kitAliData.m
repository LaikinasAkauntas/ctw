function wsData = kitAliData(wsSrc, varargin)
% Obtain kitchen data for alignment.
%
% Input
%   wsSrc   -  moc src
%   varargin
%     save option
%
% Output
%   wsData
%     pFss  -  frame index, 1 x m (cell), 1 x nF
%     Xs    -  feature matrix, 1 x m (cell), dim x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% save option
prex = wsSrc.prex;
[svL, path] = psSv(varargin, 'prex', prex, ...
                             'subx', 'data', ...
                             'fold', 'kit/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('kitAliData', 'old, %s', prex);
    wsData = matFld(path, 'wsData');
    return;
end
prIn('kitAliData', 'new, %s', prex);

% src
[srcs, parFs, rans] = stFld(wsSrc, 'srcs', 'parFs', 'rans');
m = length(srcs);

% data
[XQs, XPs, pFss] = cellss(1, m);
for i = 1 : m
    % feat
    wsMoc = kitMocOld(srcs{i}, 'svL', 2);
    wsFeat = kitMocFeat(srcs{i}, wsMoc, parFs{i}, 'svL', 2);
    XQ0 = wsFeat.XQ;
    XP0 = wsFeat.XP;

    % range
    if ~isempty(rans) && ~isempty(rans{i})
        ran = rans{i};
    else
        ran = [1 size(XQ0, 2)];
    end
    pFss{i} = ran(1) : ran(2);

    XQs{i} = XQ0(:, pFss{i});
    XPs{i} = XP0(:, pFss{i});
end

% store
wsData.pFss = pFss;
wsData.XQs = XQs;
wsData.XPs = XPs;

% save
if svL > 0
    save(path, 'wsData');
end

prOut;
