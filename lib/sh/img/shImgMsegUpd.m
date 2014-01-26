function ha = shImgMsegUpd(ha, F, Trk, varargin)
% Show image with color.
%
% Input
%   ha      -  original handle
%   F       -  image, h x w x nChan (uint8)
%   Trk     -  tracking points, 2 x nPt
%   varargin
%     show option
%
% Output
%   hImg    -  figure handle
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% image
set(ha.hImg, 'CData', F);

% all tracking points
for iPt = 1 : ha.nPt
    % update trajectory
    Tra = ha.Tras{iPt};
    if size(Tra, 2) > ha.lenMa - 1
        Tra(:, 1) = [];
    end
    Tra = [Tra, Trk(:, iPt)];
    ha.Tras{iPt} = Tra;

    % show
    set(ha.hTras{iPt}, 'XData', Tra(1, :), 'YData', Tra(2, :));
    set(ha.hPts{iPt}, 'XData', Tra(1, end), 'YData', Tra(2, end));
end
