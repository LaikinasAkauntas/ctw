% Test alignment methods on aligning two synthetic sequences 100 times.
% This is a similar function used for reporting (Fig. 3h) the first experiment (Sec 5.1) in the CTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(2);

%% src parameter
tag = 3; 
nRep = 100; % 100 random repetitions

%% algorithm parameter
parDtw = [];
parImw = st('lA', 1, 'lB', 1); % IMW: regularization weight
parCca = st('d', .95); % CCA: reduce dimension to keep at least 0.95 energy
parCtw = [];
parGN = st('nItMa', 2, 'inp', 'linear'); % Gauss-Newton: 2 iterations to update the weight in GTW, 
parGtw = [];

%% run
wsRun = toyAliRun(tag, nRep, parDtw, parImw, parCtw, parCca, parGN, parGtw);
Dif = stFld(wsRun, 'Dif');

%% print err
mes = mean(Dif, 2);
fprintf('Average error:\n');
fprintf('DTW  %.2f\n', mes(1));
fprintf('DDTW %.2f\n', mes(2));
fprintf('IMW  %.2f\n', mes(3));
fprintf('CTW  %.2f\n', mes(4));
fprintf('GTW  %.2f\n', mes(5));

%% show err
devs = std(Dif, 0, 2);
algs = {'DTW', 'DDTW', 'IMW', 'CTW', 'GTW'};

rows = 1; cols = 1;
Ax = iniAx(2, rows, cols, [200 * rows, 200 * cols]);
shHst(mes, devs, 'ax', Ax{1}, 'leg', algs, 'dev', 'y', 'bdWid', 0, 'devWid', .5);
set(Ax{1}, 'xtick', []);
