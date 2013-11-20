function chan = dof2chan(skel, Dof, join)
% Convert DOF to 3-D coordinates for each joint.
%
% Input
%   skel    -  skeleton
%   Dof     -  Dof matrix, dim (= sum(join.dims)) x nF
%   join
%     nms   -  joint name, 1 x nJ (cell)
%     dims  -  joint dimension, 1 x nJ
%
% Output
%   chan    -  channels, nC x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-26-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn('dof2chan');

% joint information
nms = join.nms;
dims = join.dims;
nJ = length(nms);

% dimension
nF = size(Dof, 2);
nJ0 = length(skel.tree);

% joint index
loc = [1 cumsum(dims) + 1];
inds = zeros(1, nJ);
for j = 1 : nJ
    ind = strloc(nms{j}, skel.tree, 'name');
    inds(j) = ind;
end

% #joint's dof
nCs = zeros(1, nJ0);
for i = 1 : nJ0
    nCs(i) = length(skel.tree(i).channels);
end
nC = sum(nCs);
chan = zeros(nC, nF);

% convert Dof to channels according to the specific order
endVal = 0;
for i = 1 : nJ0
    if nCs(i) > 0
        startVal = endVal + 1;
        endVal = endVal + nCs(i);

        j = find(inds == i);
        chan(startVal : endVal, :) = Dof(loc(j) : loc(j + 1) - 1, :);
    end
end

chan = smoothAngleChannels(chan, skel);

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chan = smoothAngleChannels(chan, skel)
% Try to remove artificial discontinuities associated with angles.
%
% Input
%   chan  -  nC x nF
%   skel  -  skel
%
% Output
%   chan  -  nC x nF

% dimension
nF = size(chan, 2);

for i = 1 : length(skel.tree)
    for j = 1 : length(skel.tree(i).rotInd)    
        col = skel.tree(i).rotInd(j);
        if col
            for k = 2 : nF
                diff = chan(col, k) - chan(col, k - 1);
                if abs(diff + 360) < abs(diff)
                    chan(col, k : end) = chan(col, k : end) + 360;
                elseif abs(diff - 360) < abs(diff)
                    chan(col, k : end) = chan(col, k : end) - 360;
                end        
            end
        end
    end
end
