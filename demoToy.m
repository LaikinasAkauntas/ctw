% Demo for CTW on toy dataset.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

clear variables;
prSet(2);

%% src parameter
tag = 3; 
l = 200; 
m = 2;

%% algorithm parameter
parDtw = st('dp', 'c');
parCtw = st('th', 0, 'debg', 'y');
parCca = st('d', 2, 'lams', 0);

%% src
wsSrc = toyAliSrc(tag, l, m);
[Xs, aliT] = stFld(wsSrc, 'Xs', 'aliT');

%% utw (initialization)
aliUtw = utw(Xs, [], aliT);

%% ctw
aliCtw = ctw(Xs, aliUtw, aliT, parCtw, parCca, parDtw);

%% show result
rows = 1; cols = 2;
axs = iniAx(1, rows, cols, [250 * rows, 250 * cols]);

parMk = st('mkSiz', 2, 'lnWid', 1, 'ln', '-');
parAx = st('mar', .1, 'ang', [30 80], 'tick', 'n');

shs(Xs, parMk, parAx, 'ax', axs{1, 1});
title('Original');

Ys = gtwTra(homoX(Xs), aliCtw, parCca, parDtw);
YYs = homoX(Ys, 0);
shs(YYs, parMk, parAx, 'ax', axs{1, 2});
title('CTW');
