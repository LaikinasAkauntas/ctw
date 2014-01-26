% A demo comparison of different alignment methods on aligning two synthetic sequences.
% This is a similar function used for visualizing (Fig. 3) the first experiment (Sec 5.1) in the CTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(1);

%% src parameter
tag = 3; 
l = 300; % #frame of the latent sequence (Z)
m = 2;   % #sequences

%% algorithm parameter
parDtw = [];
parImw = st('lA', 1, 'lB', 1); % IMW: regularization weight
parCca = st('d', .95); % CCA: reduce dimension to keep at least 0.95 energy
parCtw = [];
parGN = st('nItMa', 2, 'inp', 'linear'); % Gauss-Newton: 2 iterations to update the weight in GTW, 
parGtw = [];

%% src
wsSrc = toyAliSrc(tag, l, m);
[Xs, aliT] = stFld(wsSrc, 'Xs', 'aliT');

%% monotonic basis
ns = cellDim(Xs, 2);
bas = baTems(l, ns, 'pol', [3 .4], 'tan', [3 .6 1]); % 2 polynomial and 3 tangent functions

%% utw (initialization)
aliUtw = utw(Xs, bas, aliT);

%% dtw
aliDtw = dtw(Xs, aliT, parDtw);

%% ddtw
aliDdtw = ddtw(Xs, aliT, parDtw);

%% imw
aliImw = pimw(Xs, aliUtw, aliT, parImw, parDtw);

%% ctw
aliCtw = ctw(Xs, aliUtw, aliT, parCtw, parCca, parDtw);

%% gtw
aliGtw = gtw(Xs, bas, aliUtw, aliT, parGtw, parCca, parGN);

%% show alignment result
shAliCmp(Xs, Xs, {aliDtw, aliDdtw, aliImw, aliCtw, aliGtw}, aliT, parCca, parDtw, parGN, 1);

%% show basis
shAliP(bas{1}.P, 'fig', 2);
