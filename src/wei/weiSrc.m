function src = weiSrc(sub, trl)
% Obtain Weizmann source.
%
% Input
%   sub      -  subject id
%   trl      -  action name, string. if integer, translate it to string.
%
% Output
%   src
%     dbe    -  'wei'
%     sub    -  subject id
%     subNm  -  subject name
%     trl    -  action
%     trlNm  -  action name
%     nm     -  full name
%     dire   -  directions of action movement, 'l' | 'r'
%               'l': right -> left 
%               'r': left -> right
%     pos    -  index of frame as the mean shape
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% subject
subs = {'daria', 'denis', 'eli', 'ido', 'ira', 'lena', 'lyova', 'moshe', 'shahar'};
if ischar(sub)
    subNm = sub;
else
    subNm = subs{sub};
end

% action
trls = {'walk', 'side', 'skip', 'run', 'jack', 'jump', 'pjump', 'wave1', 'wave2', 'bend'};
if ischar(trl)
    trlNm = trl;
else
    trlNm = trls{trl};
end

% full name
nm = sprintf('%s_%s', subNm, trlNm);

% action direction & masks
WEI = weiHuman;
if ~isfield(WEI, nm)
    error('unknown src: %s_%s', subNm, trlNm);
end

% store
src.dbe = 'wei';
src.sub = sub;
src.subNm = subNm;
src.trl = trl;
src.trlNm = trlNm;
src.nm = nm;
src.dire = WEI.(nm).dire;
src.pos = WEI.(nm).pos;
