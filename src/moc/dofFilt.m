function DofF = dofFilt(Dof, join, nmFs)
% Obtain the DOF for the selected joints.
%
% Input
%   Dof     -  DOF matrix before filtering, dim (= sum(join.dims)) x nF
%   join    -  joints before filtering
%     dims  -  DOF of each joint, 1 x nJ
%     nms   -  joint name, 1 x nJ (cell)
%   nmFs    -  new joint names, 1 x nJF (cell)
%
% Output
%   DofF    -  DOF matrix after filtering, dim (= 3 x nJF) x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
nF = size(Dof, 2);
nJF = length(nmFs);

% original joints
[nms, dims] = stFld(join, 'nms', 'dims');

% dimensions
nJ = length(dims);
s = n2s(dims);

% index of selected joints
idx = zeros(1, nJF);
for i = 1 : nJF
    for j = 1 : nJ
        if strcmpi(nmFs{i}, nms{j})
            idx(i) = j;
            break;
        end
    end
end

% filtering
DofF = zeros(nJF * 3, nF);
for i = 1 : nJF
    p = idx(i);
    d = dims(p);
    if strcmp(nms{p}, 'root')
        d = 3;
        DofF((i - 1) * 3 + 1 : (i - 1) * 3 + d, :) = Dof(s(p) + 3 : s(p) + 5, :);
    else
        DofF((i - 1) * 3 + 1 : (i - 1) * 3 + d, :) = Dof(s(p) : s(p) + d - 1, :);
    end
end
