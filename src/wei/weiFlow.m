 function wsFlow = weiFlow(src, wsMask, parF, varargin)
% Obtain optical flow data for Weizmann sequence.
%
% Input
%   src      -  wei source
%   wsMask   -  mask data
%   parF     -  parameter
%     Siz    -  size of spatial division, 2 x nH, {[2 4; 2 4]}
%     nB     -  #bins, {4}
%     win    -  window size for Lucas-Kanade, {2}
%     sig    -  {2}
%   varargin
%     save option
%     debg   -  flag of debugging, 'y' | {'n'}
%     
% Output
%   wsFlow
%     areas  -  area position, 1 x nH (cell), see function areaDiv for more details
%     VHs    -  optical flow histogram, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nB x nF
%     VIs    -  optical flow in column (y) direction, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nF
%     VJs    -  optical flow in row (x) direction, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nF
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
prex = wsMask.prex;
[svL, path] = psSv(varargin, 'fold', 'wei/flow', ...
                             'prex', prex, ...
                             'subx', 'flow');

% load
if svL == 2 && exist(path, 'file')
    wsFlow = matFld(path, 'wsFlow');
    prInOut('weiFlow', 'old, %s', prex);
    return;
end
prIn('weiFlow', 'new, %s', prex);

% function parameter
Siz = ps(parF, 'Siz', [2 4; 2 4]);
nB = ps(parF, 'nB', 4);
win = ps(parF, 'win', 2);
sig = ps(parF, 'sig', 2);

% function option
isDebg = psY(varargin, 'debg', 'n');

% video
wsVdo = weiVdo(src, 'svL', 2);
[F0s, sizF0, nF] = stFld(wsVdo, 'Fs', 'siz', 'nF');

% mask
[Box, siz, sca, Pts] = stFld(wsMask, 'Box', 'siz', 'sca', 'Pts');
sizF = round(sizF0 / sca);

% bin position
nH = size(Siz, 2);
Siz = [Siz, siz'];
areas = areaDiv(Siz);
[VHs, VIs, VJs] = cellss(1, nH);
for c = 1 : nH
    VHs{c} = zeross(Siz(1, c), Siz(2, c), nB, nF);
    [VIs{c}, VJs{c}] = zeross(Siz(1, c), Siz(2, c), nF);
end

% debug
if isDebg
    rows = 1; cols = 3;
    axs = iniAx(1, rows, cols, [sizF(1) * rows, sizF(2) * cols]);
end

Fs = cell(1, 2);
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);

    % index
    iFCurr = mod(iF - 1, 2) + 1;
    iFLast = mod(iF, 2) + 1;

    % re-size
    F0 = F0s{iF};
    F0 = rgb2gray(im2double(F0));
    Fs{iFCurr} = imresize(F0, sizF);

    % optical flow
    if iF > 1
        [VJ0, VI0] = optFlowLk(Fs{iFLast}, Fs{iFCurr}, [], win, sig, 3e-6);
        VI = imgCrop(VI0, Box(:, :, iF));
        VJ = imgCrop(VJ0, Box(:, :, iF));

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
        cen = (Box(:, 1, iF) + Box(:, 2, iF)) / 2;

        shImg(Fs{iFCurr}, 'ax', axs{1, 1});
        hold on; plot(cen(2), cen(1), '+r');

        FC = imgCrop(Fs{iFCurr}, Box(:, :, iF));
        shImg(FC, 'ax', axs{1, 2});

        shImg(maskP2M(siz, Pts{iF}), 'ax', axs{1, 3});

        drawnow;
    end
end
prCOut(nF);

% first frame
for c = 1 : nH
    VIs{c}(:, :, 1) = VIs{c}(:, :, 2);
    VJs{c}(:, :, 1) = VJs{c}(:, :, 2);
    VHs{c}(:, :, :, 1) = VHs{c}(:, :, :, 2);
end

% store
wsFlow.parF = parF;
wsFlow.VHs = VHs;
wsFlow.VIs = VIs;
wsFlow.VJs = VJs;
wsFlow.areas = areas;

% save
if svL > 0
    save(path, 'wsFlow');
end

prOut;
