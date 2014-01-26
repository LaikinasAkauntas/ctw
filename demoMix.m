% A demo of using GTW on aligning three multi-modal sequences (Mocap, video, and Accelerator)
% This is the same function used for visualizing (Fig. 6) the third experiment (Sec 5.4) in the GTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(1);

%% src parameter
acts = {'jack', 'jack', 'wave'};
rann = 'y';
subIdxs = {2, 2, 2}; 
m = 3; % #sequences

%% algorithm parameter
featss = {{'XQ'}, {'XB'}, {'XA'}}; 
feats = {'XQ', 'XE', 'img'};
parCca = st('d', 3, 'lams', 0);
parPdtw = [];
parPimw = st('lA', 1, 'lB', 1);
parGN = st('nItMa', 2, 'inp', 'linear');
parGtw = st('nItMa', 20, 'debg', 'n');

%% CMU mocap
i = 1;
wsSrcCmu = cmuAliSrc(acts{i}, subIdxs{i}, rann, 'svL', 2);
wsDataCmu = cmuAliData(wsSrcCmu, 'svL', 2);
XCmus = cmuAliDataX(wsDataCmu, featss{i}, st('d', .95));

%% Weizmann action
i = 2;
wsSrcWei = weiAliSrc(acts{i}, subIdxs{i}, rann, 'svL', 2);
wsDataWei = weiAliData(wsSrcWei, 'svL', 2);
XWeis = weiAliDataX(wsDataWei, featss{i}, st('d', .95));

%% Accelerator
i = 3;
wsSrcHsa = hsaAliSrc(acts{i}, subIdxs{i}, rann, 'svL', 2);
wsDataHsa = hsaAliData(wsSrcHsa, 'svL', 2);
XHsas = hsaAliDataX(wsDataHsa, featss{i}, []);

%% feature
X0s = {XCmus{1}, XWeis{1}, XHsas{1}};
Xs = pcas(X0s, st('d', 3, 'cat', 'n')); % project all the three sequences to 3-D

%% monotonic basis
ns = cellDim(Xs, 2);
l = round(max(ns) * 1.1);
bas = baTems(l, ns, 'pol', [5 .5], 'tan', [5 1 1]); % 2 polynomial and 3 tangent functions

%% utw (initialization)
aliUtw = utw(Xs, bas, []);

%% gtw
aliGtw = gtw(X0s, bas, aliUtw, [], parGtw, parCca, parGN);

%% show sequence
shAliCmpOne(X0s, Xs, {aliGtw}, [], parCca, parGN);

%% show keyframe
wsSrcs = {wsSrcCmu, wsSrcWei, wsSrcHsa};
wsDatas = {wsDataCmu, wsDataWei, wsDataHsa};
idx = round(linspace(1, l, 9));
shMixFr(wsSrcs, wsDatas, feats, round(aliGtw.P(idx, :)), 'fig', 12);
