function Pts = maskPix(Pt0s, Fs)
% Attach pixel value to point.
%
% Input
%   Pt0s    -  original points, 1 x nF (cell), 2 x nPt
%   Fs      -  frames, 1 x nF (cell)
%
% Output
%   Pts     -  new points, 1 x nF (cell), (2 + nChan) x nPt
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-05-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
nF = length(Fs);
[h, w, nChan] = size(Fs{1});

Pts = cell(1, nF);
for iF = 1 : nF
    Pt0 = Pt0s{iF};
    nPt = size(Pt0, 2);

    % image
    F = im2double(Fs{iF});
    
    % position
    Pts{iF} = zeros(2 + nChan, nPt);
    Pts{iF}([1 2], :) = Pt0([1 2], :);

    % pixel
    for iChan = 1 : nChan
        idx = sub2ind([h w nChan], Pt0(1, :), Pt0(2, :), zeros(1, nPt) + iChan);
        Pts{iF}(2 + iChan, :) = F(idx);
    end
end
