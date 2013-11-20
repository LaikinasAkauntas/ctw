function PBds = dtwS2Bd(S)
% Extract the boundary from step matrix.
%
% Input
%   S       -  step matrix, n1 x n2
%
% Output
%   PBds    -  path boundary, 1 x 2 (cell), l x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[n1, n2] = size(S);

PBds = cell(1, 2);

% left
P = zeros(n1 + n2, 2);
i = 1;
j = 1;
l = 1;
P(l, :) = [i j];
while i ~= n1 || j ~= n2
    
    if i < n1 && S(i + 1, j) >= 0
        i = i + 1;
    elseif i < n1 && j < n2 && S(i + 1, j + 1) >= 0
        i = i + 1;
        j = j + 1;
    elseif j < n2 && S(i, j + 1) >= 0
        j = j + 1;
    else
        error('unknown place');
    end
    
    l = l + 1;
    P(l, :) = [i j];
end
PBds{1} = P(1 : l, :);

% right
P = zeros(n1 + n2, 2);
i = 1;
j = 1;
l = 1;
P(l, :) = [i j];
while i ~= n1 || j ~= n2
    
    if j < n2 && S(i, j + 1) >= 0
        j = j + 1;
    elseif i < n1 && j < n2 && S(i + 1, j + 1) >= 0
        i = i + 1;
        j = j + 1;
    elseif i < n1 && S(i + 1, j) >= 0
        i = i + 1;
    else
        error('unknown place');
    end
    
    l = l + 1;
    P(l, :) = [i j];
end
PBds{2} = P(1 : l, :);

