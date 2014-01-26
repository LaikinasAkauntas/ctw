function wsBk = kitVdoBk(src, varargin)
% Obtain kit source.
%
% Input
%   dbe       -  database name, 'moc' | 'kit'
%   sub       -  subject id, integer or character
%   trl       -  trial id, integer or character
%
% Output
%   src
%     dbe     -  database name
%     sub     -  subject id
%     subNm   -  subject name
%     trl     -  trial id
%     trlNm   -  trial name
%     nm      -  a string which is composed as "dbe_subNm_trlNm"
%     seg     -  segmentation (ground truth)
%     cnames  -  class names for segment
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn(1);

% save option
[svL, path] = psSv(varargin, 'subx', 'bk', ...
                             'fold', 'kit/vdo', ...
                             'prex', src.nm);

% load
if svL == 2 && exist(path, 'file')
    pr('old kit vdo bk: %s', src.nm);
    wsBk = matFld(path, 'wsBk');
    return;
end
pr('new kit vdo bk: %s', src.nm);

% path
[~, ~, avipath] = kitPaths(src);

% open avi
hr = vReader(avipath, 'comp', 'img', 'gray', 'y');
[nF, siz] = stFld(hr, 'nF', 'siz');

% read each frame
[Me, Var] = zeross(siz(1), siz(2));
for iF = 1 : nF
    promCo('t', iF, nF, 100);

    F = vRead(hr, iF);
    Me = Me + F;
    Var = Var + F .^ 2;
    
    % check the content of frame
    if min(F(:)) == max(F(:))
        error('error image: %d', iF);
    end
end
Me = Me / nF;
Var = Var / nF - Me .^ 2;

% store
wsBk.Me = Me;
wsBk.Var = Var;

% save
if svL > 0
    save(path, 'wsBk');
end
