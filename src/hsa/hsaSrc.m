function src = hsaSrc(sub, trl)
% Obtain Humansensing Accelerometer source.
%
% Input
%   sub       -  subject, integer id or string id ('feng' | ...)
%   trl       -  trial id
%
% Output
%   src
%     dbe     -  'hsa'
%     sub     -  subject id
%     subNm   -  subject name
%     trl     -  trial id
%     trlNm   -  trial name
%     nm      -  full name
%     seg     -  segmentation (ground truth)
%     cnames  -  class names for segment
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-27-2010
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% subject
subNms = {'feng'};
if ischar(sub)
    subNm = sub;
else
    subNm = subNms{sub};
end

% action
if ischar(trl)
    trlNm = trl;
else
    trlNm = sprintf('%.2d', trl);
end

% full name
nm = sprintf('%s_%s', subNm, trlNm);

% human label
HSA = hsaHuman;
if isfield(HSA, nm)
    src.R = HSA.(nm).R;
end

% store
src.dbe = 'hsa';
src.sub = sub;
src.subNm = subNm;
src.trl = trl;
src.trlNm = trlNm;
src.nm = nm;
