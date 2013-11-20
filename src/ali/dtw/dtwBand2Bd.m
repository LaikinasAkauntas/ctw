function PBd = dtwBand2Bd(PL, PR)
% Extract boundary for Sakoe-Chiba band.
%
% Input
%   PL      -  left path, lL x 2
%   PR      -  right path, lR x 2
%
% Output
%   PBd     -  boundary, n1 x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
lL = size(PL, 1);
lR = size(PR, 1);
n1 = PL(end, 1);

PBd = zeros(n1, 2);

for t = 1 : lL
    i = PL(t, 1);
    j = PL(t, 2);
    
    if PBd(i, 1) == 0
        PBd(i, 1) = j;
    elseif PBd(i, 1) > j
        PBd(i, 1) = j;
    end
end

for t = 1 : lR
    i = PR(t, 1);
    j = PR(t, 2);

    if PBd(i, 2) == 0
        PBd(i, 2) = j;
    elseif PBd(i, 2) < j
        PBd(i, 2) = j;
    end
end
