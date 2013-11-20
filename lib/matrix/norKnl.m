function K = norKnl(K0)
% Normalize the kernel matrix.
%
% Input
%   K0      -  original kernel matrix, n x n
%
% Output
%   K       -  new kernel matrix, dim x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-23-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

de2 = sqrt(sum(K0, 2));
K = K0 ./ (de2 * de2');
