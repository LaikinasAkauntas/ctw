function wsSrc = kitAliSrc(act, subIdx, rann, varargin)
% Obtain Kitchen mocap source for alignment.
%
% Input
%   tag      -  src type
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
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% save option
prex = cellStr(act, subIdx, rann);
[svL, path] = psSv(varargin, 'prex', prex, ...
                             'subx', 'src', ...
                             'fold', 'kit/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('kitAliSrc', 'old %s', prex);
    wsSrc = matFld(path, 'wsSrc');
    return;
end
prIn('kitAliSrc', 'new %s', prex);

% list
List0 = kitList(act, 'ran', rann);

% src
List = List0(subIdx, :);
m = size(List, 1);
[srcs, parFs] = cellss(1, m);
for i = 1 : m
    srcs{i} = kitSrc(List{i, 1 : 2}, 'v12');
    parFs{i} = st('setNm', 'all_kit', 'feat', 'log');
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
