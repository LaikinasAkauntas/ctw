function [A, P, L] = timewarpSlow(D, k)
% Temporal warp of two sequences.
%
% Notice: no path coming from UP element
%
% Input
%   D       -  distance matrix, n1 x n2
%   k       -  slop constraint
%
% Output
%   S       -  step matrix, n1 x n2
%   DC      -  cummulative distance matrix, n1 x n2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-18-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[n1, n2] = size(D);
a = sum(D(:));

[A, P, L] = zeross(n1, n2, k);
A(:) = a;
P(:) = -1;
L(:) = -1;

for i = 1 : n1
    for j = 1 : n2
        d = D(i, j);

        if i == 1 && j == 1
            A(i, j, 1) = d;
            P(i, j, 1) = 0;
            L(i, j, 1) = 0;

        elseif i == 1
            if j <= k
                A(i, j, j) = A(i, j - 1, j - 1) + d;
                P(i, j, j) = 1;
                L(i, j, j) = j - 1;
            end

        elseif j == 1
            % never happens

        else
            % from left
            for c = 2 : k
                if P(i, j - 1, c - 1) ~= -1
                    A(i, j, c) = A(i, j - 1, c - 1) + d;
                    P(i, j, c) = 1;
                    L(i, j, c) = c - 1;
                end
            end

            % from upper-left
            if ~isempty(find(P(i - 1, j - 1, :) ~= -1, 1))
                P(i, j, 1) = 3;
                [A(i, j, 1), L(i, j, 1)] = min(A(i - 1, j - 1, :) + d);
            end
        end
    end
end
