function wsSrc = weiAliSrc(act, subIdx, rann, varargin)
% Obtain Weizmann source for temporal alignment.
%
% Input
%   act      -  action type, 'walk' | ... See function weiList for more details.
%   subIdx   -  subject index, 1 x m
%   rann     -  flag of cutting, 'y' | 'n'
%   varargin
%     save option
%
% Output
%   wsSrc
%     srcs   -  sources, 1 x m (cell)
%     rans   -  range parameter, 1 x m (cell)
%     parFs  -  parameter, 1 x m (cell)
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
prex = cellStr(act, subIdx, rann);
[svL, path] = psSv(varargin, 'prex', prex, ...
                             'subx', 'src', ...
                             'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    prIn('weiAliSrc', 'old, %s', prex);
    wsSrc = matFld(path, 'wsSrc');
    prOut;
    return;
end
prIn('weiAliSrc', 'new, %s', prex);

% list
List0 = weiList(act, 'ran', rann);

% src
List = List0(subIdx, :);
m = size(List, 1);
[srcs, parFs] = cellss(1, m);
for i = 1 : m
    srcs{i} = weiSrc(List{i, 1 : 2});
    parFs{i} = st('hNew', 70, 'nBd', 100, 'k', 20);
end

% store
wsSrc.prex = prex;
wsSrc.srcs = srcs;
wsSrc.rans = List(:, 4);
wsSrc.parFs = parFs;

% save
if svL > 0
    save(path, 'wsSrc');
end

prOut;
