function xyz = chan2xyz(skel, chan, ang)
% Compute XYZ values given skeleton structure and channels.
%
% Input
%   skel    -  skeleton
%   chan    -  joint Dofs, 1 x nC
%   ang     -  extra rotation in root (optional)
%
% Output
%   xyz     -  3-D coordinates of each joints, nF x nJ x 3
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 09-12-2010

% root rotation
rotVal = skel.tree(1).orientation;
for i = 1 : length(skel.tree(1).rotInd)
    rind = skel.tree(1).rotInd(i);
    if rind
        rotVal(i) = rotVal(i) + chan(rind);
    end
end
xyzStruct(1).rot = ang2matrix(rotVal, skel.tree(1).axisOrder);

% extra root rotation
if exist('ang', 'var')
    extRot = ang2matrix([0, ang, 0]);
    xyzStruct(1).rot = xyzStruct(1).rot * extRot;
end

% root position
xyzStruct(1).xyz = skel.tree(1).offset;
for i = 1 : length(skel.tree(1).posInd)
    pind = skel.tree(1).posInd(i);
    if pind
        xyzStruct(1).xyz(i) = xyzStruct(1).xyz(i) + chan(pind);
    end
end

% other joints' position
for i = 1 : length(skel.tree(1).children)
    ind = skel.tree(1).children(i);
    xyzStruct = getChildXyz(skel, xyzStruct, ind, chan);
end

% store
xyz = reshape([xyzStruct(:).xyz], 3, length(skel.tree))';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xyzStruct = getChildXyz(skel, xyzStruct, ind, chan)
% Computer joint position.
%
% Input
%   skel       -  skeleton
%   xyzStruct  -  joint Dofs, 1 x nC
%   ind
%   chan
%
% Output
%   xyzStruct  -  3-D coordinates of each joints, nF x nJ x 3

parent = skel.tree(ind).parent;
children = skel.tree(ind).children;
rotVal = zeros(1, 3);
for j = 1 : length(skel.tree(ind).rotInd)
    rind = skel.tree(ind).rotInd(j);
    if rind
        rotVal(j) = chan(rind);
    end
end

order = skel.tree(ind).order;
tdof = ang2matrix(rotVal, order);

C = skel.tree(ind).C;
Cinv = skel.tree(ind).Cinv;

xyzStruct(ind).rot = Cinv * tdof * C * xyzStruct(parent).rot;
xyzStruct(ind).xyz = xyzStruct(parent).xyz + (skel.tree(ind).offset * xyzStruct(ind).rot);

for i = 1 : length(children)
    xyzStruct = getChildXyz(skel, xyzStruct, children(i), chan);
end
