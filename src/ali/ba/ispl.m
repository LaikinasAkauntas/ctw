function [I, M] = ispl(x, knots, k)
% I-spline.
%
% Input
%   x       -  value, nP x 1
%   knots   -  knot, nK x 1
%   k       -  order of spline
%
% Output
%   I       -  function value of I-spline, nP x (nK + k)
%   M       -  function value of M-spline, nP x (nK + k)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

k = k + 1;

% basis
nP = length(x);
nK = length(knots);
n = nK + k;
t = [zeros(k, 1); knots(:); ones(k, 1)];

% M-spline
% k = 0
Ms = zeros(nP, n + 1, k);
for i = 1 : n
    pos = intersect(find(t(i) <= x), find(x < t(i + 1)));
    Ms(pos, i, 1) = 1 / (t(i + 1) - t(i));
end

for c = 2 : k
    for i = 1 : n
        pos = intersect(find(t(i) <= x), find(x < t(i + c)));
        aa = (x(pos) - t(i)) .* Ms(pos, i, c - 1) + (t(i + c) - x(pos)) .* Ms(pos, i + 1, c - 1);
        Ms(pos, i, c) = aa * c / ((c - 1) * (t(i + c) - t(i)));
    end
end
M = Ms(:, 2 : end - 1, k - 1);

% check the last value
for c = 1 : size(M, 2)
    if M(end - 2, c) <= M(end - 1, c) && M(end - 1, c) > M(end, c)
        M(end, c) = M(end - 1, c);
    end
end

% I-spline
Is = zeros(nP, n + 1, k - 1);
js = zeros(1, nP);
for iP = 1 : nP
    for j = 1 : n
        if t(j) <= x(iP) && x(iP) < t(j + 1)
            js(iP) = j;
            break;
        end
    end
end

for c = 1 : k - 1
    for i = 1 : n
        for iP = 1 : nP
            j = js(iP);
            
            if i > j
            elseif j - c + 1 <= i && i <= j
                for m = i : j
                    Is(iP, i, c) = Is(iP, i, c) + (t(m + c + 1) - t(m)) * Ms(iP, m, c + 1) / (c + 1);
                end
            elseif i < j - c + 1
                Is(iP, i, c) = 1;
            else
                error('unknown area');
            end
        end
    end
end

I = Is(:, 2 : end - 1, k - 1);

% check the last value
for c = 1 : size(I, 2)
    if I(end - 1, c) > I(end, c)
        I(end, c) = I(end - 1, c);
    end
end
