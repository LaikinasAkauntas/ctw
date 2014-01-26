function Pts = maskRmTor(Pt0s, varargin)
% Remove the torso of the mask.
%
% Input
%   Pt0s    -  old mask, 1 x nF (cell)
%   varargin
%     visT  -  visible parts, {[1 0 1; 1 0 1; 1 1 1]}
%
% Output
%   Pt      -  new mask, 1 x nF (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
visT = ps(varargin, 'visT', [1 0 1; 1 0 1; 1 1 1]);

% size
nF = length(Pt0s);
nPs = cellDim(Pt0s, 2);
siz0s = maskSiz(Pt0s);

% average height
h = mean(siz0s(1, :));
w = .5 * h;

% 3 x 3 grid
hAve = h * .3;
wAve = w * .3;

% evaluate each point
Pts = cell(1, nF);
for iF = 1 : nF
    
    Pt0 = Pt0s{iF}; 
    nP = nPs(iF);
    
    % align the center of each frame
    center = sum(Pt0, 2) / nP;
    
    visP = zeros(1, nP);
    for iP = 1 : nP
        [r, c] = inGrid(Pt0(:, iP), center, [hAve, wAve]);
        visP(iP) = visT(r, c);
    end
    Pts{iF} = Pt0(:, visP > 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r, c] = inGrid(p, center, sizAve)
% Determine which grid the point falls in.
%
% Input
%   p       -  point's position, 2 x 1
%   center  -  grid center, 2 x 1
%   sizAve  -  average grid size, 2 x 1
%
% Output
%   r
%   c

if p(1) < center(1) - sizAve(1) * .8
    r = 1;
elseif p(1) < center(1) + sizAve(1) * .5
    r = 2;
else
    r = 3;
end

if p(2) < center(2) - sizAve(2) * .6
    c = 1;
elseif p(2) < center(2) + sizAve(2) * .6
    c = 2;
else
    c = 3;
end
    
