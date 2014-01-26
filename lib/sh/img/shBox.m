function ha = shBox(box, varargin)
% Plot box in 2-D.
%
% Input
%   box      -  box, 2 x 2
%   varargin
%     show option
%     lnWid  -  line width, {1}
%
% Output
%   ha
%     haBox  -  handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 07-10-2012
%   modify   -  Feng Zhou (zhfe99@gmail.com), 07-10-2012

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 1);

% box boundary
miY = box(1, 1);
maY = box(1, 2);
miX = box(2, 1);
maX = box(2, 2);
xs = [miX maX maX miX miX];
ys = [miY miY maY maY miY];

% plot
hold on;
haBox = plot(xs, ys, '-', 'linewidth', lnWid);

% store
ha.haBox = haBox;
