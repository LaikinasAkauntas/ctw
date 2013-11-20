function Ws = aliP2W(P, ns)
% Convert warping path vector to warping path matrix.
%
% Example
%   input   -  P = [1 1; ...
%                   2 2; ...
%                   2 3; ...
%                   3 3; ...
%                   4 3; ...
%                   5 4]
%   call    -  Ws = P2W(P)
%   output  -  Ws{1} = [1 0 0 0 0 0; ...
%                       0 1 1 0 0 0; ...
%                       0 0 0 1 0 0; ...
%                       0 0 0 0 1 0; ...
%                       0 0 0 0 0 1]
%              Ws{2} = [1 0 0 0 0 0; ...
%                       0 1 0 0 0 0; ...
%                       0 0 1 1 1 0; ...
%                       0 0 0 0 0 1]
%
% Input
%   P       -  warping path vector, l x m
%   ns      -  #frames, 1 x m | []
%
% Output
%   Ws      -  warping path matrix, 1 x m (cell), ni x l
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-02-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-04-2012

% dimension
P = round(P);
[l, m] = size(P);

if ~exist('ns', 'var') || isempty(ns)
    ns = P(l, :);
end

% per column of P
Ws = cell(1, m);
for i = 1 : m
    ni = ns(i);
    Ws{i} = zeros(ni, l);
    Ws{i}(sub2ind([ni, l], P(:, i)', 1 : l)) = 1;
end
