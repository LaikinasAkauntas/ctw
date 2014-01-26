function wsFlow = hsaFlow(src, wsInit, wsMask, parFlow, parImg, varargin)
% Obtain the optical flow for HSA sequence.
%
% Input
%   src       -  hsa source
%   wsInit    -  template for tracking
%   wsMask    -  mask
%   par       -  flow parameter
%     mask    -  flag of refining by using mask, {'y'} | 'n'
%     sizTem  -  predefined size of template, {[140, 70]}
%     Siz     -  size, 2 x nH, {[2 4; 2 4]}
%     nB      -  #bins, {4}
%     debg    -  flag of debugging, 'y' | {'n'}
%   varargin
%     save option
%     
% Output
%   wsFlow
%     areas   -  area position, 1 x nH (cell), see function areaDiv for more details
%     VHs     -  optical flow histogram, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nB x nF
%     VIs     -  optical flow in column (y) direction, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nF
%     VJs     -  optical flow in row (x) direction, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nF
%     boxs    -  the best matched part in each frame (upper-left corner), 2 x nF
%     fTems   -  initial template, 1 x 2 (cell)
%     sizTem  -  size of initial template
%     siz     -  size of frames
%     nF      -  #frames
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn(1);

% save option
[svL, path] = psSv(varargin, 'fold', 'hsa/flow', ...
                             'prex', src.nm, ...
                             'subx', 'flow');

% load
if svL == 2 && exist(path, 'file')
    pr('old hsa flow: %s', src.nm);
    wsFlow = matFld(path, 'wsFlow');
    prIn(0);
    return;
end
pr('new hsa flow: %s', src.nm);

% function parameter
isMask = psY(parFlow, 'mask', 'y');
sizTem = ps(parFlow, 'sizTem', [12, 10] * 12);
Siz = ps(parFlow, 'Siz', [2 4; 2 4]);
nB = ps(parFlow, 'nB', 4);
win = ps(parFlow, 'win', 2);
sig = ps(parFlow, 'sig', 2);
th = ps(parFlow, 'th', 0);
isDebg = psY(parFlow, 'debg', 'n');

% path
wsPath = hsaPaths(src);

% video
hr = vReader(wsPath.vdo, 'comp', 'img', 'cl', 'gray', 'form', 'double');
[siz0, nF] = stFld(hr, 'siz', 'nF');

% template
FTem0 = wsInit.fTem;

% mask
Ln0s = wsMask.Lns;

% re-size
sizTem0 = size(FTem0);
FTem = imresize(FTem0, sizTem);
siz = floor(siz0 * sizTem(1) / sizTem0(1));

% bin position
nH = size(Siz, 2);
Siz = [Siz, sizTem(:)];
areas = areaDiv(Siz);
[VHs, VIs, VJs] = cellss(1, nH);
for c = 1 : nH
    VHs{c} = zeross(Siz(1, c), Siz(2, c), nB, nF);
    [VIs{c}, VJs{c}] = zeross(Siz(1, c), Siz(2, c), nF);
end

% debug
if isDebg
    rows = 2; cols = 3;
    Ax = iniAx(1, rows, cols, [siz(1) * rows, siz(2) * cols], 'pos', [0 0 1 .95]);
    axTs = iniAx(0, 1, 1, [], 'pos', [0 .95 1 .05], 'ax', 'n'); axT = axTs{1};
end

