function ali = pctw(Xs, ali0, aliT, parPctw, parCca, parDtw)
% Procrust Canonical Time Warping (pCTW).
%
% Reference
%   F. Zhou and F. De la Torre, 
%   "Generalized Time Warping for Multi-modal Alignment of Human Motion", 
%   in CVPR, 2012.
%
% Input
%   Xs       -  sequences, 1 x m (cell), di x ni
%   ali0     -  initial alignment
%   aliT     -  ground-truth alignment (can be [])
%   parPctw  -  parameter for pCtw
%     th     -  stop threshold, {0}
%     nItMa  -  maximum iteration number, {50}
%     debg   -  debug flag, 'y' | {'n'}
%     fig    -  figure used for debugging, {11}
%   parCca   -  parameter for CCA. See function cca for more details
%   parDtw   -  parameter for DTW. See function dtw for more details
%
% Output
%   ali      -  alignment
%     objs   -  objective value, 1 x nIt
%     its    -  iteration step ids, 1 x nIt
%     P      -  warping path, l x m
%     Vs     -  transformation, 1 x m (cell), di x b
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-20-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-23-2013

% function parameter
th = ps(parPctw, 'th', 0);
nItMa = ps(parPctw, 'nItMa', 50);
isDebg = psY(parPctw, 'debg', 'n');
fig = ps(parPctw, 'fig', 11);

% dimension
m = length(Xs);
dims = cellDim(Xs, 1);
dimsStr = vec2str(dims, '%d', 'delim', ' ');
ns = cellDim(Xs, 2);
nsStr = vec2str(ns, '%d', 'delim', ' ');
prIn('pctw', 'dims %s, ns %s', dimsStr, nsStr);

% homogeneous coordinate
Xs = homoX(Xs);

% debug
if isDebg
    Ax1 = iniAx(fig, 2, 5, [250 * 4, 250 * 5], 'pos', [0 .5 1 .5]);
    Ax2 = iniAx(0, 2, m, [], 'pos', [0 0 1 .5]);
else
    Ax1 = [];
    Ax2 = [];
end

% initial alignment
ali0.P = round(ali0.P);
ali = ali0;

% coordinate-descent
[objs, its] = zeross(1, nItMa);
prCIn('EM', nItMa, .1);
for nIt = 1 : 2 : nItMa
    prC(nIt);

    % spatial transformation
    Ys = seqInp(Xs, ali0.P, parDtw);
    ali.Vs = mcca(Ys, parCca);

    objs(nIt) = gtwObj(Xs, ali, parCca, parDtw);
    its(nIt) = a2it('spa');
    if nIt == 1
        parCca.d = size(ali.Vs{1}, 2) - 1;
    end
    
    % debug
    if isDebg
        debg(Ax1, Ax2, nIt, objs, its, Xs, aliT, ali, parCca, parDtw);
    end
    
    % apply spatial transformation
    Ys = cellTim(cellTra(ali.Vs), Xs);
    
    % mean sequence
    Y = seqMean(Ys, ali0.P);
    
    % asymmetric DTW
    aliD = adtw(Ys, Y, [], parDtw);
    ali.P = aliD.P;

    objs(nIt + 1) = gtwObj(Xs, ali, parCca, parDtw);
    its(nIt + 1) = a2it('tem');
    
    % debug
    if isDebg
        debg(Ax1, Ax2, nIt + 1, objs, its, Xs, aliT, ali, parCca, parDtw);
    end

    % stop condition
    if pDif(ali.P, ali0.P) <= th
        break;
    end
    ali0 = ali;
end
prCOut(nIt);

% store
ali.alg = 'pctw';
ali.obj = objs(nIt + 1);
ali.objs = objs(1 : nIt);
ali.its = its(1 : nIt);
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function debg(Ax1, Ax2, nIt, objs, its, Xs, aliT, ali, parCca, parDtw)
% Show current status in the optimization of pCTW.

% parameter
parPca = st('d', 3, 'homo', 'y');
parMk = st('mkSiz', 3, 'lnWid', 1, 'ln', '-');
parChan = st('nms', {'x', 'y', 'z'}, 'gapWid', 1);
parAx = st('mar', .1, 'ang', [30 80]);

% obj
shIt(objs(1 : nIt), its(1 : nIt), 'ax', Ax1{1, 1}, 'mkSiz', 7, 'itNms', {'space', 'time'});
title('objective');

% dimension
m = length(Xs);
ds = cellDim(Xs, 1);
ns = cellDim(Xs, 2);

% original
if nIt == 1
    col = 2;
    XXs = pcas(Xs, stAdd(parPca, 'cat', 'n'));

    shs(XXs, parMk, parAx, 'ax', Ax1{1, col});
    view([30 80]);
    title('original sequence (x vs y)');

    shChans(XXs, parMk, parChan, 'ax', Ax1{2, col});
    title('original sequence (x y vs time)');
end

% truth
if nIt == 1 && ~isempty(aliT)
    col = 3;
    Ys = gtwTra(Xs, aliT, parCca, parDtw);
    YYs = pcas(Ys, parPca);

    shs(YYs, parMk, parAx, 'ax', Ax1{1, col});
    title('true sequence (x vs y)');

    shChans(YYs, parMk, stAdd(parChan, 'P', aliT.P), 'ax', Ax1{2, col});
    title('true sequence (x y vs time)');
end

% current
[Ys, ~, Us] = gtwTra(Xs, ali, parCca, parDtw);
if nIt == 1
    set(Ax1{1, 4}, 'UserData', ali);
    ali0 = ali;
    col = 4;
else
    ali0 = get(Ax1{1, 4}, 'UserData');
    col = 5;
end
YYs = pcas(Ys, parPca);
shs(YYs, parMk, parAx, 'ax', Ax1{1, col});
title(sprintf('step %d sequence (x vs y)', nIt));

shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', Ax1{2, col});
title(sprintf('step %d sequence (x y vs time)', nIt));

% transformation
for i = 1 : length(Xs)
    shM(Us{i}, 'ax', Ax2{1, i}, 'eq', 'y', 'clMap', 'jet');
    title(['Spatial transformation for sequence ' num2str(i)]);
end
