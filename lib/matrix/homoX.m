function Xs = homoX(Xs, flag)
% Making feature be homogeneous.
%
% Input
%   Xs      -  original sample matrix, 1 x m (cell), dim x n
%   flag    -  
%
% Output
%   Xs      -  new sample matrix, 1 x m (cell), (dim + 1) x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-19-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(Xs);

for i = 1 : m
    if ~exist('flag', 'var') || flag == 1
        Xs{i} = [Xs{i}; ones(1, size(Xs{i}, 2))];
    else
        Xs{i}(end, :) = [];
    end
end
