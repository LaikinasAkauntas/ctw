function F = imgMask(F0, Pt, bkCl, varargin)
% Mask image.
%
% Input
%   F0      -  image, h0 x w0 x nChan (uint8)
%   Pt      -  foreground mask, 2 x nP
%   bkCl    -  background color, 1 x nChan
%   varargin
%     bd    -  flag of bounding, 'y' | {'n'}
%     hNew  -  new height, {70}
%
% Output
%   F       -  new image, h x w x nChan
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
isBd = psY(varargin, 'bd', 'n');
hNew = ps(varargin, 'hNew', 70);

% dimension
[h0, w0, nChan] = size(F0);

% background mask
M = maskP2M([h0 w0], Pt);
M2 = 1 - M;
Pt2 = maskM2P(M2);
nP2 = size(Pt2, 2);

F = F0;
for iChan = 1 : nChan
    idx = sub2ind([h0 w0 nChan], Pt2(1, :), Pt2(2, :), ones(1, nP2) * iChan);
    F(idx) = bkCl(iChan);
end

% bounding
if isBd
    box = maskBox({Pt});
    F = imgCrop(F, box);
    
    % original size
    siz0 = box(:, 2) - box(:, 1) + 1;

    % new size
    siz = floor(siz0 / scale);

    M0 = maskP2M(siz0, Pt0s{iF});
    M = imresize(M0, siz');
end
