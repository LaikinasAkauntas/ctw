function wsData = cmuAliData(wsSrc, varargin)
% Obtain CMU mocap data for alignment.
%
% Input
%   wsSrc   -  moc src
%   varargin
%     save option
%
% Output
%   wsData
%     pFss  -  frame index, 1 x m (cell), 1 x nF
%     XQs   -  quaternion matrix, 1 x m (cell), dim x nF
%     XPs   -  position matrix, 1 x m (cell), dim x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-20-2013

% save option
prex = wsSrc.prex;
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'data', ...
                   'fold', 'cmu/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('cmuAliData', 'old, %s', prex);
    wsData = matFld(path, 'wsData');
    return;
end
prIn('cmuAliData', 'new, %s', prex);

% src
[srcs, parFs, rans] = stFld(wsSrc, 'srcs', 'parFs', 'rans');
m = length(srcs);

% data
[XQs, XPs, pFss, wsMocs] = cellss(1, m);
for i = 1 : m
    % feat
    wsMoc = cmuMoc(srcs{i}, 'svL', 2);
    wsFeat = cmuMocFeat(srcs{i}, wsMoc, parFs{i}, 'svL', 2);
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
    wsMocs{i} = wsMoc;
end

% store
wsData.pFss = pFss;
wsData.XQs = XQs;
wsData.XPs = XPs;
wsData.wsMocs = wsMocs;

% save
if svL > 0
    save(path, 'wsData');
end

prOut;
