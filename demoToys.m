% A demo comparison of different alignment methods on aligning three synthetic sequences.
% This is the same function used for visualizing (Fig. 4) the first experiment (Sec 5.2) in the GTW paper.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-04-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

clear variables;
prSet(1);

%% src parameter
tag = 3; 
l = 300; % #samples in the latent sequence (Z)
m = 3;   % #sequences

%% algorithm parameter
parDtw = [];
parPimw = st('lA', 1, 'lB', 1); % IMW: regularization weight
parCca = st('d', .95); % CCA: reduce dimension to keep at least 0.95 energy
parPctw = [];
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

%% show alignment result
shAliCmp(Xs, Xs, {aliPdtw, aliPddtw, aliPimw, aliPctw, aliGtw}, aliT, parCca, parDtw, parGN, 1);

%% show basis
shAliP(bas{1}.P, 'fig', 2);
