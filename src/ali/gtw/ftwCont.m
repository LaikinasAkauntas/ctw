function [L, b] = ftwCont(ba)
% Obtain constraint for FTW.
%
% Input
%   ba      -  basis
%     P     -  warping function, l x k
%     sig   -  sign, k x 1
%     n     -  #samples
%
% Output
%   L       -  (k + 1) x k
%   b       -  (k + 1) x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-18-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% basis
[P, sig, n] = stFld(ba, 'P', 'sig', 'n');

% dimension
[l, k] = size(P);

% sign of basis
idxP = find(sig > 0);
idxN = find(sig < 0);
kP = length(idxP);
kN = length(idxN);

% sign constraint
LSig = zeros(kP + kN, k);
if kP > 0
    LSig(sub2ind(size(LSig), 1 : kP, idxP)) = -1;
end
if kN > 0
    LSig(sub2ind(size(LSig), kP + 1 : kP + kN, idxN)) = 1;
end
bSig = zeros(kP + kN, 1);

% boundary constraint
LBd = [-P(1, :); P(l, :)];
bBd = [-1; n];

% put together
L = [LSig; LBd];
b = [bSig; bBd];
