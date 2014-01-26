function [Pts, Siz, Bd] = maskBd(Pt0s, bd, siz)
% Adjust the mask position.
%
% Input
%   Pt0s    -  original mask points, 1 x nF (cell), (2 + nChan) x nPt
%   bd      -  method of choosing pivoting point, 'corner' | 'center'
%              'corner': put on the upper-left corner
%              'center': put on the center
%   siz     -  predefined siz, [] | 1 x 2
%
% Output
%   Pts     -  new mask points, 1 x nF (cell), (2 + nChan) x nPt
%   Siz     -  size, 2 x nF
%   Bd      -  bound, 2 x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
nF = length(Pt0s);

% bounding box
Box0 = maskBox(Pt0s);

% pivoting position
if strcmp(bd, 'corner')
    Bd = squeeze(Box0(:, 1, :));
    if isempty(siz)
        Siz = squeeze(Box0(:, 2, :) - Box0(:, 1, :)) + 1;
    else
        Siz = repmat(siz(:), 1, nF);
    end

elseif strcmp(bd, 'center')
    if isempty(siz)
        mi = min(Box0(:, 1, :), [], 3);
        ma = max(Box0(:, 2, :), [], 3);
        Bd = repmat(mi, 1, nF);
        Siz = repmat(ma - mi + 1, 1, nF);
    else
        Bd = round(squeeze(Box0(:, 1, :) + Box0(:, 2, :)) / 2 - repmat(siz(:) / 2, 1, nF));
        Siz = repmat(siz(:), 1, nF);
    end
else
    error('unknown method of choosing base points: %s', bd);
end

% new position
Pts = cell(1, nF);
for iF = 1 : nF
    Pt0 = Pt0s{iF};
    nP = size(Pt0, 2);
    Pt0([1 2], :) = Pt0([1 2], :) - repmat(Bd(:, iF), 1, nP) + 1;

    % valid area
    vis = 1 <= Pt0(1, :) & 1 <= Pt0(2, :) & Pt0(1, :) <= Siz(1, iF) & Pt0(2, :) <= Siz(2, iF);
    Pt0 = Pt0(:, vis);

    % adjust
    Pts{iF} = Pt0;
end
