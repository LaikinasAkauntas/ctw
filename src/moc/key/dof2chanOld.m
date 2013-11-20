function chan = dof2chanOld(skel, Dof, join)
% Conver the original Dof of each joint to its position in 3-d space.
%
% Input
%   skel    -  skeleton
%   Dof     -  Dof matrix, dim x nF
%              Notice that: dim = sum(join.dims)
%   join    -  join
%     nms   -  joint name, 1 x nJ (cell)
%     dims  -  joint DOF, 1 x nJ
%
% Output
%   chan    -  channels, nF x nC
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-26-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

fprintf('dof -> chan\n');

% joint information
nms = join.nms;
dims = join.dims;
nJ = length(nms);

% dimensionality
nF = size(Dof, 2);
nJ0 = length(skel.tree);

% joint index
loc = [1 cumsum(dims) + 1];
inds = zeros(1, nJ);
for j = 1 : nJ
    ind = strloc(nms{j}, skel.tree, 'name');
    inds(j) = ind;
end

% #joint dof
nCs = zeros(1, nJ0);
for i = 1 : nJ0
    nCs(i) = length(skel.tree(i).channels);
end
nC = sum(nCs);
chan = zeros(nF, nC);

% convert Dof to chan according to specific order
endVal = 0;
for i = 1 : nJ0
    if nCs(i) > 0
        startVal = endVal + 1;
        endVal = endVal + nCs(i);

        j = find(inds == i);
        chan(:, startVal : endVal) = Dof(loc(j) : loc(j + 1) - 1, :)';
    end
end

chan = smoothAngleChannels(chan, skel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function channels = smoothAngleChannels(channels, skel)
% Try and remove artificial discontinuities associated with angles.

for i = 1 : length(skel.tree)
    for j = 1 : length(skel.tree(i).rotInd)    
        col = skel.tree(i).rotInd(j);
        if col
            for k = 2 : size(channels, 1)
                diff = channels(k, col) - channels(k - 1, col);
                if abs(diff + 360) < abs(diff)
                    channels(k : end, col) = channels(k : end, col) + 360;
                elseif abs(diff - 360) < abs(diff)
                    channels(k : end, col) = channels(k : end, col) - 360;
                end        
            end
        end
    end
end
