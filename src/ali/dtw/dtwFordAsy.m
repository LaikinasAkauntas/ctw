% function [v, S, DC] = dtwFordAsySlow(D)
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
