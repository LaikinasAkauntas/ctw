function Box = maskBox(Pts, varargin)
% Obtain bounding box of mask.
%
% Input
%   Pts     -  mask point, 1 x nF (cell), (2 + nChan) x nPt
%
% Output
%   Box     -  bounding box, dim x 2 x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-24-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

nF = length(Pts);
Box = zeros(2, 2, nF);
for iF = 1 : nF
    Box(:, 1, iF) = min(Pts{iF}([1 2], :), [], 2);
    Box(:, 2, iF) = max(Pts{iF}([1 2], :), [], 2);
end
