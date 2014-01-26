function [subIdx, subIdxs] = cmuListSel(act, m)
% Obtain list of Weizmann sequences.
%
% Input
%   act     -  act name, 'walk' | 'side' | 'skip' | 'run' | 'jack' | 'jump' | 'pjump' | 'wave1' | 'wave2' | 'bend'
%   varargin
%     ran   -  flag of using range, {'y'} | 'n'
%
% Output
%   List    -  list of sequences, n x 4
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-02-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% list
List0 = cmuList(act, 'ran', 'y');
m0 = size(List0, 1);

% index of labelled action
vis = ones(1, m0);
for i = 1 : m0
    if isempty(List0{i, 4})
        vis(i) = 0;
    end
end
idx = find(vis == 1);

subIdx0 = randperm(length(idx));
subIdx = idx(subIdx0(1 : m));

% double -> cell
subIdxs = cell(1, m);
for i = 1 : m
    subIdxs{i} = subIdx(i);
end
