% Testing the performance of temporal alignment on the toy dataset.
% This is the same function used for reporting (Fig. 4g) the first experiment (Sec 5.2) in the GTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(2);

%% src parameter
tag = 3;
nRep = 100;

%% algorithm parameter
inp = 'linear'; qp = 'matlab'; dp = 'c';
parCca = st('d', .95, 'lams', 0);
parDtw = st('nItMa', 50, 'th', 0);
parPimw = st('nItMa', 50, 'th', 0, 'lA', 1, 'lB', 1);
parPctw = st('nItMa', 50, 'th', 0);
parGN = st('nItMa', 2, 'th', 0, 'lam', 0, 'qp', qp, 'inp', inp);
parGtw = st('nItMa', 50, 'th', 0);

%% run
wsRun = toyAliRuns(tag, nRep, parDtw, parPimw, parGN, parGtw, parCca, 'svL', 2);
Dif = stFld(wsRun, 'Dif');

%% print err
mes = mean(Dif, 2);
fprintf('Average error:\n');
fprintf('pDTW  %.2f\n', mes(1));
fprintf('pDDTW %.2f\n', mes(2));
fprintf('pIMW  %.2f\n', mes(3));
fprintf('pCTW  %.2f\n', mes(4));
fprintf('GTW   %.2f\n', mes(5));

%% show err
devs = std(Dif, 0, 2);
algs = {'pDTW', 'pDDTW', 'pIMW', 'pCTW', 'GTW'};

rows = 1; cols = 2;
Ax = iniAx(1, rows, cols, [200 * rows, 200 * cols]);
shHst(mes, devs, 'ax', Ax{1}, 'leg', algs, 'dev', 'y', 'bdWid', 0, 'devWid', .5);

set(Ax{2}, 'visible', 'off');
