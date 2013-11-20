function [v, S, DC] = dtwFordIPSlow(D, sca)
% Forward step of DTW algorithm.
% The warping path is constrained in Itakura Parallelogram.
%
% Input
%   D       -  frame (squared) distance matrix, n1 x n2
%   sca     -  window size
%
% Output
%   v       -  objective value of dtw
%   S       -  step matrix, n1 x n2
%   DC      -  cumulative distance matrix, n1 x n2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[n1, n2] = size(D);
[S, DC] = zeross(n1, n2);
S(:) = -1;
DC(:) = -1;

for i = 1 : n1
    for j = 1 : n2
        d = D(i, j);
        
        if ~isOK(i, j, n1, n2, sca)
            continue;
        end

        if i == 1 && j == 1
            DC(i, j) = d;
            S(i, j) = 0;

        elseif i == 1
            DC(i, j) = DC(i, j - 1) + d;
            S(i, j) = 1;

        elseif j == 1
            DC(i, j) = DC(i - 1, j) + d;
            S(i, j) = 2;

        else
            if S(i - 1, j - 1) >= 0
                DC(i, j) = DC(i - 1, j - 1);
                S(i, j) = 3;
            end

            if S(i, j - 1) >= 0 && (S(i, j) < 0 || DC(i, j - 1) < DC(i, j))
                DC(i, j) = DC(i, j - 1);
                S(i, j) = 1;
            end
            
            if S(i - 1, j) >= 0 && (S(i, j) < 0 || DC(i - 1, j) < DC(i, j))
                DC(i, j) = DC(i - 1, j);
                S(i, j) = 2;
            end

            DC(i, j) = DC(i, j) + d;        
        end
    end
end
v = DC(n1, n2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function flag = isOK(i, j, n1, n2, sca)

flag = i <= sca * j & ...
       j <= sca * i & ...
       i >= n1 - 1 - sca * (n2 - j) & ...
       j >= n2 - 1 - sca * (n1 - i);
