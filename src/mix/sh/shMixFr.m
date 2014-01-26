function shMixFr(wsSrcs, wsDatas, feats, P, varargin)
% Show frames of multi-model sequences.
%
% Input
%   src     -  source, 1 x m (cell)
%   pFss    -  frame index, 1 x m (cell)
%   P       -  time warping, l x m 
%   feats   -  feature names, 1 x m (cell)
%   wsMixs  -  data, 1 x m (cell)
%   varargin
%     fig   -  figure number, {10}
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% function option
fig = ps(varargin, 'fig', 10);

% dimension
[l, m] = size(P);

% mix data
[srcs, pFss, wsMixs] = cellss(1, m);
for i = 1 : m
    srcs{i} = wsSrcs{i}.srcs{1};
    pFss{i} = wsDatas{i}.pFss{1};
    
    if strcmp(srcs{i}.dbe, 'cmu')
        wsMixs{i} = cmuMoc(srcs{i}, 'svL', 2);

    elseif strcmp(srcs{i}.dbe, 'wei')
        parF = wsSrcs{i}.parFs{1};
        wsMixs{i} = weiMask(srcs{i}, parF, 'svL', 2);

    elseif strcmp(srcs{i}.dbe, 'hsa')
        parMask = wsSrcs{i}.parMasks{1};
        parImg = wsSrcs{i}.parImgs{1};
        parFlow = wsSrcs{i}.parFlows{1};
%         wsMask = hsaMask(srcs{i}, parMask, parImg, 'svL', 2);
%         wsInit = hsaInit(srcs{i}, parImg, 'svL', 2);
%         wsMixs{i} = hsaFlow(srcs{i}, wsInit, wsMask, parFlow, parImg, 'svL', 2);

    else
        error('unknown dbe: %s', srcs{i}.dbe);
    end
end

% figure
rows = m; cols = l;
figSiz = [100 * rows, 90 * cols];
Ax = iniAx(fig, rows, cols, figSiz, 'wGap', 0, 'hGap', 0);

% moc
lnWid = 1; nkSiz = 7;

% plot
for i = 1 : m
    if strcmp(feats{i}, 'XQ')
        [skel, cord, conn] = stFld(wsMixs{i}, 'skel', 'cord', 'conn');
        cord = cord(:, :, pFss{i});
        for t = 1 : l
            iF = round(P(t, i));
            shMocG(cord, 'ax', Ax{i, t});
            shMocF(cord(:, :, iF), conn, skel, 'cl', 'b', 'lnWid', lnWid, 'nkSiz', nkSiz);
        end

    elseif strcmp(feats{i}, 'XE')
        MEs = wsMixs{i}.MEs(pFss{i});
        for t = 1 : l
            iF = round(P(t, i));
            shM(MEs{iF}, 'ax', Ax{i, t}, 'clMap', 'jet', 'eq', 'y'); axis off;
        end

    elseif strcmp(feats{i}, 'XC')
        [PtCs, Idx] = stFld(wsMixs{i}, 'PtCs', 'Idx');
        k = max(Idx(:));
        G = L2G(Idx(:, iF), k);

        parMk = st('mkSiz', 4, 'lnWid', 1, 'lnWid', 0);
        parAx = st('eq', 'y', 'ij', 'y', 'ax', 'n');
        sh(PtCs{iF}([2 1], :), parMk, parAx, 'ax', ax, 'G', G);

    elseif strcmp(feats{i}, 'img') % image with cropping
        if strcmp(srcs{i}.dbe, 'wei')
            Pts = wsMixs{i}.Pts(pFss{i});
            for t = 1 : l
                iF = round(P(t, i));
                M = maskP2M(wsMixs{i}.siz, Pts{iF}, 'bkCl', [0 0 0] + .6);
                shM(M, 'ax', Ax{i, t}, 'clMap', 'jet', 'eq', 'y'); axis off;
            end
        elseif strcmp(srcs{i}.dbe, 'hsa')
            wsPath = hsaPaths(srcs{i});
            hr = vdoRIn(wsPath.vdo, 'comp', 'img');
%            [boxs, siz, sizTem, Pts] = stFld(wsMixs{i}, 'box0s', 'siz', 'sizTem', 'Pt0s');
            for t = 1 : l
                iF = round(P(t, i));
                pF = pFss{i}(iF);
                F0 = vdoR(hr, pF);
%                F = imresize(F0, siz);
%               FC = imgCrop(F, boxs(:, :, pF));
                FC = F0;
                shImg(FC, 'ax', Ax{i, t});
            end
        else
            error('unsupported dbe: %s', srcs{i}.dbe);
        end

    elseif strcmp(feats{i}, 'img0') % image without cropping
        Pt = wsMixs{i}.Pts{pF};
        M = maskP2M(wsMixs{i}.siz, Pt, 'bkCl', [0 0 0] + .6);
        shM(M, 'ax', ax, 'clMap', 'gray', 'eq', 'y'); axis off;
        
    elseif strcmp(feats{i}, 'XA')
        

    elseif strcmp(feats{i}, 'flow')
        iH = 1;
        [FCs, sizTem] = kthFrsCrop(srcs{i}, wsDatas{i}, iH, idxs{i});
        for iF = 1 : nFs(i)
            [X, Y, Z] = boxGrid(Boxs{i}(:, :, iF), sizTem);
            FC = FCs(:, :, :, iF);
            surface('XData', X, 'YData', Y, 'ZData', Z, 'CData', FC, 'EdgeColor', 'none');
        end

    else
        error('unknown feature: %s', feats{i});
    end
end
