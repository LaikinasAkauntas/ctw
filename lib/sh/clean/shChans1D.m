function shChans1D(Xs, P, parMk, varargin)
% Show sequences with alignment.
%
% Input
%   Xs      -  sequence, 1 x m (cell), 1 x ni
%   P       -  alignments, l x m
%   varargin
%     show option
%     gap   -  gap in y-axis, {0}
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
gap = ps(varargin, 'gap', 0);
inp = ps(varargin, 'inp', 'nearest');

% alignment
if ~isempty(P)
    Xs = seqInp(Xs, P, st('inp', inp));
end

% dimension
X1 = Xs{1};
X2 = Xs{2};
n1 = size(X1, 2);
ma1 = max(X1);
n2 = size(X2, 2);
ma2 = max(X2);

% only 1-D
if size(X1, 1) ~= 1 || size(X2, 1) ~= 1
    error('only 1-D sequence supported');
end

% adjust
X1 = [1 : n1; X1];
X2 = [1 : n2; X2];

% sequence
hold on;
plotmk(X1, 1, parMk);
plotmk(X2, 2, parMk);

% axis
set(gca, 'xlim', [.5 max(n1, n2) + .5], 'ylim', [0 max(ma1, ma2)]);
