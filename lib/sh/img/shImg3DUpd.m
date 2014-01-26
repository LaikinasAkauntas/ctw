function shImg3DUpd(ha, F, iF)
% Update image in 3-D.
%
% Input
%   ha      -  handle
%   F       -  image
%   iF      -  frame index
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
siz = ha.siz;

F = imgFlip(F, 'vert');

% position
F = im2double(F);
xs = 1 : siz(2);
zs = 1 : siz(1);
[X, Z] = meshgrid(xs, zs);
Y = zeros(siz(1), siz(2)) + iF;

% plot image
set(ha.hImg, 'XData', X, 'YData', Y, 'ZData', Z, ...
             'CData', F, 'EdgeColor', 'none');
