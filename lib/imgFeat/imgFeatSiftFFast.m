function [Det, Des] = imgFeatSiftFFast(F, scale)
% Obtain SIFT feature with specified position.
%
% Input
%   F0       -  original image
%   Det0     -  specified position, 4 x n
%                 Det0(1 : 2, :): point position
%                 Det0(3, :)    : scale
%                 Det0(4, :)    : orientation
%   parF     -  feature parameter
%     ori    -  flag of using specified orientation (ie, Det0(4, :)), {'y'} | 'n'
%     dstMi  -  minimum distance threshold, {eps}
%                 At each position, there might be more than one dominated
%                 orientations. In order to keep only one of them, we can 
%                 use this parameter.
%     deb    -  flag of debugging, 'y' | {'n'}
%            
% Output
%   Det      -  detector, 4 x n
%   Des      -  descriptor, 128 x n (single)
%
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 06-01-2012
%   modify   -  Feng Zhou (zhfe99@gmail.com), 06-25-2012

% function parameter
prIn('imgFeatSiftFFast', 'scale %f', scale);

% rgb -> gray (single)
if size(F, 3) > 1
    F1 = rgb2gray(F);
else
    F1 = F;
end
F1 = single(F1);

% detect SIFT
F2 = vl_imsmooth(F1, scale / 3);
step = 1;
[Det, Des] = vl_dsift(F2, 'Fast', 'Step', step, 'size', scale);

prOut;
