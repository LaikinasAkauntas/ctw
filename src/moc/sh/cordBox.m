function box = cordBox(cord, seg)
% Obtain the bounding box of a mocap sequence.
%
% Input
%   cord    -  coordinate, 3 x nJ x nF
%   seg     -  segmentation (can be [])
%
% Output
%   box     -  bounding box, 3 x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-05-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% boundary
box = zeros(3, 2);
X = cord(1, :, :); 
Y = cord(3, :, :); 
Z = cord(2, :, :);
box(1, :) = [min(X(:)), max(X(:))];
box(2, :) = [min(Y(:)), max(Y(:))];
box(3, :) = [min(Z(:)), max(Z(:))];

% segmentation
if nargin > 1 && ~isempty(seg) && isfield(seg, 's')
    box(3, 2) = box(3, 2) + 10;
end
