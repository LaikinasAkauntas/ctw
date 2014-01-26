function shImgUpd(ha, F)
% Update image in 2-D.
%
% Input
%   ha      -  handle
%   F       -  image
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-16-2012

set(ha.haImg, 'CData', F);
