function skel = asf2skel(fname)
% Parse the asf file to obtain the skel struct.
%
% Input
%   fname   -  asf file path
%
% Output
%   skel    -  skel struct
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn('asf2skel');

% open
fid = fopen(fname, 'rt');
if fid == -1
    error('can not open file: %s', fname);
end;

boneCount = 0;
lin = strtrim(getline(fid));

% default
skel.length = 1.0; 
skel.mass = 1.0; 
skel.angle = 'deg'; 
skel.type = 'acclaim';
skel.documentation = ''; 
skel.name = fname;

% parse
while ~feof(fid)
    if lin(1) ~= ':'
        error('Unrecognised file format');
    end

    switch lin(2 : end)
    case 'name'
        lin = getline(fid);
        lin = strtrim(lin);
        skel.name = lin;

    case 'units'
        lin = getline(fid);
        lin = strtrim(lin);
        while lin(1) ~= ':'
            parts = tokenise(lin, ' ');
            switch parts{1}
            case 'mass'
                skel.mass = atof(parts{2});
            case 'length'
                skel.length = atof(parts{2});
            case 'angle'
                skel.angle = strtrim(parts{2});
            end
            lin = getline(fid);
            lin = strtrim(lin);
        end

    case 'documentation'
        skel.documentation = [];
        lin = getline(fid);
        while lin(1) ~=':'
            skel.documentation = [skel.documentation char(13) lin];
            lin = getline(fid);
        end
        lin = strtrim(lin);

    case 'root'
        skel.tree(1) = newTree(1);
        lin = getline(fid);
        lin = strtrim(lin);
        while lin(1) ~= ':'
            parts = tokenise(lin, ' ');
            l = length(parts);

            switch parts{1}
            case 'order'
                order = [];
                for i = 2 : l
                    switch lower(parts{i})
                    case 'rx'
                        chan = 'Xrotation';
                        order = [order 'x'];
                    case 'ry'
                        chan = 'Yrotation';
                        order = [order 'y'];
                    case 'rz'
                        chan = 'Zrotation';
                        order = [order 'z'];
                    case 'tx'
                        chan = 'Xposition';
                    case 'ty'
                        chan = 'Yposition';
                    case 'tz'
                        chan = 'Zposition';
                    case 'l'
                        chan = 'length';
                    end
                    skel.tree(boneCount + 1).channels{i - 1} = chan;
                end

                % order is reversed compared to bvh
                skel.tree(boneCount + 1).order = order(end : -1 : 1);

            case 'axis'
                % order is reversed compared to bvh
                skel.tree(1).axisOrder = lower(parts{2}(end : -1 : 1));

            case 'position'
                skel.tree(1).offset = atofs(parts(2 : 4));

            case 'orientation'
                skel.tree(1).orientation = atofs(parts(2 : 4));
            end
            lin = getline(fid);
            lin = strtrim(lin);
        end

    case 'bonedata'
        lin = getline(fid);
        lin = strtrim(lin);
        while lin(1) ~= ':'
            parts = tokenise(lin, ' ');
            l = length(parts);

            switch parts{1}
            case 'begin'
                boneCount = boneCount + 1;
                skel.tree(boneCount + 1) = newTree(0);
                lin = getline(fid);
                lin = strtrim(lin);

            case 'id'
                skel.tree(boneCount + 1).id = atof(parts{2});
                skel.tree(boneCount + 1).children = [];
                lin = getline(fid);
                lin = strtrim(lin);

            case 'name'
                skel.tree(boneCount + 1).name = parts{2};
                lin = getline(fid);
                lin = strtrim(lin);

            case 'direction'
                direction = atofs(parts(2 : 4));
                lin = getline(fid);
                lin = strtrim(lin);

            case 'length'
                lgth = atof(parts{2});
                lin = getline(fid);
                lin = strtrim(lin);

            case 'axis'
                skel.tree(boneCount + 1).axis = atofs(parts(2 : 4));

                % order is reversed compared to bvh
                skel.tree(boneCount + 1).axisOrder = lower(parts{end}(end: -1 : 1));
                lin = getline(fid);
                lin = strtrim(lin);

            case 'dof'
                order = [];
                for i = 2 : l           
                    switch parts{i}
                    case 'rx'
                        chan = 'Xrotation';
                        order = [order 'x'];
                    case 'ry'
                        chan = 'Yrotation';
                        order = [order 'y'];
                    case 'rz'
                        chan = 'Zrotation';
                        order = [order 'z'];
                    case 'tx'
                        chan = 'Xposition';
                    case 'ty'
                        chan = 'Yposition';
                    case 'tz'
                        chan = 'Zposition';
                    case 'l'
                        chan = 'length';
                    end
                    skel.tree(boneCount + 1).channels{i - 1} = chan;
                end

                % order is reversed compared to bvh
                skel.tree(boneCount + 1).order = order(end : -1 : 1);
                
                lin = getline(fid);
                lin = strtrim(lin);
            case 'limits'
                limitsCount = 1;
                skel.tree(boneCount + 1).limits(limitsCount, 1 : 2) = [atof(parts{2}(2 : end)) atof(parts{3}(1 : end - 1))];

                lin = getline(fid);
                lin = strtrim(lin);
                while ~strcmp(lin, 'end')
                    parts = tokenise(lin, ' ');

                    limitsCount = limitsCount + 1;
                    skel.tree(boneCount + 1).limits(limitsCount, 1 : 2) = [atof(parts{1}(2 : end)) atof(parts{2}(1 : end - 1))];
                    lin = getline(fid);
                    lin = strtrim(lin);
                end

            case 'end'
                skel.tree(boneCount + 1).offset = direction * lgth;
                lin = getline(fid);
                lin = strtrim(lin);
            end
        end

    case 'hierarchy'
        lin = getline(fid);
        lin = strtrim(lin);
        while ~strcmp(lin, 'end')
            parts = tokenise(lin, ' ');
            if ~strcmp(lin, 'begin')
                ind = strloc(parts{1}, skel.tree, 'name');
                for i = 2:length(parts)
                    skel.tree(ind).children = [skel.tree(ind).children strloc(parts{i}, skel.tree, 'name');];
                end        
            end
            lin = getline(fid);
            lin = strtrim(lin);
        end

        if feof(fid)
            break;
        end

    otherwise
        if feof(fid)
            break;
        end
        lin = getline(fid);
        lin = strtrim(lin);
    end
