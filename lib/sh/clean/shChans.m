function h = shChans(Xs, parMk, parChan, varargin)
% Show each channel (dimension) of the given sequences.
%
% Input
%   Xs        -  set of sequences, 1 x m (cell), dim x ni
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
P = ps(parChan, 'P', []);
isAll = psY(parChan, 'all', 'n');
sca = ps(parChan, 'sca', .8);
cutWid = ps(parChan, 'cutWid', 1);
gapWid = ps(parChan, 'gapWid', 0);
nms = ps(parChan, 'nms', []);
inp = ps(parChan, 'inp', 'nearest');

% dimension
m = length(Xs);
ns = cellDim(Xs, 2);
dim = size(Xs{1}, 1);

% alignment
xs = cellss(1, m);
if isempty(P)
    for j = 1 : m
        xs{j} = 1 : ns(j);
    end
    N = [zeros(1, m); ns; zeros(1, m)];
else
    if isAll
        Ran = [ones(1, m); ns];
    else
        Ran = P([1 end], :);
    end
    [Ps, xs, N] = pAll(P, Ran, []);
    Xs = seqInp(Xs, Ps, st('inp', inp));
end
S = zeros(m, 4);
for i = 1 : m
    S(i, :) = n2s(N(:, i));
end
S = S';

% rescale feature
Ys = scaX(Xs, sca);

% main plot
hold on;
bases = dim - 1 : -1 : 0;
for d = 1 : dim
    for i = 1 : m
        for j = 1 : 3
            idx = S(j, i) : S(j + 1, i) - 1;
            if isempty(idx)
                continue;
            end

            c = i;

            % plot
            X = [xs{i}(idx); Ys{i}(d, idx) + bases(d)];
            plotmk(X, c, parMk);

            % cutlines
            if cutWid > 0 && ~isempty(idx) && idx(1) > 1
                xL = mean(xs{i}([idx(1) - 1, idx(1)]));
                plot([xL, xL], [bases(d), bases(d) + 1], 'LineStyle', '--', 'LineWidth', cutWid, 'Color', 'k');
            end
        end
        
        if ~isempty(legs)
            legend(legs{:});
        end
    end
end

% ticks
if ~isempty(nms)
    set(gca, 'ticklength', [0 0]);
    yTis = bases + .5;
    nms = nms(1 : dim);
    set(gca, 'YTick', yTis(end : -1 : 1), 'YTickLabel', nms(end : -1 : 1));
end

% axis
X = cat(2, xs{:});
mi = min(X);
ma = max(X);
parAx = st('box0', [mi, ma; 0, dim]);
h.box = xBox([], parAx);
setAx(h.box, parAx);

% gap line
if gapWid > 0
    for d = 1 : dim - 1
        plot([mi, ma], bases([d d]) - (1 - sca) / 2, '--', 'Color', 'k', 'LineWidth', gapWid);
    end
end