Fs = zeross(siz(1), siz(2), 2);
boxs = zeros(2, 2, nF);
vCols = zeros(1, nF);
Pts = cell(1, nF);
prIn(1);
for iF = 1 : nF
    prCo(iF, nF, .1);

    % index
    iFCurr = mod(iF - 1, 2) + 1;
    iFLast = mod(iF, 2) + 1;
    
    % blur
    F0 = vRead(hr, iF);
    F0 = imgBlur(F0, parImg);

    % re-size
    Fs(:, :, iFCurr) = imresize(F0, siz);
    M0 = maskL2M(siz0, Ln0s{iF});
    M = imresize(M0, siz);
    M = round(M);
    Pts{iF} = maskM2P(M);

    % cross-correlation
    [head, vCols(iF), Col] = imgCol(FTem, Fs(:, :, iFCurr));

    % refine correlation with mask
    if isMask
        [head, vCols(iF), Col2] = kthColMask(Col, Pts{iF}, sizTem);
    end
    boxs(:, :, iF) = [head, head + sizTem' - 1];

    % optical flow
    if iF > 1
        [VJ0, VI0] = optFlowLk(Fs(:, :, iFLast), Fs(:, :, iFCurr), [], win, sig, 3e-6);
        VI = imgCrop(VI0, boxs(:, :, iF));
        VJ = imgCrop(VJ0, boxs(:, :, iF));

        % histogram
        for c = nH : -1 : 1
            if c == nH
                VIs{c}(:, :, iF) = areaAve(VI, areas{c});
                VJs{c}(:, :, iF) = areaAve(VJ, areas{c});
                VHs{c}(:, :, :, iF) = areaHst(VI, VJ, areas{c}, nB);
            else
                VIs{c}(:, :, iF) = areaAve(VIs{c + 1}(:, :, iF), areas{c});
                VJs{c}(:, :, iF) = areaAve(VJs{c + 1}(:, :, iF), areas{c});
                for iB = 1 : nB
                    VHs{c}(:, :, iB, iF) = areaAve(VHs{c + 1}(:, :, iB, iF), areas{c});
                end
            end
        end
    end

    % debug
    if isDebg
        s = sprintf('Frame: %d/%d', iF, nF);
        shStr(s, 'ax', axT, 'ftSiz', 15);

        cen = (boxs(:, 1, iF) + boxs(:, 2, iF)) / 2;
        shImg(Fs(:, :, iFCurr), 'ax', Ax{1, 1});
        hold on; plot(cen(2), cen(1), '+r');
        
        shImg(Col, 'ax', Ax{1, 2});
        hold on; plot(cen(2), cen(1), '+r');

        M = maskP2M(siz, Pts{iF});
        shImg(M, 'ax', Ax{2, 1});
        
        if isMask
            shImg(Col2, 'ax', Ax{2, 2});
            hold on; plot(cen(2), cen(1), '+r');
        end

        FC = imgCrop(Fs(:, :, iFCurr), boxs(:, :, iF));
        shImg(FC, 'ax', Ax{1, 3});

        shImg(FTem, 'ax', Ax{2, 3});
        drawnow;
    end
end
prIn(0);

% first frame
for c = 1 : nH
    VIs{c}(:, :, 1) = VIs{c}(:, :, 2);
    VJs{c}(:, :, 1) = VJs{c}(:, :, 2);
    VHs{c}(:, :, :, 1) = VHs{c}(:, :, :, 2);
end

% filter
% R = src.R;
% [~, pRs] = kthRIdx(src);
% vis1 = oness(1, nF0);
% for iF = 1 : nF0
% 
%     pR = pRs(iF);
%     % ignore frames that close to the boundary
%     if iF - R(1, pR) < 10 || R(2, pR) - iF < 10
%         vis1(iF) = 0;
%     end
% end
% vis1 = vis1 == 1;

% ignore frames that outside the image (i axis)
vis2 = 1 <= boxs(2, 1, :) & boxs(2, 2, :) <= siz(2);
vis2 = vis2(:)';

% ignore frames that has low correlation
vis3 = vCols > th;
vis = vis2 & vis3;
pFs = find(vis);

% store
wsFlow.nF0 = nF;
wsFlow.nF = length(pFs);
wsFlow.pFs = pFs;

wsFlow.VH0s = VHs;
wsFlow.VI0s = VIs;
wsFlow.VJ0s = VJs;
for c = 1 : nH
    VHs{c}(:, :, :, ~vis) = [];
    VIs{c}(:, :, ~vis) = [];
    VJs{c}(:, :, ~vis) = [];
end
wsFlow.VHs = VHs;
wsFlow.VIs = VIs;
wsFlow.VJs = VJs;

wsFlow.box0s = boxs;
wsFlow.boxs = boxs(:, :, vis);

wsFlow.vCol0s = vCols;
wsFlow.vCols = vCols(vis);

wsFlow.Pt0s = Pts;
wsFlow.Pts = Pts(vis);

wsFlow.areas = areas;
wsFlow.FTem = FTem;
wsFlow.siz = siz;
wsFlow.sizTem = sizTem;

% save
if svL > 0
    save(path, 'wsFlow');
end

prIn(0);
