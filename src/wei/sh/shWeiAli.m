function shWeiAli(wsSrc, wsData, P, feats, fig)
% Show alinged frames of the Weizmann sequences.
%
% Input
%   src      -  source
%   wsData   -  data
%     pFss   -  frame index, 1 x m (cell)
%   P        -  time warping, l x m 
%   feats    -  feature names, 1 x m (cell)
%   wsMixs   -  data, 1 x m (cell)
%   fig      -  figure number
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-24-2013

% srcs
[srcs, parFs] = stFld(wsSrc, 'srcs', 'parFs');

% data
pFss = stFld(wsData, 'pFss');

% dimension  
[l, m] = size(P);

% mask
wsMasks = cellss(1, m);
for i = 1 : m
    wsMasks{i} = weiMask(srcs{i}, parFs{i}, 'svL', 2);    
end

% figure
rows = m; cols = l;
figSiz = [50 * rows, 25 * cols];
Ax = iniAx(fig, rows, cols, figSiz, 'wGap', 0, 'hGap', .03);

% plot
for i = 1 : m
    if strcmp(feats{i}, 'XB')
        MBs = wsMasks{i}.MBs(pFss{i});
        for t = 1 : l
            iF = round(P(t, i));
            shM(MBs{iF}, 'ax', Ax{i, t}, 'clMap', 'grayc', 'eq', 'y'); axis off;
        end

    elseif strcmp(feats{i}, 'XE')
        MEs = wsMasks{i}.MEs(pFss{i});
        for t = 1 : l
            iF = round(P(t, i));
            shM(MEs{iF}, 'ax', Ax{i, t}, 'clMap', 'jet', 'eq', 'y'); axis off;
        end

    elseif strcmp(feats{i}, 'XP')
        MPs = wsMasks{i}.MPs(pFss{i});
        for t = 1 : l
            iF = round(P(t, i));
            shM(MPs{iF}, 'ax', Ax{i, t}, 'clMap', 'jet', 'eq', 'y'); axis off;
        end

    elseif strcmp(feats{i}, 'img')
        Pts = wsMasks{i}.Pts(pFss{i});
        for t = 1 : l
            iF = round(P(t, i));
            M = maskP2M(wsMasks{i}.siz, Pts{iF}, 'bkCl', [0 0 0] + .8);
            shImg(M, 'ax', Ax{i, t}, 'eq', 'y'); axis off;
        end

    else
        error('unknown feature: %s', feats{i});
    end
end
