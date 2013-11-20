function ds = conDstNear3(X, Y)
% Compute nearest neighbour using KD-tree.
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
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2012

% dimension
nX = size(X, 2);
nY = size(Y, 2);

% create kd-tree
tree = kdtree(Y');

% close point
ds = zeros(1, nX);
for i = 1 : nX
    p = kdtree_closestpoint(tree, X(:, i)');
    ds(i) = sum((Y(:, p) - X(:, i)) .^ 2);
end
