function p = tranTemLn(ts, ns)
% Generate parameter of temporal transformation.
%
% Input
%   ts      -  original segment lengths, 1 x m
%   ns      -  new segment lengths, 1 x m
%
% Output
%   p       -  warping path vector, n x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

m = length(ts);
n = sum(ns);

p = zeros(n, 1);
head0 = 0;
head = 0;
for i = 1 : m
    idx = 1 : ns(i);
    p(head + idx) = head0 + round(ts(i) / ns(i) * idx');
    head0 = head0 + ts(i);
    head = head + ns(i);
end
