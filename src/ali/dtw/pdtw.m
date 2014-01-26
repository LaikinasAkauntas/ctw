function ali = pdtw(Xs, ali0, aliT, parPdtw)
% Procrust Dynamic Time Warping (PDTW).
%
% Input
%   Xs       -  sequences, 1 x m (cell), d x ni
%   ali0     -  initial alignment
%   aliT     -  ground-truth alignment (can be [])
%   parPdtw  -  parameter
%     th     -  stop threshold, {0}
%     nItMa  -  maximum iteration number, {100}
%     dp     -  implementation for dynamic programming, 'matlab' | {'c'}
%     debg   -  debug flag, 'y' | {'n'}
%
% Output
%   ali      -  alignment
%     P      -  warping path, l x m
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 09-07-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-23-2013

% function parameter
th = ps(parPdtw, 'th', 0);
nItMa = ps(parPdtw, 'nItMa', 100);
isDebg = psY(parPdtw, 'debg', 'n');
dimPca = ps(parPdtw, 'dimPca', 4);

% dimension
dim = size(Xs{1}, 1);
ns = cellDim(Xs, 2);
nsStr = vec2str(ns, '%d', 'delim', ' ');
prIn('pdtw', 'dim %d, ns %s', dim, nsStr);

% debug
if isDebg
    rows = 2; cols = 3;
    fig = 1;
    axs = iniAx(fig, rows, cols, [300 * cols, 300 * rows]);
    
    % pca
    if dim > dimPca
        XXs = pcaM(Xs, st('d', dimPca, 'debg', 'n'));
    else
        XXs = Xs;
    end
end

% initial alignment
ali0.P = round(ali0.P);

% coordinate-descent
objs = zeros(1, nItMa);
tPdtw = tic;
prCIn('EM', nItMa, 1);
for nIt = 1 : nItMa
    prC(nIt);

    % mean sequence
    X = seqMean(Xs, ali0.P);

    % asymmetric DTW
    ali = adtw(Xs, X, [], parPdtw);

    % objective
    objs(nIt) = gtwObj(Xs, ali, [], parPdtw);
    if isDebg
        debg(axs, objs, XXs, ali);
    end

    % stop condition
    if pDif(ali.P, ali0.P) <= th
        break;
    end
    ali0 = ali;
end
prCOut(nIt);

% store
ali.alg = 'pdtw';
ali.obj = objs(nIt);
ali.objs = objs(1 : nIt);
ali.tim = toc(tPdtw) / nIt;
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function debg(axs, objs, Xs, P)
% Show current status in the optimization of pdtw.

% obj
shIt(objs, [], 'ax', axs{1, 1}, 'mkSiz', 7, 'mkEg', 'n', 'lnWid', 1);
axis square;
if length(objs) > 2
    ylim([0 objs(2) * 1.5]);
end
title('objective');

shSeqs(Xs, 'ax', axs{1, 2}, 'mkSiz', 3, 'mkEg', 'n', 'lnWid', 1);
title('original sequence');

shChans(Xs, 'ax', axs{1, 3}, 'mkSiz', 3, 'mkEg', 'n', 'lnWid', 1);
title('original sequence');

ali.P = P;
shChans(Xs, 'ax', axs{2, 3}, 'ali', ali, 'mkSiz', 3, 'mkEg', 'n', 'lnWid', 1);
title('new sequence');

% shM(H, 'ax', axs{2, 2});
% title('Hessian');

drawnow;
