function [X, seg, Cs, inds, pcs] = marSeg(X0, seg0, C0s, T0, varargin)
% Transform the symmetric alignment to the asymmetric alignment.
%
% Input
%   X0      -  original sequence, dim x n0
%   seg0    -  original segmentation
%   C0s     -  original correspondence, m x m
%   T0      -  dtak kernel, m x m
%   varargin
%     aprx  -  approximation method, {'mid'} | 'fst' | 'lst'
%              'mid': 
%              'fst':
%              'lst':
%
% Output
%   X       -  new sequence, dim x n
%   seg     -  new segmentation
%   Cs      -  new correspondence, m x m
%   inds    -
%   pcs     -
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-16-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% original segmentation
s0 = seg0.s; G0 = seg0.G; l0 = G2L(G0);
[k, m] = size(G0);

[Xs, indss] = cellss(1, m);
Cs = cellss(m, m);
pcs = zeros(1, k);
for c = 1 : k
    cVis = l0 == c;
    cIdx = find(cVis);

    % centroid of each class
    pc = meKnl(T0(cVis, cVis));
    pc = cIdx(pc);
    pcs(c) = pc;

    for i = 1 : m
        if l0(i) ~= c
            continue;
        end

        % adjust the correspondence
        C0 = C0s{pc, i};
        C = marC(C0, varargin{:});

        indss{i} = C(2, :) + s0(i) - 1;
        Xs{i} = X0(:, C(2, :) + s0(i) - 1);
        Cs{pc, i} = C;
        Cs{i, pc} = C;
    end
end
X = cat(2, Xs{:});
inds = cat(2, indss{:});
ns = cellDim(Xs, 2);

% new segmentation
seg = seg0;
seg.s = n2s(ns);
