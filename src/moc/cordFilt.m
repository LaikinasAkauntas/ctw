function cordF = cordFilt(cord, skel, nmFs)
% Obtain the coordinates for the selected joints.
%
% Input
%   cord    -  original coordinates, 3 x nJ x nF
%   skel    -  skeleton
%   nmFs    -  new joint names, 1 x nJF (cell)
%
% Output
%   cord    -  new coordinates, 3 x nJF x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[~, nJ, nF] = size(cord);
nJF = length(nmFs);

% index of selected joints
idx = zeros(1, nJF);
for i = 1 : nJF
    idx(i) = strloc(nmFs{i}, skel.tree, 'name');
end

% filtering
cordF = cord(:, idx, :);
