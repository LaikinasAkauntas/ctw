function w = optL1(alg, L, b)
% Linear programming for optimizing | L * w - b |.
%
% Math
%   min_w | L * w - b |
%   st    w^T 1 = 1
%
% Input
%   alg     -  toolbox name, 'matlab' | 'cvx'
%   L       -  constraint, (d * m + 1) x nVar
%   b       -  value, d * m + 1
%
% Output
%   w       -  solution, nVar x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-16-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-20-2012

% dimenson
[nCon, nVar] = size(L);

% cvx
if strcmp(alg, 'cvx')

    a = ones(1, nVar);
    cvx_quiet(true);
    cvx_begin
        variable w(nVar, 1);
        minimize( norm(L * w - b, 2) )
        subject to
            a * w == 1;
    cvx_end

% matlab    
elseif strcmp(alg, 'matlab')

    f = [zeros(nVar, 1); ones(nCon + nCon, 1)];
    AEq = zeros(nCon + 1, nVar + nCon + nCon);
    for iCon = 1 : nCon
        AEq(iCon, 1 : nVar) = L(iCon, :);
        AEq(iCon, nVar + iCon) = 1;
        AEq(iCon, nVar + nCon + iCon) = -1;
    end
    AEq(end, 1 : nVar) = 1;
    bEq = [b; 1];
    
    lb = zeros(nVar + nCon + nCon, 1);
    lb(1 : nVar) = -inf;
    options = optimset('LargeScale', 'on', 'Display', 'off');
    [res, obj, flag] = linprog(f, [], [], AEq, bEq, lb, [], [], options);
    w = res(1 : nVar);
    
else
    error('unknown algorithm: %s', alg);
end
