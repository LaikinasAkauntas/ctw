function hs = shImps(ss, varargin)
% Show the impulse.
%
% Input
%   ss        -  set of impulses, 1 x m (cell), n x 1
%   parMk     -  parameter for marker, see function plotmk for more details
%   parChan   -  parameter
%     inCl    -  color of inactive frames, {[1 1 1] * .1}
%     cutWid  -  cut line width, {2}
%     nms     -  channel names, {[]}
%     P       -  warping path, {[]}
%     all     -  flag of showing all frames, 'y' | {'n'}
%     sca     -  scaling factor of dimension, {.8}
%     inp     -  interpolation algorithm, {'nearest'} | ... See function seqInp for more details
%   varargin
%     show option
%
% Output
%   h         -  handle for the figure
%   x1s       -  new sequence (after adjusting the range), 1 x k (cell), dim x ni
%   X2s       -  new sequence (after adjusting the range and plotting on the figure), 1 x k (cell), dim x ni
%   X3s       -  new sequence (after adjusting the range and plotting on the figure), 1 x k (cell), dim x ni
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 03-31-2009
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);
legs = ps(varargin, 'legs', []);

% function option
lnWid = ps(varargin, 'lnWid', 1);

% dimension
m = length(ss);
n = size(ss{1}, 1);

% main plot
hold on;
hs = cell(1, m);
for i = 1 : m
    s = ss{i};

    [X, Y] = zeross(3, n);
    X(1, :) = 1 : n;
    X(2, :) = 1 : n;
    X(3, :) = nan;
    Y(2, :) = s';
    Y(3, :) = nan;

    % cl
    [~, cl] = genMkCl(i);

    hs{i} = plot(X(:), Y(:), '-', 'Color', cl, 'LineWidth', lnWid);
end

if ~isempty(legs)
    legend(legs{:});
end
