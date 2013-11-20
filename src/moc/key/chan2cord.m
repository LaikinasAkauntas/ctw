function [cord, conn] = chan2cord(skel, chan, angs, idx)
% Parse the channels of each joint to obtain their coordinates and attached bones.
%
% Input
%   skel    -  skeleton
%   chan    -  joint channels, nC x nF
%   angs    -  relative rotation that needed be applied on joints, 1 x nF | []
%   idx     -  index of frames, 1 x nF | []
%
% Output
%   cord    -  3-D joint coordinates, 3 x nJ x nF
%   conn    -  the joint connection, 2 x nB
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn('chan2cord');

% dimension
nF = size(chan, 2);
nJ = length(skel.tree);

% additional rotation from outside
[angys, angrs] = zeross(1, nF);
if nargin > 2 && ~isempty(angs) && ~isempty(idx)
    for i = 1 : nF
        angys(i) = rootAngY(skel, chan(:, i));
        angrs(i) = -angys(i) + angys(idx(i)) - angs(i);
    end
end

% coordinate for each joint
cord = zeros(3, nJ, nF);
prCIn('frame', nF, .1);
for i = 1 : nF
    prC(i);
    cord(:, :, i) = chan2xyz(skel, chan(:, i), angrs(i));
end
prCOut(nF);

% connection of joint
Vis = zeros(nJ, nJ);
for i = 1 : nJ
    for j = 1 : length(skel.tree(i).children)    
        Vis(i, skel.tree(i).children(j)) = 1;
    end
end
indices = find(Vis);
nB = size(indices, 1);
conn = zeros(2, nB);
[conn(1, :), conn(2, :)] = ind2sub([nJ, nJ], indices);

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function angy = rootAngY(skel, chan)
% Parse the angles of root.
%
% Input
%   skel  -  skeleton components
%   chan  -  joint components, nC x 1
%
% Output
%   angy  -  root angle

rotVal = skel.tree(1).orientation;
for i = 1 : length(skel.tree(1).rotInd)
    rind = skel.tree(1).rotInd(i);
    if rind
        rotVal(i) = rotVal(i) + chan(rind);
    end
end

% root rotation
rot = ang2mat(rotVal, skel.tree(1).axisOrder);

% original rotation
ang0 = SpinCalc('DCMtoEA132', rot, eps, 0);
angy = ang0(end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xyz = chan2xyz(skel, chan, ang)
% Compute XYZ values given skeleton structure and channels.
%
% Input
%   skel  -  skeleton
%   chan  -  joint Dofs, nC x 1
%   ang   -  additional rotation in root (optional)
%
% Output
%   xyz   -  3-D coordinates of each joints, 3 x nJ

% dimension
nJ = length(skel.tree);
xyz = zeros(3, nJ);
rot = zeros(3, 3, nJ);

root = skel.tree(1);

% root rotation
rotVal = root.orientation';
idx = find(root.rotInd);
rotVal(1 : length(idx)) = rotVal(1 : length(idx)) + chan(root.rotInd(idx));
rot(:, :, 1) = ang2mat(rotVal, root.axisOrder);

% extra root rotation
if exist('ang', 'var')
    extRot = ang2mat([0, ang, 0]);
    rot(:, :, 1) = rot(:, :, 1) * extRot;
end

% root position
xyz(:, 1) = root.offset';
idx = find(root.posInd);
xyz(1 : length(idx), 1) = xyz(1 : length(idx), 1) + chan(root.posInd(idx));

% other joints' position
for i = 1 : length(root.children)
    ind = root.children(i);
    [xyz, rot] = getChild(skel, xyz, rot, ind, chan);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xyz, rot] = getChild(skel, xyz, rot, ind, chan)
% Compute joint coordinate for the child.
%
% Input
%   skel  -  skeleton
%   xyz   -  coordinates, 3 x nJ
%   rot   -  rotation matrix, 3 x 3 x nJ
%   ind   -  index of current joint
%   chan  -  joint Dofs, nC x 1
%
% Output
%   xyz   -  coordinates, 3 x nJ
%   rot   -  rotation matrix, 3 x 3 x nJ

% node
node = skel.tree(ind);

% index
parent = node.parent;
children = node.children;

% Euler angle
rotVal = zeros(1, 3);
idx = find(node.rotInd);
rotVal(1 : length(idx)) = chan(node.rotInd(idx));

% rotation matrix
Rot = ang2mat(rotVal, node.order);
rot(:, :, ind) = node.Cinv * Rot * node.C * rot(:, :, parent);

% offset
xyz(:, ind) = xyz(:, parent) + rot(:, :, ind)' * node.offset';

% other joints' position
for i = 1 : length(children)
    [xyz, rot] = getChild(skel, xyz, rot, children(i), chan);
end
