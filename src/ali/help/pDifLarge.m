function dif = pDifLarge(P1, P2)
% Compute the difference between alignments.
%
% Example
%   input   -  P1 = [1 1 2 3 4 4 4; ...
%                    1 2 3 4 4 5 6]';
%           -  P2 = [1 2 2 2 2 2 3 4 4; ...
%                    1 1 2 3 4 5 5 5 6]';
%   call    -  dif = pDif(P1, P2)
%   output  -  dif = .3, nDif = 8
%
% Input
%   P1      -  warping path, l1 x m
%   P2      -  warping path, l2 x m
%
% Output
%   dif     -  difference rate
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-23-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2012

%tic;

% dimension
l1 = size(P1, 1);
l2 = size(P2, 1);

% nearest neighbour (large-scale NN using kd-tree)
d1s = conDstNear3(P1', P2');
d2s = conDstNear3(P2', P1');

d1 = real(sqrt(d1s));
d2 = real(sqrt(d2s));

% dif = sum(d1) + sum(d2);
dif = (sum(d1) + sum(d2)) / (l1 + l2);

%t = toc;
%fprintf('pDif %.2f seconds\n', t);
