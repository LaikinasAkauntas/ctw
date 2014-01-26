function ali = pddtw(Xs, ali0, aliT, parDtw)
% Procrust Derivative Dynamic Time Warping (DDTW).
%
% Reference 1
%   Derivative Dynamic Time Warping, SDM, 2001.
%
% Reference 2
%   F. Zhou and F. De la Torre, 
%   "Generalized Time Warping for Multi-modal Alignment of Human Motion", 
%   in CVPR, 2012.
%
% Input
%   Xs      -  original sequences, 1 x m (cell)
%   ali0    -  initial alignment
%   aliT    -  ground-truth alignment (can be [])
%   parDtw  -  parameter, see function dtw for more details
%
% Output
%   ali     -  alignment
%     Ys    -  new sequences (derivative), 1 x 2 (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-11-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2012

% dimension
m = length(Xs);
dim = size(Xs{1}, 1);
ns = cellDim(Xs, 2);
nsStr = vec2str(ns, '%d', 'delim', ' ');
prIn('pddtw', 'dim %d, ns %s', dim, nsStr);

% derivative
Ys = cell(1, m);
for i = 1 : m
    Ys{i} = gradient(Xs{i});
%     Z = Xs{i} * lapl(size(Xs{i}, 2), 'gradient');
%     equal('Z', Z, Ys{i});
end

% Procrust dynamic time warping
ali = pdtw(Ys, ali0, aliT, parDtw);

% store
ali.alg = 'pddtw';
ali.Ys = Ys;

prOut;
