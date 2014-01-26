function wsSrc = toyAliSrc(tag, l, m, varargin)
% Generate toy sequence for alignment.
%
% Input
%   tag     -  shape of latent sequence, 1 | 2 | 3 | 4
%              1: sin
%              2: circle
%              3: spiral
%              4: random curve
%     l     -  #frame in latent sequence, 100 | 200 | ...
%     m     -  #sequence, 2 | 3 | ...
%   varargin
%     save option
%
% Output
%   wsSrc
%     X0    -  latent sequence, 2 x t
%     XTs   -  sequences after temporal transformation, 1 x m (cell)
%     XGs   -  sequences after global spatial transformation, 1 x m (cell)
%     XLs   -  sequences after local  spatial transformation, 1 x m (cell)
%     XGNs  -  sequences after global spatial transformation + noise in 3rd dimension, 1 x m (cell)
%     XLNs  -  sequences after local  spatial transformation + noise in 3rd dimension, 1 x m (cell)
%     aliT  -  ground truth alignment
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-17-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2013

% save option
prex = cellStr(tag, l, m);
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'src', ...
                   'fold', 'toy/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('toyAliSrc', 'old, %s', prex);
    wsSrc = matFld(path, 'wsSrc');
    return;
end
prIn('toyAliSrc', 'new, tag %d, l %d, m %d', tag, l, m);

% latent sequence
X0 = toyLatSeq(tag, l);

% generate temporal transformation
parTs = tranTemLnPar(l, m);
Qs = cell(1, m);
for i = 1 : m
    Qs{i} = tranTemLn(parTs{i}.ts, parTs{i}.ns);
end

% generate spatial transformation (affine)
parSGs = tranSpaAffPar(m);
[PGs, muGs] = cellss(1, m);
for i = 1 : m
    [PGs{i}, muGs{i}] = tranSpaAffG(l, parSGs{i}, [min(X0, [], 2), max(X0, [], 2)]);
end

% apply transformation
[XTs, XSs, XSTs, Xs] = cellss(1, m);
for i = 1 : m
    XTs{i} = X0(:, Qs{i});
    XSs{i} = PGs{i} * (X0 + repmat(muGs{i}, 1, l));
    xN = randn(1, size(XTs{i}, 2)) * 2;
    XSTs{i} = XSs{i}(:, Qs{i});
    Xs{i} = [XSTs{i}; xN];
end

% ground-truth
P = aliInv(Qs);
Vs = mcca(XSs, st('d', 2, 'lams', 0, 'homo', 'n'));
for i = 1 : m
    Vs{i} = [Vs{i}(1 : 2, :); zeros(1, 3); Vs{i}(3, :)];
end
aliT.alg = 'truth';
aliT.P = P;
aliT.Vs = Vs;

% store
wsSrc.prex = prex;
wsSrc.X0 = X0;
wsSrc.parTs = parTs;
wsSrc.Qs = Qs;
wsSrc.parSGs = parSGs;
wsSrc.PGs = PGs;
wsSrc.muGs = muGs;
wsSrc.XTs = XTs;
wsSrc.XSs = XSs;
wsSrc.XSTs = XSTs;
wsSrc.Xs = Xs;
wsSrc.aliT = aliT;

% save
if svL > 0
    save(path, 'wsSrc');
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pars = tranTemLnPar(t, m)
% Generate hyper-parameter for temporal transformation.
%
% Input
%   t     -  #samples
%   m     -  #sequences
%
% Output
%   pars  -  parameter, 1 x m (cell)

% hyT1.Ran = [.1  .5; ...
%             .3  .6];
% hyT1.lens = [.1 .2];
% hyT1.wins = [.1 .1];
% 
% hyT2.Ran = [.25  .4; ...
%             .3  .6];
% hyT2.lens = [.1 .05];
% hyT2.wins = [.07 .07];

nSeg = 5;
div = 'eq';
ranL = [.3, .9]; % easy
                 %nSeg = 4; ranL = [.1, .9];

pars = cell(1, m);
for i = 1 : m
    % segment position
    ts = divN(t, nSeg, 'alg', div);

    % segment length after rescaling
    rates = (rand(nSeg, 1) * (ranL(2) - ranL(1)) + ranL(1));
    ns = round(ts .* rates);

    pars{i}.ts = ts;
    pars{i}.ns = ns;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pars = tranSpaAffPar(m)
% Generate hyper-parameter for spatial transformation (global).
%
% Input
%   m     -  #sequences
%
% Output
%   pars  -  parameter, 1 x m (cell)

par1.bases = {[], [], [], [], []};
par1.Mes   = {[], [], [], [], []};
par1.Vars  = {[], [], [], [], []};
par1.weis  = { 1,  1,  1,  1,  1};

par2.bases = {[], [], [], [], []};
par2.Mes   = {[], [], [], [], []};
par2.Vars  = {[], [], [], [], []};
par2.weis  = { 1,  1,  1,  1,  1};

pars = cell(1, m);
for i = 1 : m
    if mod(i, 2) == 1
        pars{i} = par1;
    else
        pars{i} = par2;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%
function hySLs = genHySL
% Generate hyper-parameter for spatial transformation (local).

hySL1.bases = {      120,                 1,                 1,     0,     0};
hySL1.Mes   = {    [.25],   [.2 .55 .8 .95],    [.25 .5 .6 .8], [.25], [.25]};
hySL1.Vars  = {    [.01], [.01 .01 .01 .01], [.05 .01 .01 .01], [.05], [.05]};
hySL1.weis  = {        1,                 1,                 1,     1,     1};

hySL2.bases = {        0,         1,         1,        [],        []};
hySL2.Mes   = {[.25 .4 ], [.25 .7 ], [.25 .7 ], [.25 .6 ], [.25 .6 ]};
hySL2.Vars  = {[.05 .01], [.05 .05], [.05 .05], [.05 .05], [.05 .05]};
hySL2.weis  = {        1,         1,         1,         1,         1};

hySLs = {hySL1, hySL2};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hySG1, hySG2, hySL1, hySL2] = genTranS2
% Generate hyper-parameter for spatial transformation.

Para = [nan,   0,  10; ...
        nan,   1,   1; ...
        nan,  .2,   1; ...
          0,   0,   0; ...
          0,   0,   0];
mes  = [  0,   0,   0];
vars = [inf, inf, inf];
weis = [  1,   1,   1];

idx = 1;
hySG1.Para = Para(:, idx);
hySG1.mes  = mes(idx);
hySG1.vars = vars(idx);
hySG1.weis = weis(idx);

idx = [];
hySG2.Para = Para(:, idx);
hySG2.mes  = mes(idx);
hySG2.vars = vars(idx);
hySG2.weis = weis(idx);
