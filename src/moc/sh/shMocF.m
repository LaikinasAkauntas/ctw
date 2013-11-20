function ha = shMocF(cord, conn, skel, varargin)
% Show one mocap frame.
%
% Input
%   cord     -  3-D coordinates of joint, 3 x nJ
%   conn     -  joints that bone connect, 2 x nB
%   skel     -  skeleton
%   varargin
%     show option
%     key    -  whether the current frame is a key-frame or not, {'y'} | 'n'
%     cl     -  color, {'b'}
%     lnWid  -  line width, {1.5}
%     nkSiz  -  neck joint width, {8}
%
% Output
%   ha       -  handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% show option
psSh(varargin);

% function option
isKey = psY(varargin, 'key', 'y');
cl = ps(varargin, 'cl', 'b');
lnWid = ps(varargin, 'lnWid', 1.5);
nkSiz = ps(varargin, 'nkSiz', 8);

hold on;

% keyframe
if ~isKey
    lnWid = lnWid - .5;
end

% joint connection
nB = size(conn, 2);
na = nan(1, nB);
xB = [cord(1, conn(1, :)); ...
      cord(1, conn(2, :)); ...
      na];
yB = [cord(3, conn(1, :)); ...
      cord(3, conn(2, :)); ...
      na];
zB = [cord(2, conn(1, :)); ...
      cord(2, conn(2, :)); ...
      na];

% do not show the head joint because it is ugly
headJ = strloc('head', skel.tree, 'name');
headConn = 0;
for i = 1 : size(conn, 2)
    if any(conn(:, i) == headJ)
        headConn = i;
        break;
    end
end
if headConn ~= 0
    xB(:, headConn) = [];
    yB(:, headConn) = [];
    zB(:, headConn) = [];
end

% plot connection of joints as lines
if lnWid > 0
    hConn = plot3(xB(:), yB(:), zB(:), '-', 'Color', cl, 'LineWidth', ...
                  lnWid);
end

% plot neck as a large ball
neckJ = strloc('upperneck', skel.tree, 'name');
if neckJ == 0
    neckJ = strloc('neck', skel.tree, 'name');
end
if neckJ ~= 0
    hNeck = plot3(cord(1, neckJ), cord(3, neckJ), cord(2, neckJ), ...
                  'o', 'MarkerFaceColor', cl, 'MarkerEdgeColor', ...
                  cl, 'MarkerSize', nkSiz);
end

% store
ha.conn = conn;
ha.headConn = headConn;
ha.hConn = hConn;
ha.neckJ = neckJ;
ha.hNeck = hNeck;
