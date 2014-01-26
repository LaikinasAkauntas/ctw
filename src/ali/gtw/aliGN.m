function ali = aliGN(Xs, bas, ali0, aliT, parGN)
% The Gauss-Netwon algorithm for aligning multiple sequences.
%
% Reference
%   F. Zhou and F. De la Torre, 
%   "Generalized Time Warping for Multi-modal Alignment of Human Motion", 
%   in CVPR, 2012.
% 
% Input
%   Xs       -  sequences, 1 x m (cell), d x ni
%   bas      -  warping bases, 1 x m (cell)
%   ali0     -  initial alignment
%   aliT     -  ground-truth alignment (can be [])
%   parGN    -  parameter
%     eta    -  regualization weight, {0}
%     th     -  stop threshold, {0}
%     nor    -  normalization flag, 'y' | {'n'}
%     nItMa  -  maximum iteration number, {2}
%     inp    -  interpolation algorithm, See function seqInp for more details
%     qp     -  toolbox used for quadartic programming, 'mosek' | {'matlab'} | 'cvx' | ...
%               See function qprog for more details
%     debg   -  debug flag, 'y' | {'n'}
%
% Output
%   ali      -  alignment
%     alg    -  'gn'
%     objs   -  objective value, 1 x nIt
%     A      -  weights, k x nIt
%     AD     -  increments of weight, k x nIt
%     Hs     -  Hessian matrices, k x k x nIt
%     F      -  f, k x nIt
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-30-2013

% function parameter
lam = ps(parGN, 'lam', 0);
lam2 = ps(parGN, 'lam2', 0);
th = ps(parGN, 'th', 0);
isNor = psY(parGN, 'nor', 'n');
nItMa = ps(parGN, 'nItMa', 50);
qp = ps(parGN, 'qp', 'matlab');
isDebg = psY(parGN, 'debg', 'n');
fig = ps(parGN, 'fig', 11);

% dimension
m = length(Xs);
ns = cellDim(Xs, 2);
Ps = cellFld(bas, 'cell', 'P');
ks = cellDim(Ps, 2);
l = size(bas{1}.P, 1);
k = sum(ks);
prIn('Gauss-Netwon', 'm %d, k %d', m, ks(1));

% debug
if isDebg
    rows = 2; cols = 5;
    Ax1 = iniAx(fig, rows, cols, [250 * rows, 250 * cols + 250], 'pos', [0 0 .8 1]);

    rows = m; cols = 1;
    Ax2 = iniAx(0, rows, cols, [], 'pos', [.8 0 .2 1], 'hGap', .2);
	XXs = pcas(Xs, st('d', 3, 'debg', 'n'));
else
    Ax1 = [];
    Ax2 = [];
    XXs = [];
end

% constraint
[Ls, L2s, b0s, bs] = cellss(1, m);
for j = 1 : m
    [Ls{j}, b0s{j}] = ftwCont(bas{j});
    if isNor
        L2s{j} = Ls{j} / ns(j);
    else
        L2s{j} = Ls{j};
    end
end
L = mcat('diag', L2s);

% row of basis
PRs = cell(1, m);
for i = 1 : m
    PRs{i} = mdiv('vert', bas{i}.P, ones(l, 1));
end

