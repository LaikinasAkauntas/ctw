function [d1s, d2s] = conDstNear(X1, X2)
% Compute nearest neighbour.
%
% Input
%   X1      -  1st sample matrix, d x n1
%   X2      -  2nd sample matrix, d x n2
%
% Output
%   d1s     -  minimum distance for 1st set, 1 x n1
%   d2s     -  minimum distance for 2nd set, 1 x n2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-23-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2012

% dimension
n1 = size(X1, 2);
n2 = size(X2, 2);

% parameter
th = 4000 * 4000;

% small scale
if n1 * n2 < th
    % distance
    D = conDst(X1, X2);

    % nearest neighbour
    d1s = min(D, [], 2);
    d2s = min(D, [], 1);
    d1s = d1s';

% large scale
else
    d1s = zeros(1, n1);
    d2s = zeros(1, n2);
    
    for i = 1 : n1
        Di = conDst(X1(:, i), X2);
        d1s(i) = min(Di);
    end
    
    for j = 1 : n2
        Dj = conDst(X1, X2(:, j));
        d2s(j) = min(Dj);
    end
end
