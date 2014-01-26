function tran = tranOpt(gphs, lamQ, X, par)
% Compute the optimal transformation given the correspondence.
%
% Remark
%   Transform gphs{2} to \tau(gphs{2}) that matched with gphs{1}.
%
% Input
%   gphs    -  graph set, 1 x 2 (cell)
%   lamQ    -  weight to tradeoff between the 1st and 2nd component
%   X       -  correspondence, n1 x n2
%   par     -  parameter
%     algT  -  transformation name, 'sim' | 'aff' | 'non'
%     ** used only for non-rigid transformation **
%     P     -  basis point for computing RBF kernel, d x n
%     sigW  -  sigma for computing RBF kernel
%     lamW  -  regularization weight
%
% Output
%   tran    -  optimal transformation
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-17-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-11-2012

% function parameter
algT = par.algT;
prIn('tranOpt', 'algT %s', algT);

% graph element
[P1, Q1, G1, H1] = stFld(gphs{1}, 'Pt', 'PtD', 'G', 'H');
[P2, Q2, G2, H2] = stFld(gphs{2}, 'Pt', 'PtD', 'G', 'H');

% dimension
[n1, m1] = size(G1);
[n2, m2] = size(G2);

% compute: Y = G1' X G2 .* H1' X H2
if lamQ > 0
    [IndG1T, IndG2, IndH1T, IndH2] = mat2inds(G1', G2, H1', H2);
    Y = multGXH(IndG1T, X, IndG2) .* multGXH(IndH1T, X, IndH2);
%     max(Y(:))
end

% similarity transform
if strcmp(algT, 'sim')
    % centralize
    [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X);

    % svd: U S V' = P1 X P2' + lamQ Q1 Y Q2'
    Tmp = BP1 * X * BP2';
    if lamQ > 0
        Tmp = (1 - lamQ) * Tmp + lamQ * Q1 * Y * Q2';
    end
    [U, S, V] = svd(Tmp);

    % optimal solution
    d = det(U * V');
    D = diag([ones(1, size(U, 2) - 1), d]);
    R = U * D * V';
%    R = U * V';    
    tmp = trace(ones(n1, 2) * (BP2 .^ 2) * X');
    if lamQ > 0
        tmp = (1 - lamQ) * tmp + lamQ * trace(ones(m1, 2) * (Q2 .^ 2) * Y');
    end
    s = trace(S) / tmp;
    t = bp1 - s * R * bp2;

    % store
    tran = st('algT', algT, 's', s, 'R', R, 't', t);    

% affine transformation
elseif strcmp(algT, 'aff')
    % centralize
    [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X);

    % optimal solution
    Tmp1 = BP1 * X * BP2';
    Tmp2 = BP2 * diag(colX) * BP2';
    if lamQ > 0
        colY = sum(Y', 2);
        Tmp1 = (1 - lamQ) * Tmp1 + lamQ * Q1 * Y * Q2';
        Tmp2 = (1 - lamQ) * Tmp2 + lamQ * Q2 * diag(colY) * Q2';
    end
    V = Tmp1 / Tmp2;
    t = bp1 - V * bp2;

    % store
    tran = st('algT', algT, 'V', V, 't', t);

% non-rigid transform
elseif strcmp(algT, 'non')
    % parameter
    [P, sigW, lamW] = stFld(par, 'P', 'sigW', 'lamW');

    % RBF kernel
    D = conDst(P, P2);
    KP = exp(-D / (2 * sigW ^ 2));
    
    % optimal solution (old)
%     A = P1 * X * KP' - P2 * diag(X' * ones(n1, 1)) * KP';
%     B = KP * diag(X' * ones(n1, 1)) * KP';
%     if lamQ > 0
%         KQ = KP * (G2 - H2);
%         A = (1 - lamQ) * A + lamQ * Q1 * Y * KQ' - lamQ * Q2 * diag(Y' * ones(m1, 1)) * KQ';
%         B = (1 - lamQ) * B + lamQ * KQ * diag(Y' * ones(m1, 1)) * KQ';
%     end
%     B = B + lamW * KP';
%     W = A / B;
    
    % optimal solution (new)
    A = P1 * X - P2 * diag(X' * ones(n1, 1));
    B = KP * diag(X' * ones(n1, 1));
    if lamQ > 0
        GH = G2 - H2;
        KQ = KP * GH;
        A = (1 - lamQ) * A + lamQ * Q1 * Y * GH' - lamQ * Q2 * diag(Y' * ones(m1, 1)) * GH';
        B = (1 - lamQ) * B + lamQ * KQ * diag(Y' * ones(m1, 1)) * GH';
    end
    B = B + lamW * eye(n1);
    W = A / B;

    % store
    tran = st('algT', algT, 'W', W, 'P', P, 'sigW', sigW, 'lamW', lamW);

else
    error('unknown transformation name: %s', algT);    
end

prOut;
