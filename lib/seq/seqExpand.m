function X = seqExpand(X0, n)
% Sequence expansion.
%
% Input
%   X0      -  original sequence, dim x n0
%   n       -  #destined frames, {n0 * 2} | n0 * 2 - 1
%
% Output
%   X       -  new sequence, dim x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-08-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% smooth kernel
Wt = [.05 .25 .4 .25 .05];

% dimension
[dim, n0] = size(X0);
if ~exist('n', 'var')
    n = n0 * 2;
end
if n ~= n0 * 2 - 1 && n ~= n0 * 2
    error('unsupported numbers: n0 %d and n %d', n0, n);
end

X = zeros(dim, n);
m = -2 : 2;

for d = 1 : dim
    % Pad the boundaries.
    x0 = X0(d, [1 1 : n0 n0]);
    
    head = select(n == n0 * 2, 0, 1);
    for i = head : n - 1
        pixeli = (i - m) / 2 + 2; 
        idxi = find(floor(pixeli) == pixeli);
        A = x0(pixeli(idxi)) .* Wt(m(idxi) + 3);
        X(d, i + 1) = 2 * sum(A(:));
    end
end