end
skel = finaliseStructure(skel);

% get indices from the channels
nJ0 = length(skel.tree);
startVal = 1;
for i = 1 : nJ0
    nCi = length(skel.tree(i).channels);

    [skel.tree(i).rotInd, skel.tree(i).posInd] = resolveIndices(skel.tree(i).channels, startVal);
    
    startVal = startVal + nCi;
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rotInd, posInd] = resolveIndices(channels, startVal)
% Get indices from the channels.

rotInd = zeros(1, 3);
posInd = zeros(1, 3);
for i = 1 : length(channels)
    switch channels{i}
    case 'Xrotation'
        rotInd(1, 1) = startVal - 1 + i;
    case 'Yrotation'
        rotInd(1, 2) = startVal - 1 + i;
    case 'Zrotation'
        rotInd(1, 3) = startVal - 1 + i;
    case 'Xposition'
        posInd(1, 1) = startVal - 1 + i;
    case 'Yposition'
        posInd(1, 2) = startVal - 1 + i;
    case 'Zposition'
        posInd(1, 3) = startVal - 1 + i;
    end        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function skel = finaliseStructure(skel)
% Modify the tree.

skel.tree = treeFindParents(skel.tree);

ordered = false;
while ordered == false
    for i = 1 : length(skel.tree)
        ordered = true;
        if skel.tree(i).parent > i
            ordered = false;
            skel.tree = swapNode(skel.tree, i, skel.tree(i).parent);
        end
    end
end

% rotation matrix
for i = 1 : length(skel.tree)
    order = skel.tree(i).axisOrder;
    skel.tree(i).C = ang2mat(skel.tree(i).axis, order);
    skel.tree(i).Cinv = inv(skel.tree(i).C);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tree = treeFindParents(tree)
% Given a tree that lists only children, add parents.
%
% Input
%	tree  -  a tree that lists parents and children.
%
% Output
%	tree  -  a tree that lists parents and children.

for i = 1 : length(tree)
    for j = 1 : length(tree(i).children)
        if tree(i).children(j)
            tree(tree(i).children(j)).parent = [tree(tree(i).children(j)).parent i];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tree = newTree(isRoot)
% Create a tree node.

if isRoot
    name = 'root';
    id = 0;
    parent = 0;

else
    name = [];
    id = [];
    parent = [];
end

tree = struct('name', name, ...
              'id', id, ...
              'offset', [], ...
              'orientation', [], ...
              'axis', [0 0 0], ...
              'axisOrder', [], ...
              'C', eye(3), ...
              'Cinv', eye(3), ...
              'channels', [], ...
              'bodymass', [], ...
              'confmass', [], ...
              'parent', parent, ...
              'order', [], ...
              'rotInd', [], ...
              'posInd', [], ...
              'children', [], ...
              'limits', []);
