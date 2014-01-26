function [Pt, G, M] = imgFeatShp(wsPath, parF)
% Image shape (contour) detection / description.
%
% Input
%   wsPath
%     img   -  path of image file
%   parF    -  parameter (can be [])
%     alg   -  algorithm, 'canny' | 'mPb'
%     th    -  threshold, {0.5}
%    
% Output    
%   Pt      -  mask point, 2 x nP
%   G       -  boundary probability, h x w
%   M       -  binary mask, h x w
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-03-2012

prIn('imgFeatShp');

% function parameter
th = ps(parF, 'th', .05);

% read image
F0 = imread(wsPath.img);

% normalize pixel to [0, 1]
F = double(F0) / 255;

% mPb contour detector
[G, mPb_nmax_rsz] = multiscalePb(F);

% binary mask
M = G > th;
M = bwmorph(M, 'skel', inf);

% boundary point
Pt = maskM2P(M);
Pt(3, :) = [];

prOut;
