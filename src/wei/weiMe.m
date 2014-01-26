function wsMe = weiMe(act, varargin)
% Obtain the mean shape for action of Weizmann sequence.
%
% Input
%   act     -  action
%   varargin
%     save option
%
% Output
%   wsMe
%     PtT   -  ground-truth mask, 3 x nPtT
%     Pts   -  mask that used for computing the mean shape, 1 x m (cell), 3 x nPt
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% save option
[svL, path] = psSv(varargin, 'fold', 'wei/me', ...
                             'prex', act, ...
                             'subx', 'me');

% load
if svL == 2 && exist(path, 'file')
    prIn('weiMe', 'old, %s', act);
    wsMe = matFld(path, 'wsMe');
    prOut;
    return;
end
prIn('weiMe', 'new, %s', act);

% list
List = weiList(act);
m = size(List, 1);

% original mask
WEI = weiHuman;

% pre-process
[srcs, Pts] = cellss(1, m);
for i = 1 : m
    srcs{i} = weiSrc(List{i, 1 : 2});
    nm = srcs{i}.nm;
    Pt0s = WEI.(nm).Pts;
    pos = WEI.(nm).pos;

    % boundary
    PtBs = maskBd(Pt0s, 'corner', []);

    % normalize
    PtNs = maskNorm(PtBs, 70);
    Pts{i} = PtNs{pos};
end
nPts = cellDim(Pts, 2);

% init
PtT = [Pts{1}([1 2], :); ones(1, nPts(1))];

% coordinate-descent
nItMa = 10;
PtTs = cell(1, nItMa);
for nIt = 1 : nItMa
    PtTs{nIt} = PtT;

    Sh = maskMatch(Pts, PtT, 'ran', [.5; .5]);

    % adjust
    Pt2s = cell(1, m);
    for i = 1 : m
        Pt2s{i} = [Pts{i}([1 2], :) + repmat(Sh(:, i), 1, nPts(i)); ones(1, nPts(i))];
    end
    Box = maskBox(Pt2s);
    box = boxBd(Box);
    siz = box(:, 2) - box(:, 1) + 1;
    MT = zeros(siz(1), siz(2));
    for i = 1 : m
        Pti = Pt2s{i} + repmat([-box(:, 1) + 1; 0], 1, nPts(i));
        Mi = maskP2M(siz, Pti);
        MT = MT + Mi;
    end
    MT = MT ./ m;
    PtT2 = maskM2P(MT);

    % stop condition
    if equal('PtT', PtT2, PtT, 'pr', 'n')
        break;
    end
    PtT = PtT2;
end
PtTs(nIt + 1 : end) = [];

% store
wsMe.PtTs = PtTs;
wsMe.PtT = PtTs{end};
wsMe.Pts = Pts;

% save
if svL > 0
    save(path, 'wsMe');
end

prOut;
