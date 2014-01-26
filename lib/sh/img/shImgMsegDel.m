function ha = shImgMsegDel(ha)
% Show image with color.
%
% Input
%   ha      -  original handle
%   F       -  image, h x w x nChan (uint8)
%   Trk     -  tracking points, 2 x nPt
%   varargin
%     show option
%
% Output
%   hImg    -  figure handle
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% image
delete(ha.hImg);

% all tracking points
for iPt = 1 : ha.nPt
    delete(ha.hTras{iPt});
    delete(ha.hPts{iPt});
end
