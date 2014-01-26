function wsSrc = cmuAliSrc(act, subIdx, rann, varargin)
% Obtain CMU mocap source for alignment.
%
% Input
%   act      -  action type, 'walk' | ... See function cmuList for more details.
%   subIdx   -  subject index, 1 x m
%   rann     -  flag of cutting, 'y' | 'n'
%   varargin
%     save option
%
% Output
%   wsSrc
%     srcs   -  srcs, 1 x m (cell)
%     parFs  -  feature parameter, 1 x m (cell)
%     rans   -  range parameter, 1 x m (cell)
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-20-2013

% save option
prex = cellStr(act, subIdx, rann);
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'src', ...
                   'fold', 'cmu/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('cmuAliSrc', 'old %s', prex);
    wsSrc = matFld(path, 'wsSrc');
    return;
end
prIn('cmuAliSrc', 'new %s', prex);

% list
List0 = cmuList(act, 'ran', rann);

% src
List = List0(subIdx, :);
m = size(List, 1);
[srcs, parFs] = cellss(1, m);
for i = 1 : m
    srcs{i} = cmuSrc(List{i, 1 : 2});
    parFs{i} = st('setNm', 'barbic', 'feat', 'log');
end

% store
wsSrc.prex = prex;
wsSrc.srcs = srcs;
wsSrc.parFs = parFs;
wsSrc.rans = List(:, 4);

% save
if svL > 0
    save(path, 'wsSrc');
end

prOut;
