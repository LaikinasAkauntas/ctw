function ali = ctw(Xs, ali0, aliT, parCtw, parCca, parDtw)
% Canonical Time Warping (CTW).
%
% Reference
%   F. Zhou and F. De la Torre, 
%   "Canonical Time Warping for Alignment of Human Behavior", 
%   in NIPS, 2009.
%
% Input
%   Xs       -  sequences, 1 x m (cell), di x ni
%   ali0     -  initial alignment
%   aliT     -  ground-truth alignment (can be [])
%   parCtw   -  parameter for CTW
%     th     -  stop threshold, {.01}
%     nItMa  -  maximum iteration number, {50}
%     debg   -  debug flag, 'y' | {'n'}
%     fig    -  figure used for debugging, {11}
%   parCca   -  parameter for CCA. See function mcca for more details
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
%   modify   -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% function parameter
th = ps(parCtw, 'th', .01);
nItMa = ps(parCtw, 'nItMa', 50);
isDebg = psY(parCtw, 'debg', 'n');
fig = ps(parCtw, 'fig', 11);

% dimension
m = length(Xs);
[d1, n1] = size(Xs{1});
[d2, n2] = size(Xs{2});
prIn('ctw', '1st seq %d x %d, 2nd seq %d x %d', d1, n1, d2, n2);

% homogeneous coordinate
Xs = homoX(Xs, 1);

% debug - initialize axes for plotting
if isDebg
    rows = 3; cols = 5;
    Ax1 = iniAx(fig, rows, cols, [250 * rows, 250 * cols + 250], 'pos', [0 0 .8 1]);
    set(Ax1{2, 1}, 'visible', 'off');

    rows = m; cols = 1;
    Ax2 = iniAx(0, rows, cols, [], 'pos', [.8 0 .2 1], 'hGap', .2);
else
    Ax1 = [];
    Ax2 = [];
end

% initial alignment
ali0.P = round(ali0.P);
ali = ali0;

% coordinate-descent search
[objs, its] = zeross(1, nItMa);
prCIn('EM', nItMa, .1);
for nIt = 1 : 2 : nItMa
    prC(nIt);

    % do the operation: X W_x and Y W_y, given the alignment
    Ys = seqInp(Xs, ali0.P, parDtw);
    
    % compute spatial transformation using CCA
    ali.Vs = mcca(Ys, parCca);

    % compute objective value
    objs(nIt) = gtwObj(Xs, ali, parCca, parDtw);
    
    % iteration tag
    its(nIt) = a2it('spa');
    
    % calculate the dimension of CCA at the first step, always use it for the remaining steps
    if nIt == 1
        parCca.d = size(ali.Vs{1}, 2) - 1;
    end

    % debug
    debg(isDebg, Ax1, Ax2, nIt, objs, its, Xs, aliT, ali, parCca, parDtw);

    % do the operation: V_x X and V_y Y, given the embedding
    Ys = cellTim(cellTra(ali.Vs), Xs);
    
    % compute temporal alignment using DTW
    aliD = dtw(Ys, [], parDtw);
    ali.P = aliD.P;

    % compute objective value
    objs(nIt + 1) = gtwObj(Xs, ali, parCca, parDtw);
    
    % iteration tag
    its(nIt + 1) = a2it('tem');
    
    % debug
    debg(isDebg, Ax1, Ax2, nIt + 1, objs, its, Xs, aliT, ali, parCca, parDtw);

    % stop condition
    if pDif(ali.P, ali0.P) <= th
        break;
    end
    
    % save the alignment for initalizing the next iteration
    ali0 = ali;
end
prCOut(nIt + 1);

% store
ali.alg = 'ctw';
ali.obj = objs(nIt + 1);
ali.objs = objs(1 : nIt + 1);
ali.its = its(1 : nIt + 1);
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function debg(isDebg, Ax1, Ax2, nIt, objs, its, Xs, aliT, ali, parCca, parDtw)
% Show current status in the optimization of CTW.

if ~isDebg
    return;
end

% parameter
parPca = st('d', 3, 'homo', 'y');
parMk = st('mkSiz', 3, 'lnWid', 1);
parChan = st('nms', {'x', 'y', 'z'}, 'gapWid', 1);
parAx = st('mar', .1, 'ang', [30 80]);

% obj
shIt(objs(1 : nIt), its(1 : nIt), 'ax', Ax1{1, 1}, 'mkSiz', 7, 'itNms', {'space', 'time'}, 'itMa', 0);
title('objective');

% original
ds = cellDim(Xs, 1);
if nIt == 1 && all(ds == ds(1))
    col = 2;
    XXs = pcas(Xs, parPca);

    shs(XXs, parMk, parAx, 'ax', Ax1{1, col});
    title('original sequence (x vs y)');

    shChans(XXs, parMk, parChan, 'ax', Ax1{2, col});
    title('original sequence (x y vs time)');

    D = conDst(Xs{1}, Xs{2});
    shM(D, 'ax', Ax1{3, col}, 'clMap', 'jet', 'lnMk', '--', 'lnWid', 2, 'lnCl', 'b');
    title('original distance');
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

    D = conDst(Ys{1}, Ys{2});
    shM(D, 'ax', Ax1{3, col}, 'clMap', 'jet', 'lnMk', '--', 'lnWid', 2, 'lnCl', 'b');
    title('true distance');
end

% current
[Ys, Zs, Us] = gtwTra(Xs, ali, parCca, parDtw);
D = conDst(Zs{1}, Zs{2});
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

shM(D, 'ax', Ax1{3, col}, 'clMap', 'jet', 'lnMk', '--', 'lnWid', 2, 'lnCl', 'b');
title(sprintf('step %d distance', nIt));

% alignment
ali0.alg = 'initial';
ali.alg = 'current';
if ~isempty(aliT)
    aliT.alg = 'truth';
    alis = {aliT, ali0, ali};
else
    alis = {ali0, ali};
end
shAlis2d(alis, 'ax', Ax1{3, 1});

% transformation
for i = 1 : length(Xs)
    shM(Us{i}, 'ax', Ax2{i}, 'eq', 'y', 'clMap', 'jet');
    title(['Spatial transformation for sequence ' num2str(i)]);
end
