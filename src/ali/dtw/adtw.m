function ali = adtw(Xs, X, aliT, parAdtw)
% Asymetric Dynamic Time Warping (ADTW).
%
% Input
%   Xs       -  sequences, 1 x m (cell), dim x n
%   X        -  template sequence, d x l
%   aliT     -  ground-truth alignment (can be [])
%   parAdtw  -  parameter
%     dp     -  implementation for dynamic programming, 'matlab' | {'c'}
%            
% Output     
%   ali      -  alignment
%     alg    -  'adtw'
%     P      -  warping path, l x 2
%     obj    -  objective
%            
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-09-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-16-2013

% function parameter
dp = ps(parAdtw, 'dp', 'c');

% dimension
m = length(Xs);
l = size(X, 2);

P = zeros(l, m);
for i = 1 : m
    % distance
    D = conDst(Xs{i}, X);

    % dynamic programming
    if strcmp(dp, 'c')
        [~, S] = dtwFordAsy(D);
        Pi = dtwBack(S);

    elseif strcmp(dp, 'matlab')
        [~, S] = dtwFordAsySlow(D);
        Pi = dtwBackSlow(S);

    else
        error('unknown dp implementation: %s', dp);
    end

    % store
    P(:, i) = Pi(:, 1);
end

% store
ali.alg = 'adtw';
ali.P = P;
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end