% derivative of sample and basis
[XDs, PDs, PD2s] = cellss(1, m);
for i = 1 : m
    XDs{i} = gradient(Xs{i});
    PDs{i} = gradient(bas{i}.P');
    PDs{i} = PDs{i}';
    if isNor
        PD2s{i} = PDs{i} / ns(i);
    else
        PD2s{i} = PDs{i};
    end
end
PDDiag = mcat('diag', cellTim(cellTra(PD2s), PD2s));
PDVerts = cellTim(cellTra(PDs), PD2s);

% normalization
rs = cell(1, m);
for i = 1 : m
    rs{i} = ones(ks(i), 1) * ns(i);
end
r = mcat('vert', rs);

% coordinate-descent
Gs = cell(1, m);
P = zeros(l, m);
objs = zeros(1, nItMa);
Hs = zeros(k, k, nItMa);
[F, A, AD] = zeross(k, nItMa);
hTic = tic;
isValid = 1;
prCIn('Gauss-Newton', nItMa, 1);
for nIt = 1 : nItMa
    prC(nIt);

    if nIt == 1
        a = ali0.a;
    else
        % v
        vs = cellVec(seqInp(Xs, ali0.P, parGN));

        % G
        XDPs = seqInp(XDs, ali0.P, parGN);
        for i = 1 : m
            tmps = mdiv('horz', XDPs{i}, ones(1, l));
            Gs{i} = mcat('vert', cellTim(tmps, PRs{i}));
            if isNor
                Gs{i} = Gs{i} / ns(i);
            end
        end
        GHorz = mcat('horz', Gs);

        % H
        GGDiag = mcat('diag', cellTim(cellTra(Gs), Gs));
        H = m * GGDiag - GHorz' * GHorz + lam * PDDiag + lam2 * eye(size(PDDiag, 1));

        % f
        GDiag = mcat('diag', cellTra(Gs));
        vVert = mcat('vert', vs);
        vHorz = mcat('horz', vs);
        PDa = mcat('vert', cellTim(PDVerts, as));
        f = GDiag * ominus(m * vVert, vHorz * ones(m, 1)) + lam * PDa;

        % constraint
        for j = 1 : m
            bs{j} = b0s{j} - Ls{j} * as{j};
        end
        b = mcat('vert', bs);

        % quadratic programming
        ad = optQuad(qp, H, f, [], [], L, [], b, [], [], []);

        if isNor
            ad = ad ./ r;
        end

        % update
        a = a + ad;
        AD(:, nIt) = ad;
        Hs(:, :, nIt) = H;
        F(:, nIt) = f;
    end
    A(:, nIt) = a;

    % warping path
    as = mdiv('vert', a, ks);
    for i = 1 : m
        P(:, i) = bas{i}.P * as{i};
    end

    % check feasibility of the solution
    for i = 1 : m
        if any(Ls{i} * as{i} > b0s{i} + 1e-6)
            isValid = 0;
            break;
        end
    end
    if ~isValid
        break;
    end

    % debug
    ali.P = P;
    objs(nIt) = gtwObj(Xs, ali, [], parGN);
    debg(isDebg, Ax1, Ax2, nIt, objs, XXs, bas, aliT, ali, parGN);

    % stop condition
    if nIt > 1 && max(abs(ad)) <= th
        break;
    end
    ali0 = ali;
end
prCOut(nIt);

% store
ali.alg = 'gn';
ali.isValid = isValid;
if ~isValid
    nIt = nIt - 1;
end
if nIt > 0
    ali.obj = objs(nIt);
    ali.objs = objs(1 : nIt);
    ali.a = A(:, nIt);
    ali.aD = AD(:, nIt);
    ali.A = A(:, 1 : nIt);
    ali.AD = AD(:, 1 : nIt);
    ali.Hs = Hs(:, :, 1 : nIt);
    ali.F = F(:, 1 : nIt);
    ali.tim = toc(hTic) / nIt;
    if ~isempty(aliT)
        ali.dif = pDif(ali.P, aliT.P);
    else
        ali.dif = NaN;
    end
else
    ali.P = NaN;
    ali.obj = NaN;
    ali.objs = NaN;
    ali.a = NaN;
    ali.aD = NaN;
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function debg(isDebg, Ax1, Ax2, nIt, objs, XXs, bas, aliT, ali, parGN)
% Show current status in the optimization.

if ~isDebg
    return;
end

% parameter
parMk = st('mkSiz', 3, 'lnWid', 1);
parChan = st('nms', {'x', 'y', 'z'}, 'gapWid', 1, 'all', 'y', 'inp', parGN.inp);
parAx = st('mar', .1, 'ang', [30 80]);

% dimension
m = length(XXs);
ns = cellDim(XXs, 2);
Ps = cellFld(bas, 'cell', 'P');
ks = cellDim(Ps, 2);
l = size(Ps{1}, 1);

% obj
shIt(objs(1 : nIt), [], 'ax', Ax1{1, 1}, 'mkSiz', 7);
title('objective');

% original
if nIt == 1
    col = 2;
    shs(XXs, parMk, parAx, 'ax', Ax1{1, col});
    title('original sequence (x vs y)');

    shChans(XXs, parMk, parChan, 'ax', Ax1{2, col});
    title('original sequence (x y vs time)');
end

% ground-truth
if nIt == 1 && ~isempty(aliT)
    col = 3;
    shs(XXs, parMk, parAx, 'ax', Ax1{1, col});
    title('true sequence (x vs y)');

    shChans(XXs, parMk, stAdd(parChan, 'P', aliT.P), 'ax', Ax1{2, col});
    title('truth sequence (x y vs time)');
end

% current
if nIt == 1
    set(Ax1{1, 4}, 'UserData', ali);
    ali0 = ali;
    col = 4;
else
    ali0 = get(Ax1{1, 4}, 'UserData');
    col = 5;
end
shs(XXs, parMk, parAx, 'ax', Ax1{1, col});
title(sprintf('step %d sequence (x vs y)', nIt));

shChans(XXs, parMk, stAdd(parChan, 'P', ali.P), 'ax', Ax1{2, col});
title(sprintf('step %d sequence (x y vs time)', nIt));

% bases & weight
for i = 1 : m
    shAliP(Ps{i}, 'ax', Ax2{i}, 'n', ns(i), 'mkSiz', 0);
    plot(1 : l, ali0.P(:, i), '--k', 'LineWidth', 1);
    plot(1 : l, ali.P(:, i), '-r', 'LineWidth', 2);
    axis square;
    title(['Temporal warping for sequence ' num2str(i)]);
end
