function ds = conDstNear2(X, Y)
% Compute nearest neighbour.
%
% Input
%   X       -  1st sample matrix, d x nX
%   Y       -  2nd sample matrix, d x nY
%
% Output
%   ds      -  minimum distance for 1st set, 1 x nX
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-23-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
nX = size(X, 2);
nY = size(Y, 2);

% parameter
if ismac
    th = 4000 * 4000;
elseif isunix
    th = 4000 * 4000;
else
    error('unknown platform');
end

% divide
co = floor(th / nY);
m = ceil(nX / co);

ds = zeros(1, nX);

p = 0;
for i = 1 : m
    if i == m
        idx = p + 1 : nX;
    else
        idx = p + 1 : p + co;
    end
    
    Di = conDst(Y, X(:, idx));
    ds(idx) = min(Di);
    
    p = p + co;
end
