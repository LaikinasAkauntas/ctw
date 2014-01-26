% A demo comparison of different alignment methods on aligning three Weizmann video sequences with different features.
% This is the same function used for visualizing (Fig. 5) the second experiment (Sec 5.3) in the GTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(1);

%% src parameter
act = 'walk';
feats = {'XB', 'XE', 'XP'}; % features: bindary, Euclidean distance transform, Possion equation
m = 3; % #sequences
nRep = 10; % 10 random repetitions

%% algorithm parameter
parDtw = [];
parPimw = st('lA', 1, 'lB', 1); % IMW: regularization weight
parCca = st('d', 3, 'lams', .1); % CCA: reduce dimension to keep at least 0.95 energy
parPctw = [];
parGN = st('nItMa', 2, 'inp', 'linear'); % Gauss-Newton: 2 iterations to update the weight in GTW, 
parGtw = st('nItMa', 20);

%% subjects
wsSub = weiAliSub(act, m, nRep, 'svL', 2);
subIdxs = stFld(wsSub, 'subIdxs');
subIdx = subIdxs{1};

%% src
wsSrc = weiAliSrc(act, subIdx, 'y', 'svL', 2);

%% data
wsData = weiAliData(wsSrc, 'svL', 2);
X0s = weiAliDataX(wsData, feats, st('d', .999));
Xs = pcas(X0s, st('d', min(cellDim(X0s, 1)), 'cat', 'n'));
XTs = pcas(wsData.XCs, st('d', .9, 'cat', 'y')); % sequences in same feature, used for computing the approximated ground-truth

%% monotonic basis
ns = cellDim(Xs, 2);
l = round(max(ns) * 1.1);
bas = baTems(l, ns, 'pol', [5 .5], 'tan', [5 1 1]); % 2 polynomial and 3 tangent functions

%% utw (initialization)
aliUtw = utw(Xs, bas, []);

%% truth (approximated by DTW on aligning sequences with the same feature)
aliT = pdtw(XTs, aliUtw, [], parDtw); 
aliT.alg = 'truth';

%% pdtw
aliPdtw = pdtw(Xs, aliUtw, aliT, parDtw);

%% pddtw
aliPddtw = pddtw(Xs, aliUtw, aliT, parDtw);

%% pimw
aliPimw = pimw(Xs, aliUtw, aliT, parPimw, parDtw);

%% pctw
aliPctw = pctw(Xs, aliUtw, aliT, parPctw, parCca, parDtw);

%% gtw
aliGtw = gtw(Xs, bas, aliUtw, aliT, parGtw, parCca, parGN);

%% show result
shAliCmp(Xs, Xs, {aliPdtw, aliPddtw, aliPimw, aliPctw, aliGtw}, aliT, parCca, parDtw, parGN, 1);

%% show basis
rows = 1; cols = 1;
Ax = iniAx(4, rows, cols, [270 * rows, 270 * cols], 'wGap', .3, 'hGap', .3);
[mks, cls] = genMkCl;
shAliP(bas{1}.P, 'ax', Ax{1}, 'lnWid', 1, 'mkSiz', 0, 'cl', cls, 'G', eye(size(bas{1}.P, 2)));
set(gca, 'XTick', [], 'YTick', []);
title('bases used by GTW');

%% show key-frame - feature
idx = round(linspace(1, l, 7));
shWeiAli(wsSrc, wsData, aliGtw.P(idx, :), feats, 10);

%% show key-frame - image
feats = {'img', 'img', 'img'};
shWeiAli(wsSrc, wsData, aliGtw.P(idx, :), feats, 11);
