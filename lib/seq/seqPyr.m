function Xss = seqPyr(Xs, nH, par)
% Building a pyramid of multi-scale sequences.
%   wid = sig0 * lam ^ (nH - iH - 1)
% 
% Input
%   Xs        -  sequences, 1 x m (cell), dim x ni
%   nH        -  #level
%   par       -  parameter
%     sig0    -  sigma, {5}
%     lam     -  labmda, {1.5}
%
% Output
%   Xss       -  multi-scale sequences, nH x m (cell), dim x ni
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function parameter
sig0 = ps(par, 'sig0', 5);
lam = ps(par, 'lam', 1.5);

% dimension
m = length(Xs);

% pyramid
Xss = cellss(nH, m);

% bottom-level
for j = 1 : m
    Xss{nH, j} = Xs{j};
end

% other
for iH = 1 : nH - 1
    wid = sig0 * lam ^ (nH - iH - 1);
    for j = 1 : m
        Xss{iH, j} = seqFilter(Xs{j}, wid);
    end
end
