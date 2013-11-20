function tran = tranOpt(P1, P2, X, algT)
% Compute the optimal transformation given the correspondence.
%
% Input
%   P1      -  1st point set, 2 x n1
%   P2      -  2nd point set, 2 x n2
%   X       -  correspondence, n1 x n2
%   algT    -  transformation name, 'sim' | 'aff' | 'non'
%
% Output
%   tran    -  optimal transformation
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-11-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 03-19-2012

% dimension
n1 = size(P1, 2);
n2 = size(P2, 2);

% similarity transform
if strcmp(algT, 'sim')
    % centralize
    [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X);

    % svd of P1 * X * P2'
    [U, S, V] = svd(BP1 * X * BP2');
    R = U * V';
    s = trace(S) / trace(ones(n1, 2) * (P2 .^ 2) * X');
    t = bp1 - s * R * bp2;

    % store
    tran = st('algT', algT, 's', s, 'R', R, 't', t);

% affine transformation
elseif strcmp(algT, 'aff')
    % centralize
    [BP1, BP2, bp1, bp2, rowX, colX, nor] = tranCenP(P1, P2, X);
    
    % optimal
    Tmp1 = BP1 * X * BP2';
    Tmp2 = BP2 * diag(colX) * BP2';
    V = Tmp1 / Tmp2;
    t = bp1 - V * bp2;
   
    % store
    tran = st('algT', algT, 'V', V, 't', t);

% non-rigid transform
elseif strcmp(algT, 'non')    
    
else
    error('unknown transformation name: %s', algT);
end
