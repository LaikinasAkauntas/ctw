function wsSub = weiAliSub(act, m, nRep, varargin)
% Obtain list of Weizmann subjects.
%
% Input
%   act     -  act name, 'walk' | 'side' | 'skip' | 'run' | 'jack' | 'jump' | 'pjump' | 'wave1' | 'wave2' | 'bend'
%   m       -  #subs
%   nRep    -  #repetition
%   varargin
%     save option
%
% Output
%   List    -  list of sequences, n x 4
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-02-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-18-2013

% save option
prex = cellStr(act, m, nRep);
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'sub', ...
                   'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('weiAliSub', 'old %s', prex);
    wsSub = matFld(path, 'wsSub');
    return;
end
prIn('weiAliSub', 'new, act %s, m %d, nRep %d', act, m, nRep);

% list
List0 = weiList(act, 'ran', 'y');
m0 = size(List0, 1);

% index of labelled action
vis = ones(1, m0);
for i = 1 : m0
    if isempty(List0{i, 4})
        vis(i) = 0;
    end
end
idx = find(vis == 1);

subIdxs = cell(1, nRep);
for iRep = 1 : nRep
    subIdx0 = randperm(length(idx));
    subIdxs{iRep} = idx(subIdx0(1 : m));
end

% store
wsSub.prex = prex;
wsSub.subIdxs = subIdxs;

% save
if svL > 0
    save(path, 'wsSub');
end

prOut;