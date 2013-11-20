function src = kitSrc(sub, trl, sen)
% Obtain Kitchen source.
%
% Input
%   sub       -  subject id, integer or character
%   trl       -  trial id, integer or character
%   sen       -  sensor, 'v11' | 'v12' | 'v13' | 'v21' | 'v22' | 'v23' | 'v5' | 'v6'
%
% Output
%   src
%     dbe     -  'kit'
%     sub     -  subject id
%     subNm   -  subject name
%     trl     -  trial id
%     trlNm   -  trial name
%     nm      -  full name
%     seg     -  segmentation (ground truth)
%     cnames  -  class names for segment
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% subject
if ischar(sub)
    subNm = sub;
else
    subNm = sprintf('%.2d', sub);
end

% action
if ischar(trl)
    trlNm = trl;
else
    trlNm = sprintf('%.2d', trl);
end

% full name
nm = sprintf('%s_%s_%s', subNm, trlNm, sen);

% store
src.dbe = 'kit';
src.sub = sub;
src.subNm = subNm;
src.trl = trl;
src.trlNm = trlNm;
src.nm = nm;
src.sen = sen;
