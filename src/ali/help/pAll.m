function [Ps, idxs, N] = pAll(P0, Ran, l, varargin)
% Convert warping path vector to warping path matrix.
%
% p = Ran(1, i) ... P0(1, i) ... P0(end, i) ... Ran(2, i)
%
% Input
%   P0      -  original warping path, l0 x m
%   Ran     -  range, 2 x m
%   l       -  #steps in the body part of warping path, can be []
%   varargin
%     wid   -  width to estimate the derivative, {3}
%
% Output
%   xs      -  new index, 1 x m (cell), li x 1
%   ys      -  new warping path vector, 1 x m (cell), 1 x li
%   N       -  #frames in three parts, 3 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-02-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
wid = ps(varargin, 'wid', 3);

% dimension
[l0, m] = size(P0);

% body
if isempty(l)
    l = l0;
end
idx = round(linspace(1, l0, l));
P = P0(idx, :);

[Ps, idxs] = cellss(1, m);
N = zeros(3, m);
for i = 1 : m
    p = P(:, i)';
    dp = gradient(p);
    dp = abs(dp);

    % head
    dy = sum(dp(1 : wid)) / wid;
    pHd = P0(1, i);
    ranHd = Ran(1, i);
    if ranHd <= pHd - dy
        pH = ranHd : dy : pHd - dy;
    else
        pH = [];
    end
    lH = length(pH);

    % tail
    dy = sum(dp(end - wid + 1 : end)) / wid;
    pTl = P0(end, i);
    ranTl = Ran(2, i);
    if pTl + dy <= ranTl
        pT = pTl + dy : dy : ranTl;
    else
        pT = [];
    end
    lT = length(pT);
    
    Ps{i} = [pH, p, pT]';
    idxs{i} = 1 - lH : l + lT;
    N(:, i) = [lH, l, lT]';
end


