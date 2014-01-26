function VH = areaHst(VI, VJ, area, nB)
% Obtain the histogram for each area.
%
% Input
%   VI      -  direction, h0 x w0
%   VJ      -  direction, h0 x w0
%   area    -  area position
%     iHs   -  1 x h
%     iTs   -  1 x h
%     jHs   -  1 x w
%     jTs   -  1 x w
%   nB      -  #bin
%
% Output
%   VH      -  histogram, h x w x nB
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[h0, w0] = size(VI);
[iHs, iTs, jHs, jTs] = stFld(area, 'iHs', 'iTs', 'jHs', 'jTs');
h = length(iHs);
w = length(jHs);

% Area & Bin centers
iMs = round((iHs + iTs) / 2);
jMs = round((jHs + jTs) / 2);
bMs = linspace(-pi, pi, nB + 1);
bMs(end) = [];
bMs = bMs + pi / nB;

% megtitude
Meg = sqrt(VI .^ 2 + VJ .^ 2);

% direction
Dire = atan2(VI, VJ);

% histogram
VH = zeros(h, w, nB);
for i0 = 1 : h0
    for j0 = 1 : w0
        % bin that the pixel lies in
        [pR, wR] = nearCenter(i0, iMs);
        [pC, wC] = nearCenter(j0, jMs);
        [pB, wB] = nearCenterRound(Dire(i0, j0), bMs);

        for ii = 1 : length(pR)
            for jj = 1 : length(pC)
                for kk = 1 : length(pB)
                    pr = pR(ii); pc = pC(jj); pb = pB(kk);
                    wr = wR(ii); wc = wC(jj); wb = wB(kk);

                    VH(pr, pc, pb) = VH(pr, pc, pb) + wr * wc * wb * Meg(i0, j0);
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p, w] = nearCenter(x, center)
% Obtain the index and weight of nearest center.
%
% Input
%   x       -  x
%   center  -  center position, 1 x nC
%
% Output
%   p       -  center index, 1 x m (1 | 2)
%   w       -  weights, 1 x m

nC = length(center);

% first or last
if x <= center(1)
    p = 1; w = 1;
    return;
elseif x >= center(nC)
    p = nC; w = 1;
    return;    
end

% between two centers
for c = 1 : nC - 1
    if x >= center(c) && x < center(c + 1)
        p = [c, c + 1];
        w1 = (center(c + 1) - x) / (center(c + 1) - center(c));
        w = [w1, 1 - w1];
        return;
    end
end

p = 0; w = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p, w] = nearCenterRound(x, center)
% Obtain the index and weight of nearest center.
%
% Input
%   x       -  x
%   center  -  center position, 1 x nC
%
% Output
%   p       -  center index, 1 x m (1 | 2)
%   w       -  weights, 1 x m

nC = length(center);

% first or last
if x <= center(1) || x >= center(nC)
    p = [1, nC];
else
    for c = 1 : nC - 1
        if x >= center(c) && x < center(c + 1)
            p = [c, c + 1];
            break;
        end
    end
end

w = cos(x - center(p));
