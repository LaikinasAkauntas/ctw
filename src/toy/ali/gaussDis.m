function y = gaussDis(x, me, var)
% Obtain the value of gaussian function at the specific discrete places.
%
% Input
%   x       -  positions, 1 x m
%   me      -  mean of gaussian function
%   var     -  variance of gaussian function, if not indicated, using the half of maximum distance of x from me
%
% Output
%   y       -  function value, 1 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

if ~exist('var', 'var')
    var = max(abs(x - me)) / 2;
end

y = exp(-(x - me) .^ 2 / (2 * var ^ 2));
y = y ./ sum(y);
