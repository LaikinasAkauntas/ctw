function [Pts, sca] = maskNorm(Pt0s, hNew)
% Normalize the mask to the specified height.
%
% Input
%   Pt0s    -  original mask that have been cropped to in a bounding box, 1 x nF (cell), (2 + nChan) x nPt
%   hNew    -  new height, {70}
%
% Output
%   Pts     -  new mask, 1 x nF (cell)
%   sca     -  scale = hOld / hNew
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% average height
nF = length(Pt0s);
Box0 = maskBox(Pt0s);
Siz0 = squeeze(Box0(:, 2, :) - Box0(:, 1, :)) + 1;
hOld = mean(Siz0(1, :));
sca = hOld / hNew;

% scaling
Pts = cell(1, nF);
for iF = 1 : nF

    % original size
    siz0 = Siz0(:, iF);

    % new size
    siz = round(siz0 / sca);

    Pts{iF} = maskResize(siz, siz0, Pt0s{iF});
end
