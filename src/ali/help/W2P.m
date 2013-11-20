function P = W2P(W)
% Convert the frame correspondance matrix to the warping matrix.
%
% Example
%   input   -  W = [1 0 0 0 0; ...
%                   0 1 0 0 0; ...
%                   0 1 1 1 0; ...
%                   0 0 0 0 1]
%   usage   -  P = W2P(W)
%   output  -  P = [1 2 3 3 3 4; ...
%                   1 2 2 3 4 5]
%
% Input
%   W       -  warping matrix, n1 x n2
%
% Output
%   C       -  frame correspondance matrix, 2 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-02-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

ind = find(W(:) > 0);
[is, js] = ind2sub(size(W), ind);
P = [is'; js'];
