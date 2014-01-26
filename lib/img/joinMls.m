function [Mls, seg] = joinMls(Mlss, cs, CMap)
% Join the set of X, and obtain its parameter for segmentation.
%
% Input
%   Xs     -  set of sample matrix, 1 x m (cell)
%   cs     -  original class labels, 1 x m
%   CMap   -  dictionary, maxc x k
%
% Output
%   X      -  concatenated X, dim x n
%   seg    -  segmentation parameter with new class labels
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% #frame
m = length(Mlss); nF = 0; st = ones(1, m + 1);
for i = 1 : m
    tmp = Mlss{i};
    tmpN = length(tmp);
    nF = nF + tmpN;
    st(i + 1) = nF + 1;
end

% frames
Mls = cell(1, nF);
p = 0;
for i = 1 : m
    tmp = Mlss{i};
    tmpN = length(tmp);
    for iF = 1 : tmpN
        Mls{p + iF} = tmp{iF};
    end
    p = p + tmpN;
end

% segmentation parameter
k = size(CMap, 2);
H = CMap(:, cs);
seg.H = H; seg.st = st;
