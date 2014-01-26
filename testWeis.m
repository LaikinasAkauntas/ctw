% Testing the performance of temporal alignment on the Weizmann dataset.
% This is the same function used for reporting (Fig. 5h) the second experiment (Sec 5.3) in the GTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(2);

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

%% test
wsRun = weiAliRuns(act, wsSub, feats, parCca, parDtw, parPimw, parPctw, parGN, parGtw, 'svL', 2);
Dif = wsRun.Dif;

%% print error
mes = mean(Dif, 2);
fprintf('Average error:\n');
fprintf('pDTW  %.2f\n', mes(1));
fprintf('pDDTW %.2f\n', mes(2));
fprintf('pIMW  %.2f\n', mes(3));
fprintf('pCTW  %.2f\n', mes(4));
fprintf('GTW   %.2f\n', mes(5));

%% show error
devs = std(Dif, 0, 2);
algs = {'pDTW', 'pDDTW', 'pIMW', 'pCTW', 'GTW'};

rows = 1; cols = 2;
Ax = iniAx(1, rows, cols, [200 * rows, 200 * cols]);
shHst(mes, devs, 'ax', Ax{1}, 'leg', algs);
set(Ax{1}, 'ytick', 0 : 5);
set(Ax{2}, 'visible', 'off');
