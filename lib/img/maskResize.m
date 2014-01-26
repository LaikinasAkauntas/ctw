function Pt = maskResize(siz, siz0, Pt0)
% Re-size mask.
%
% Input
%   siz     -  new size, 1 x 2
%   siz0    -  original size, 1 x 2
%   Pt0     -  original mask, (2 + nChan) x nPt
%
% Output
%   Pt      -  new mask points, (2 + nChan) x nPt
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-05-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% original mask
M0 = maskP2M(siz0, Pt0);
MB0 = maskP2M(siz0, Pt0([1 2], :));

% resize
M = imresize(M0, siz(:)');
MB = imresize(MB0, siz(:)');
MB(MB < 0) = 0;
MB = round(MB);

% new point
PtB = maskM2P(MB);
Pt = maskPix({PtB}, {M});
Pt = Pt{1};
