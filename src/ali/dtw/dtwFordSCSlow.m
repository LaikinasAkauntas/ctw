function [v, S, DC] = dtwFordSCSlow(D, win)
% Forward step of DTW algorithm.
% The warping path is constrained in Sakoe-Chiba window.
%
% Input
%   D       -  frame (squared) distance matrix, n1 x n2
%   win     -  window size
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
if win < 1
    win = round(win * (n1 + n2) * .5);
end

win = max(win, abs(n1 - n2));

for i = 1 : n1
    for j = 1 : n2
        d = D(i, j);
        
        if abs(i - j) > win
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
            DC(i, j) = DC(i - 1, j - 1);
            S(i, j) = 3;
            
            if S(i, j - 1) >= 0 && DC(i, j - 1) < DC(i, j)
                DC(i, j) = DC(i, j - 1);
                S(i, j) = 1;
            end
            
            if S(i - 1, j) >= 0 && DC(i - 1, j) < DC(i, j)
                DC(i, j) = DC(i - 1, j);
                S(i, j) = 2;
            end

            DC(i, j) = DC(i, j) + d;
        end
    end
end
v = DC(n1, n2);
