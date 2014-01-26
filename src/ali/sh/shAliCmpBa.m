function shAliCmp(Xs, alis, varargin)
% Show alignments.
% 
% Input
%   Xs
%   alis
%   varargin
%     show option
%     ali   -  algorithm, {[]}
%     T     -  flag of plotting ground-truth (in wsSrc), {'y'} | 'n'
%     opt   -  flag of plotting opt (in wsDebg), {'y'} | 'n'
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
fig = ps(varargin, 'fig', 11);
vwAng = ps(varargin, 'vwAng', [70 30]);
bas = ps(varargin, 'bas', []);
all = ps(varargin, 'all', 'y');

% dimension
nAlg = length(alis);

% figure
rows = 3; cols = 2 + nAlg;
axs = iniAx(fig, rows, cols, [200 * rows, 200 * cols], 'wGap', .1, 'hGap', .2);
i = 0;

% objective
i = i + 1;
[objss, algs] = cellss(1, nAlg);
for iAlg = 1 : nAlg
    if isfield(alis{iAlg}, 'objs')
        objss{iAlg} = alis{iAlg}.objs;
    elseif isfield(alis{iAlg}, 'obj')
        objss{iAlg} = alis{iAlg}.obj;
    end

    algs{iAlg} = alis{iAlg}.alg;
end
shObj(objss, 'ax', axs{1, i}, 'algs', algs);
title('objective function');

set(axs{2, i}, 'Visible', 'off');

if isempty(bas)
    set(axs{3, i}, 'Visible', 'off');
else
    Ps = cellFld(bas, 'cell', 'P');
    P = mcat('horz', Ps);
    shP(P, 'ax', axs{3, i}, 'mkSiz', 0, 'nor', 'y');
    title('bases');
end

% original
i = i + 1;
shChans(Xs, 'ax', axs{1, i}, 'mkSiz', 0, 'mkEg', 'n', 'lnWid', 1);
title('original sequence');

shSeqTs(Xs, 'ax', axs{2, i}, 'mkSiz', 0, 'mkEg', 'n', 'lnWid', 1);
view(vwAng);

set(axs{3, i}, 'Visible', 'off');

% algorithm
for iAlg = 1 : nAlg
    shChans(Xs, 'ax', axs{1, iAlg + i}, 'P', alis{iAlg}.P, 'mkSiz', 0, 'mkEg', 'n', 'lnWid', 1, 'all', all);
    title(alis{iAlg}.alg);

    shSeqTs(Xs, 'ax', axs{2, iAlg + i}, 'P', alis{iAlg}.P, 'mkSiz', 0, 'mkEg', 'n', 'lnWid', 1, 'all', all);
    view(vwAng);

    shP(alis{iAlg}.P, 'ax', axs{3, iAlg + i}, 'nMi', 0, 'mkSiz', 0);
end
