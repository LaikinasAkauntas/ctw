function ha = shMocG(cord, varargin)
% Show the underground of a mocap sequence.
%
% Input
%   cord     -  2-D coordinates of all joints, 3 x nJ x nF
%   varargin
%     show option
%     box0   -  predefined 3-D bounding box, {[]}
%     vwAgl  -  view angle, {[15 30]}
%     gnd    -  flag of showing underground, {'y'} | 'n'
%     clGnd  -  color of underground, [0 0 0] + .5
%
% Output
%   ha       -  handler
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
box0 = ps(varargin, 'box0', []);
vwAgl = ps(varargin, 'vwAgl', [15 30]);
isGnd = psY(varargin, 'gnd', 'y');
clGnd = ps(varargin, 'clGnd', [0 0 0] + .8);

% bounding box
if isempty(box0)
    box = cordBox(cord, []);
else
    box = box0;
end
ha.box = box;

% axis
hold on;
axis ij;
grid off;
axis equal;
set(gca, 'xlim', box(1, :), 'ylim', box(2, :), 'zlim', box(3, :));
view(vwAgl);

% plot the underground
if isGnd
    fill3([box(1, 1), box(1, 2), box(1, 2), box(1, 1)], ...
          [box(2, 1), box(2, 1), box(2, 2), box(2, 2)], ...
          [box(3, 1), box(3, 1), box(3, 1), box(3, 1)], clGnd, 'EdgeColor', 'none');
end
axis off;
