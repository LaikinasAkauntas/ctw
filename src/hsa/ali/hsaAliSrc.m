function wsSrc = hsaAliSrc(act, subIdx, rann, varargin)
% Obtain Humansensing Accelerometer source for alignment.
%
% Input
%   act      -  action type, 'walk' | ... See function hsaList for more details.
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
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2013

% save option
prex = cellStr(act, subIdx, rann);
[svL, path] = psSv(varargin, 'prex', prex, ...
                             'subx', 'src', ...
                             'fold', 'hsa/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('old hsa ali src: %s', prex);
    wsSrc = matFld(path, 'wsSrc');
    return;
end
prIn('new hsa ali src: %s', prex);

% list
List0 = hsaList(act, 'ran', rann);

% src
List = List0(subIdx, :);
m = size(List, 1);
[srcs, parImgs, parMasks, parFlows] = cellss(1, m);
for i = 1 : m
    srcs{i} = hsaSrc(List{i, 1 : 2});
    parImgs{i} = st('morp', 5, 'blur', 5);
    parMasks{i} = st('th', .3, 'debg', 'y');
    Siz = [2 4 8 16; ...
           2 4 8 16];
    parFlows{i} = st('Siz', Siz, 'nB', 4, 'win', 4, 'sig', 4, 'debg', 'n');
end

% store
wsSrc.prex = prex;
wsSrc.srcs = srcs;
wsSrc.rans = List(:, 4);
wsSrc.parImgs = parImgs;
wsSrc.parMasks = parMasks;
wsSrc.parFlows = parFlows;

% save
if svL > 0
    save(path, 'wsSrc');
end

prOut;
