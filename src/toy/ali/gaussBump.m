function x = gaussBump(n, mes, vars)
% Generate a line with gaussian bump.
%
% Input
%   n       -  line length
%   mes     -  mean of gaussian on line, 1 x m
%   vars    -  variance of gaussian on line, 1 x m
%
% Output
%   x       -  feature of line, 1 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-04-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

m = length(mes);

X = zeros(m, n);
x0 = 1 : n;
for i = 1 : m
    me = mes(i);
    var = vars(i);
    
    if isinf(var)
        X(i, :) = 1;
    else
        X(i, :) = exp(-(x0 - me) .^ 2 / (2 * var ^ 2));
    end
end

if m == 0
    m = m + 1;
end
x = sum(X, 1) / m;
