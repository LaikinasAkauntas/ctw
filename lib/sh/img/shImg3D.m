function ha = shImg3D(F, iF, varargin)
% Show image in 3-D.
%
% Input
%   F       -  image
%   iF      -  frame index
%   varargin
%     show option
%
% Output
%   ha      -  handle
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-13-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% dimension
siz = imgInfo(F);

F = imgFlip(F, 'vert');

% position
F = im2double(F);
xs = 1 : siz(2);
zs = 1 : siz(1);
[X, Z] = meshgrid(xs, zs);
Y = zeros(siz(1), siz(2)) + iF;

% plot image
hImg = surface('XData', X, 'YData', Y, 'ZData', Z, ...
               'CData', F, 'EdgeColor', 'none');

% store
ha.siz = siz;
ha.hImg = hImg;
