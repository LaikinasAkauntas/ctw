function p = tranTemRand(algs, ts, ns, ks, bs)
% Generate parameter of temporal transformation.
%
% Input
%   ts      -  original segment lengths, 1 x m
%   ns      -  new segment lengths, 1 x m
%
% Output
%   p       -  warping path vector, t x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

m = length(ts);
t = sum(ts);

p = zeros(t, 1);

headT = 0;
headN = 0;
for i = 1 : m
    idx = 1 : ts(i);

    % basis
    P = baTem(algs{i}, ts(i), ns(i), ks(i), bs(i));

    % randomly pick one
    c = float2block(rand(1), ks(i));
    p(headT + idx) = P(:, c) + headN;
    
    headT = headT + ts(i);
    headN = headN + ns(i);
end
