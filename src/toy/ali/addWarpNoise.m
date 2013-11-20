function [Xs, C] = addWarpNoise(X0s, C0, noi, win)
% Insert random frame into sequence. Meanwhile, the warping matrix will be modified.
%
% Input
%   X0s     -  original sequence set, 1 x 2 (cell), dimi x n0i
%   C0      -  original correspondence matrix, 2 x m0
%   noi     -  noise level
%   win     -  window size of sequence used for sampling new frame
%
% Output
%   Xs      -  new sequence set, 1 x 2 (cell), dimi x ni
%   C       -  new correspondence matrix, 2 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% orginal data
dims = cellDim(X0s, 1);
n0s = cellDim(X0s, 2);
m0 = size(C0, 2);

% first frame
Xs = cell(1, 2);
for j = 1 : 2
    Xs{j} = zeros(dims(j), n0s(j) * 3);
    Xs{j}(:, 1) = X0s{j}(:, 1);
end
C = ones(2, m0 * 3);
ns = [1, 1];
m = 1;

% insert
is = [1, 1]; t = 1;
co = 0;
xs = cell(1, 2);
while t < m0
    m = m + 1;

    if rand(1) < noi
        co = co + 1;

        p = float2block(rand(1), 2);
        if p == 1
            vis = [1 0];
        elseif p == 2
            vis = [0 1];
        else
            vis = [1 1];
        end

        for j = 1 : 2
            xs{j} = newFrame(X0s{j}, is(j), win);
            if vis(j)
                ns(j) = ns(j) + 1;
                Xs{j}(:, ns(j)) = xs{j};
            end
        end

        C(:, m) = [ns(1); ns(2)];

    else
        t = t + 1;

        for j = 1 : 2
            d = C0(j, t) - C0(j, t - 1);
            C(j, m) = C(j, m - 1) + d;
            
            if d > 0
                is(j) = is(j) + 1;
                ns(j) = ns(j) + 1;
                Xs{j}(:, ns(j)) = X0s{j}(:, is(j));
            end
        end
    end
end
Xs{1}(:, ns(1) + 1 : end) = [];
Xs{2}(:, ns(2) + 1 : end) = [];
C(:, m + 1 : end) = [];

fprintf('#alignment %d #noise frame %d\n', m, co);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = newFrame(X, i, win)
% Generate a new frame by affine transformating the given samples.
%
% Input
%   X       -  sample matrices, dim x n
%   i       -  frame position
%   win     -  window size
%
% Output
%   x       -  generated sample, dim x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[dim, n] = size(X);

i1 = max(1, i - win);
i2 = min(n, i + win);
m = i2 - i1 + 1;

p = rand(m, 1);
p = p / sum(p);

x = X(:, i1 : i2) * p;
