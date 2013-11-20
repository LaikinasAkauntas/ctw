function [v, S, DC] = dtwFordAsySlow(D)
% Move forward to construct the path matrix.
% Notice that the step of moving left is prohibited.
%
% Example
%   input   -  D = [0 1 1 1 0 1 1 0 1; ...
%                   1 0 1 1 1 1 1 1 0; ...
%                   1 1 0 1 1 1 1 1 1; ...
%                   1 1 1 0 1 0 0 1 1; ...
%                   1 1 1 0 1 0 0 1 1; ...
%                   0 1 1 1 0 1 1 0 1; ...
%                   1 0 1 1 1 1 1 1 0];
%   call    -  [v, P, U] = dtwFordAsy(D)
%   output  -  v = 1;
%              S = [0 1 1 1 1 1 1 1 1; ...
%                   0 3     1     1     1     3     3     3     3
%     0     0     3     1     1     1     1     1     1
%     0     0     0     3     1     1     1     1     1
%     0     0     0     0     3     3     3     3     3
%     0     0     0     0     0     3     3     3     1
%     0     0     0     0     0     0     3     3     3]
%              DC = [0     1     2     3     3     4     5     5     6
%      0     0     1     2     3     4     5     6     5
%      0     0     0     1     2     3     4     5     6
%      0     0     0     0     1     1     1     2     3
%      0     0     0     0     1     1     1     2     3
%      0     0     0     0     0     2     2     1     2
%      0     0     0     0     0     0     3     3     1]
%
% Input
%   D       -  frame (squared) distance matrix, n1 x n2 (n2 >= n1)
%
% Output
%   v       -  objective value of dtw
%   S       -  step matrix, n1 x n2
%   DC      -  cummulative distance matrix, n1 x n2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[n1, n2] = size(D);
[S, DC] = zeross(n1, n2);

if n1 > n2
    error('must have n1 <= n2');
end

for i = 1 : n1
    for j = i : n2
        d = D(i, j);

        if i == 1 && j == 1
            DC(i, j) = d;
            S(i, j) = 0;

        elseif i == 1
            DC(i, j) = DC(i, j - 1) + d;
            S(i, j) = 1;

        elseif i == j
            DC(i, j) = DC(i - 1, j - 1) + d;
            S(i, j) = 3;
            
        else
            if DC(i, j - 1) < DC(i - 1, j - 1)
                DC(i, j) = DC(i, j - 1) + d;
                S(i, j) = 1;

            else
                DC(i, j) = DC(i - 1, j - 1) + d;
                S(i, j) = 3;                
            end
        end
    end
end
v = DC(n1, n2);
