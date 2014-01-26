function [ali, Ys, A, B, tis] = aliImw(Xs, para)
% Iterative Motion Warping (IMW).
%
% Remark
%   X1 must have less frames than X2 does, i.e., n1 < n2
%
% Input
%   Xs       -  original sequences, 1 x 2 (cell)
%   para
%     s      -  slope constraint, {1}
%     lA     -  weight of penalization in spacewarp, {1}
%     lB     -  weight of penalization in spacewarp, {1}
%     debug  -  debug flag, {'y'} | 'n'
%
% Output
%   ali      -  alignment
%   Ys       -  new sequences, 1 x 2 (cell)
%   A        -  scale of space warping matrix, dim x n1
%   B        -  offset of space warping matrix, dim x n1
%   ts       -  time cost at each step, 1 x nT
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-18-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-16-2013

% function option
s = ps(para, 's', 1);
lA = ps(para, 'lA', 1);
lB = ps(para, 'lB', 1);
isDebug = psY(para, 'debug', 'n');

X1 = Xs{1}; X2 = Xs{2};
[dim, n1] = size(X1);

% lengthen one sequence
Y2 = X2;
X2 = lengthen(X2, s);

tis = zeros(1, 100);
co = 0;
X0 = X1;
while true
    % space warp
    if ~exist('A', 'var')
        % init
        A = ones(dim, n1);
        B = zeros(dim, n1);
    else
        co = co + 1;
        tic;
        [A, B, nDim] = spacewarp(X0, X2, C, lA, lB);
        t = toc;
        tis(co) = t / nDim * dim;
    end
    X1 = X0 .* A + B;

    % time warp
    D = conDist(X1, X2);
    [DC, P, L] = timewarp(D, s * s);
    C = dpBack(DC, P, L);

    % debug
    if isDebug
        showSeq({A(1, :), B(1, :)}, 'fig', 2);
    end

    % terminating conditions
    if co > 100
        break;
    end
    if exist('C0', 'var') && all(all(C == C0))
        break;
    end

    C0 = C;
end

C = shorten(C, s);
Y1 = X0 .* A + B;
tis(co + 1 : end) = [];
Ys = {Y1, Y2};

ali = newAli('C', C);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A, B, nDim] = spacewarp(X1, X2, C, lA, lB)
% Performing space warp.
%
% Input
%   X1  -  sample matrix, dim x n1
%   X2  -  sample matrix, dim x n2
%   C   -  correspondence matrix, 2 x nC
%   lA  -  weight of penalization in spacewarp
%   lB  -  weight of penalization in spacewarp
%
% Output
%   A   -  scale of space warping matrix, dim x n1 
%   B   -  offset of space warping matrix, dim x n2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-18-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-23-2010

[dim, n1] = size(X1);
[A, B] = zeross(dim, n1);

W = C2W(C);
W = W';
D = W' * W;
dd = diag(D);

F = lapl(n1) * lA;
G = lapl(n1) * lB;
F2 = F' * F;
G2 = G' * G;

nDim = dim;
for c = 1 : dim
    x1 = X1(c, :); x1 = x1';

    % remove non-informative dimensions
    vis = abs(x1) < eps;
    m = length(find(vis));
%     fprintf('%d/%d\n', m, n1);
    if m > .9 * n1
        nDim = nDim - 1;
        continue;
    end

    x2 = X2(c, :); x2 = x2';

    A11 = diag(dd .* x1 .* x1) + F2; % U' * W' * W * U + F' * F
    A12 = diag(dd .* x1);            % U' * W' * W
    A22 = D + G2;                    % W' * W + G' * G
    tmpA = [A11, A12; A12, A22];

    b2 = W' * x2;
    b1 = x1 .* b2;            % U' * W' * x2;
    tmpb = [b1; b2];

    x = tmpA \ tmpb;
    a = x(1 : n1);
    b = x(n1 + 1 : end);

	A(c, :) = a';
    B(c, :) = b';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C = dpBack(A, P, L)
% Trace back to seek the optimum path.
%
% Input
%   A       -  accumulative cost, n1 x n2 x k
%   P       -  path matrix, n1 x n2 x k
%   L       -  level matrix, n1 x n2 x k
%
% Output
%   C       -  frame correspondance matrix, 2 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-08-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-23-2010

[n1, n2, k] = size(A);

C = zeros(2, n1 + n2 + 10);
[c, l] = min(A(n1, n2, :));
i = n1; j = n2;

m = 1;
C(:, m) = [i; j];
while true
    p = P(i, j, l);
    l = L(i, j, l);

    if p == 0
        break;

    elseif p == 1
        j = j - 1;

    elseif p == 3
        i = i - 1;
        j = j - 1;

    else
        error('unknown path direction');
    end

    m = m + 1;
    C(:, m) = [i; j];
end
C(:, m + 1 : end) = [];
C = C(:, end : -1 : 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = lengthen(X0, s)
% Lengthen a sequence so that each frame has multiple copies.
%
% Input
%   X0      -  original sequence, dim x n0
%   s       -  repetition parameter
%
% Output
%   X       -  new sequence, dim x n (n0 x s)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-07-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-23-2010

[dim, n0] = size(X0);

X = zeros(dim, n0 * s);

for i = 1 : n0
    X(:, (i - 1) * s + 1 : i * s) = repmat(X0(:, i), 1, s);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, idx] = shorten(C0, s)
% Shorten a sequence so that the correspondence should be modified as well.
%
% Input
%   C0      -  original correspondence, 2 x m0
%   s       -  repetition parameter
%
% Output
%   C       -  new correspondence, 2 x m
%   idx     -  index, 1 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-07-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-23-2010

n0 = C0(2, end);

C = C0;
p = 1 : n0;
C(2, :) = floor((p - 1) / s) + 1;

% merge the repeated correspondence
m0 = size(C, 2);
vis = ones(1, m0);

patt = [0; 0];
for i = 1 : m0
    if C(1, i) == patt(1) && C(2, i) == patt(2)
        vis(i) = 0;
    else
        vis(i) = 1;
        patt = C(:, i);
    end
end
C(:, vis == 0) = [];

idx = find(vis == 0);
