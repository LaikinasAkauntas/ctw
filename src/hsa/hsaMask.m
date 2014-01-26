function wsMask = hsaMask(src, parMask, parImg, varargin)
% Obtain mask data of HSA sequence.
%
% Input
%   src      -  hsa source
%   parMask  -  parameter for mask
%     th     -  threshold, {.3}
%     debg   -  debugging flag, 'y' | {'n'}
%   parImg   -  parameter for function imgXXX
%   varargin
%     save option
%
% Output
%   wsMask
%     Ln0s   -  mask points (original), 1 x nF (cell)
%     Lns    -  mask points (normalized), 1 x nF (cell)
%     siz    -  mask size (normalized), 1 x 2
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

% save option
[svL, path] = psSv(varargin, 'subx', 'mask', ...
                             'fold', 'hsa/mask', ...
                             'prex', src.nm);

% load
if svL == 2 && exist(path, 'file')
    prInOut('old', 'hsa mask: %s', src.nm);
    wsMask = matFld(path, 'wsMask');
    return;
end
prIn('new', 'hsa mask: %s', src.nm);

% function parameter
th = ps(parMask, 'th', .3);
isDebg = psY(parMask, 'debg', 'n');

% vdo
wsPath = hsaPaths(src);
hr = vdoRIn(wsPath.vdo, 'comp', 'img', 'cl', 'gray', 'form', 'double');
nF = ps(varargin, 'nF', hr.nF);

% bk
R = src.R;
idx = R(1, 1) : R(2, 1);
%[Me, Var] = vdoBk(hr, st('idx', idx), parImg);

if isDebg
    rows = 2; cols = 3;
    axTs = iniAx(1, 1, 1, [150 * rows 200 * cols], 'pos', [0 .95 1 .05], 'ax', 'n'); axT = axTs{1};
    Ax = iniAx(0, rows, cols, [], 'pos', [0 0 1 .95]);
end

% read each frame
Lns = cellss(1, nF);
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);

    % read
    F0 = vdoR(hr, iF);
    
    % blur
    F = imgBlur(F0, parImg);

    % threshold
%     P = exp(-(F - Me) .^ 2 ./ (2 * Var)) ./ sqrt(2 * Var * pi);
%     M0 = P < th;

    % morphological operation
%    M = imgMorp(M0, parImg);
%    Lns{iF} = maskM2L(M);

    % debg
    if isDebg
        s = sprintf('Frame: %d/%d', iF, nF);
        if ~exist('H', 'var')
            hT = shStr(s, 'ax', axT, 'ftSiz', 15);
            H = cell(2, 3);
            H{1, 1} = shImg(F, 'ax', Ax{1, 1});
            H{1, 2} = shM(Me, 'ax', Ax{1, 2}, 'eq', 'y');
            H{1, 3} = shM(Var, 'ax', Ax{1, 3}, 'eq', 'y');
            H{2, 1} = shM(P, 'ax', Ax{2, 1}, 'eq', 'y');
            H{2, 2} = shM(M0, 'ax', Ax{2, 2}, 'eq', 'y');
            H{2, 3} = shM(M, 'ax', Ax{2, 3}, 'eq', 'y');
        else
            shStrUpd(hT, s);
            shImgUpd(H{1, 1}, F);
            shMUpd(H{2, 1}, P);
            shMUpd(H{2, 2}, M0);
            shMUpd(H{2, 3}, M);
        end
        drawnow;
    end
end
prCOut(nF);

% store
% wsMask.Me = Me;
% wsMask.Var = Var;
% wsMask.Lns = Lns;

% save
if svL > 0
    save(path, 'wsMask');
end

prOut;
