function src = cmuSrc(sub, trl)
% Obtain a CMU Mocap source.
%
% Input
%   sub      -  subject id, e.g., 86 | '86'
%   trl      -  trial id, e.g., 1 | '01'
%
% Output
%   src
%     dbe    -  'cmu'
%     sub    -  subject id
%     subNm  -  subject name
%     trl    -  trial id
%     trlNm  -  trial name
%     nm     -  full name
%     seg    -  ground-truth segmentation (can be [])
%     cNms   -  class names for segment (can be [])
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

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
nm = sprintf('%s_%s', subNm, trlNm);
nm2 = sprintf('S%s_%s', subNm, trlNm);
prIn('cmuSrc', '%s', nm);

% human label
CMU = cmuHuman;
if isfield(CMU, nm2)
    src.seg = CMU.(nm2).seg;
    src.cnms = CMU.(nm2).cnames;
end

% store
src.dbe = 'cmu';
src.sub = sub;
src.subNm = subNm;
src.trl = trl;
src.trlNm = trlNm;
src.nm = nm;

prOut;
