function ali = pimw(Xs, ali0, aliT, parPimw, parDtw)
% Procrust Iterative Motion Warping (pIMW).
%
% Reference 1
%   Style Translation for Human Motion, in ACM SIGGRAPH, 2005.
%
% Reference 2
%   F. Zhou and F. De la Torre, 
%   "Generalized Time Warping for Multi-modal Alignment of Human Motion", 
%   in CVPR, 2012.
%
% Input
%   Xs       -  original sequences, 1 x m (cell), dim x n
%   ali0     -  initial alignment
%   aliT     -  ground-truth alignment (can be [])
%   parPimw  -  parameter for pIMW
%     th     -  stop threshold, {0}
%     nItMa  -  maximum iteration number, {50}
%     lA     -  weight of penalization in spacewarp, {1}
%     lB     -  weight of penalization in spacewarp, {1}
%     debg   -  debug flag, 'y' | {'n'}
%   parDtw   -  parameter for DTW, see function dtw for more details
%
% Output
%   ali      -  alignment
%     X      -  mean sequence, 1 x 2 (cell)
%     As     -  scale of space warping matrix, dim x n1
%     Bs     -  offset of space warping matrix, dim x n1
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-18-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-30-2013

% function parameter
th = ps(parPimw, 'th', 0);
nItMa = ps(parPimw, 'nItMa', 50);
lA = ps(parPimw, 'lA', 1);
lB = ps(parPimw, 'lB', 1);
isDebg = psY(parPimw, 'debg', 'n');

% dimension
m = length(Xs);
dim = size(Xs{1}, 1);
ns = cellDim(Xs, 2);
nsStr = vec2str(ns, '%d', 'delim', ' ');
prIn('pimw', 'dim %d, ns %s', dim, nsStr);

% debug
if isDebg
    rows = 3; cols = 5;
    Ax1 = iniAx(fig, rows, cols, [250 * rows, 250 * cols + 250], 'pos', [0 0 .8 1]);
    set(Ax1{2, 1}, 'Visible', 'off');

    rows = m; cols = 1;
    Ax2 = iniAx(0, rows, cols, [], 'pos', [.8 0 .2 1], 'hGap', .2);
else
    Ax1 = [];
    Ax2 = [];
end

% coordinate-descent
ali0.P = round(ali0.P);
ali = ali0;
[objs, its] = zeross(1, nItMa);
Ys = cellss(1, m);
prCIn('EM', nItMa, .1);
for nIt = 1 : 2 : nItMa
    prC(nIt);

    % mean sequence
    ali.X = seqMean(Xs, round(ali0.P));

    % spatial transformation
    ali.As = cell(1, m);
    ali.Bs = cell(1, m);
    for i = 1 : m
        [ali.As{i}, ali.Bs{i}] = spaceWarp(Xs{i}, ali.X, ali.P(:, i), lA, lB);
        Ys{i} = Xs{i} .* ali.As{i} + ali.Bs{i};
    end
    objs(nIt) = pimwObj(Xs, ali, parPimw);
    its(nIt) = a2it('spa');

    % asymmetric DTW
    aliA = adtw(Ys, ali.X, [], parDtw);
    ali.P = aliA.P;
    objs(nIt + 1) = pimwObj(Xs, ali, parPimw);
    its(nIt + 1) = a2it('tem');

    % stop condition
    if pDif(ali.P, ali0.P) <= th
        break;
    end
    ali0 = ali;
end
prCOut(nIt);

% store
ali.alg = 'pimw';
ali.obj = objs(nIt + 1);
ali.objs = objs(1 : nIt + 1);
ali.its = its(1 : nIt + 1);
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A, B] = spaceWarp(X, Y, p, lA, lB)
% Space warping for IMW.
%
% Input
%   X   -  sample matrix, d x n
%   Y   -  sample matrix, d x l
%   p   -  warping vector, l x 1
%   lA  -  weight of penalization in spacewarp
%   lB  -  weight of penalization in spacewarp
%
% Output
%   A   -  scale of space warping matrix, dim x n1 
%   B   -  offset of space warping matrix, dim x n2

% dimension
[d, n] = size(X);

% warping
Ws = aliP2W(p);
W = Ws{1}';
D = W' * W;
dd = diag(D); % we use D's diagonal to accelerate the computation

% differential operator
FA = mgrad(n) * lA;
FB = mgrad(n) * lB;
FA2 = FA' * FA;
FB2 = FB' * FB;

% solve for each dimension
[A, B] = zeross(d, n);
for c = 1 : d
    x = X(c, :)';
    y = Y(c, :)';

    % remove non-informative dimensions
%     vis = abs(x) < eps;
%     m = length(find(vis));
% %     fprintf('%d/%d\n', m, n1);
%     if m > .9 * n1
%         nDim = nDim - 1;
%         continue;
%     end

    % left-hand side of equation 4 in the paper
    L11 = diag(dd .* x .* x) + FA2; % equal to U' * W' * W * U + F' * F (in the paper)
    L12 = diag(dd .* x);            % equal to U' * W' * W (in the paper)
    L22 = D + FB2;                  % equal to W' * W + G' * G (in the paper)
    L = [L11, L12; L12, L22];

    % right-hand side of equation 4 in the paper
    r2 = W' * y;                   % equal to W' * y (in the paper)
    r1 = x .* r2;                  % equal to U' * W' * y (in the paper)
    r = [r1; r2];

    % store
    warning off;
    sol = L \ r;
    warning on;
    A(c, :) = sol(1 : n)';
    B(c, :) = sol(n + 1 : end)';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function debg(isDebg, Ax1, Ax2, nIt, objs, its, Xs, aliT, ali, parCca, parDtw)
% Show current status in the optimization of pIMW.

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
shAlis(alis, 'ax', Ax1{3, 1});

% transformation
for i = 1 : length(Xs)
    shM(Us{i}, 'ax', Ax2{i}, 'eq', 'y', 'clMap', 'jet');
    title(['Spatial transformation for sequence ' num2str(i)]);
end
