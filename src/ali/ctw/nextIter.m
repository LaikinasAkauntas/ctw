function [a, iter] = nextIter(a0, dent, val)
% Obtain the next iteration.
%
% Input
%   a0      -  iteration string in the last step
%   dent    -  coordinate-descent method, 'order' | 'rand' | 'domi'
%   val     -  probability used when dent == 'domi'
%
% Output
%   a       -  new iteration string
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

iter0 = a2it(a0);
if strcmp(dent, 'order')
    iter = mod(iter0 + 1, 3); 
    if iter == 0
        iter = 3;
    end

elseif strcmp(dent, 'rand')
    iter = float2block(rand(1), 3);
    while iter == iter0
        iter = float2block(rand(1), 3);
    end
    

elseif strcmp(dent, 'domi')
    iter = domiIter(iter0, val);

else
    error('unknown desent method');
end
a = it2a(iter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function iter = domiIter(iter0, p)

% mode 1
as = [2 * p, 1, 2 * (1 - p)] / 3;
% as = [.5 .4 0.1];
as = as / sum(as);

A = [as(1), -as(2), 0; ...
     as(1),  0, as(3); ...
     0, as(2), -as(3)];
b = [0; ...
    as(1); ...
    as(2) - as(3)];

x = A \ b;

% mode 2
% x = [.5 p .5];

if iter0 == 1
    if rand(1) <= x(1)
        iter = 2;
    else
        iter = 3;
    end
end

if iter0 == 2
    if rand(1) <= x(2)
        iter = 1;
    else
        iter = 3;
    end
end

if iter0 == 3
    if rand(1) <= x(3)
        iter = 1;
    else
        iter = 2;
    end
end
