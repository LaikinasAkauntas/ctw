function ha = shImgMseg(F, Trk, mseg, lenMa, varargin)
% Show image with color.
%
% Input
%   F       -  image, h x w x nChan (uint8)
%   Trk     -  tracking points, 2 x nPt
%   G       -  label, k x nPt
%   varargin
%     show option
%
% Output
%   hImg    -  figure handle
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);
mkSiz = 5;

% image
hImg = imshow(F);
hold on;

% dimension
if isempty(mseg)
    nPt = 0;
    G = [];
    l = [];
else
    G = mseg.G;
    [~, nPt] = size(G);
    l = G2L(G);
end

% all tracking points
[hTras, hPts, Tras] = cellss(1, nPt);
for iPt = 1 : nPt
    % trajectory
    Tras{iPt} = Trk(:, iPt);
    Tra = Tras{iPt};

    % show
    [mk, cl] = genMkCl(l(iPt));
    hTras{iPt} = plot(Tra(1, :), Tra(2, :), '-', 'Color', cl, 'LineWidth', 1);
    hPts{iPt} = plot(Tra(1, end), Tra(2, end), mk, 'Color', cl, 'MarkerSize', mkSiz);
end

% store
ha.hImg = hImg;
ha.hTras = hTras;
ha.hPts = hPts;
ha.Tras = Tras;
ha.lenMa = lenMa;
ha.mkSiz = mkSiz;
ha.G = G;
ha.l = l;
ha.nPt = nPt;
