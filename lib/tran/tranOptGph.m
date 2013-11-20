function tran = tranOptGph(gphs, lamb, X, algT)
% Compute the optimal transformation given the correspondence.
%
% Input
%   gphs    -  graphs, 1 x 2 (cell)
%   lamb    -  weight for balancing between the 1st and 2nd component
%   X       -  correspondence, n1 x n2
%   algT    -  transformation name, 'sim' | 'aff' | 'non'
%
% Output
%   tran    -  optimal transformation
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-17-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 03-20-2012

prIn('tranOptGph');

% graph element
[P1, Q1, G1, H1] = stFld(gphs{1}, 'Pt', 'PtD', 'GA', 'HA');
[P2, Q2, G2, H2] = stFld(gphs{2}, 'Pt', 'PtD', 'GA', 'HA');

% dimension
[n1, m1] = size(G1);
[n2, m2] = size(G2);

% compute: Y = G1' X G2 .* H1' X H2
[IndG1T, IndG2, IndH1T, IndH2] = mat2inds(G1', G2, H1', H2);
Y = multGXH(IndG1T, X, IndG2) .* multGXH(IndH1T, X, IndH2);

% similarity transform
if strcmp(algT, 'sim')
    % centralize
    [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X);
    
    % svd: U S V' = P1 X P2' + lamb Q1 Y Q2'
    [U, S, V] = svd(BP1 * X * BP2' + lamb * Q1 * Y * Q2');

    % optimal solution
    R = U * V';
    tmp1 = trace(ones(n1, 2) * (BP2 .^ 2) * X');
    tmp2 = trace(ones(m1, 2) * (Q2 .^ 2) * Y');
    s = trace(S) / (tmp1 + lamb * tmp2);
    t = bp1 - s * R * bp2;

    % store
    tran = st('algT', algT, 's', s, 'R', R, 't', t);    

% affine transformation
elseif strcmp(algT, 'aff')
    % centralize
    [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X);
    colY = sum(Y', 2);
    
    % optimal
    Tmp1 = BP1 * X * BP2' + lamb * Q1 * Y * Q2';
    Tmp2 = BP2 * diag(colX) * BP2' + lamb * Q2 * diag(colY) * Q2';
    V = Tmp1 / Tmp2;
    t = bp1 - V * bp2;

    % store
    tran = st('algT', algT, 'V', V, 't', t);

% non-rigid transform
elseif strcmp(algT, 'non')
    
else
    error('unknown transformation name: %s', algT);    
end

prOut;