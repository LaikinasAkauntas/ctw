function P = baTemCmb(bas, a)
% Obtain the combination of monotonic functions.
%
% Input
%   bas     -  basis, 1 x m (cell), l x ki
%   a       -  weight, k x 1
%
% Output
%   P       -  monotonic function, l x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-26-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(bas);
Ps = cellFld(bas, 'cell', 'P');
ks = cellDim(Ps, 2);
l = size(Ps{1}, 1);

% weight
as = mdiv('vert', a, ks);

% combine
P = zeros(l, m);
for i = 1 : m
    P(:, i) = Ps{i} * as{i};
end
