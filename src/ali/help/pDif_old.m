function [dif, nDif] = pDif_old(P1, P2)
% Evaluate the difference between two alignment.
%
% Example
%   input   -  P1 = [1 1 2 3 4 4 4; ...
%                    1 2 3 4 4 5 6]';
%           -  P2 = [1 2 2 2 2 2 3 4 4; ...
%                    1 1 2 3 4 5 5 5 6]';
%   call    -  [dif, nDif] = aliDif(ali1, ali2)
%   output  -  dif = .3, nDif = 8
%
% Input
%   P1      -  warping path, t1 x m
%   P2      -  warping path, t2 x m
%
% Output
%   dif     -  difference rate
%   nDif    -  difference number between two alignment
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-23-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2012

n1 = P1(end, 1);
n2 = P1(end, 2);

B1 = rowBd(P1);
B2 = rowBd(P2);

nDif = 0;
for i = 2 : n1
    gap0 = abs(B1(i - 1, 2) - B2(i - 1, 2));
    gap = abs(B1(i, 1) - B2(i, 1));
    
    nDif = nDif + gap0 + .5 * (gap0 ~= gap);
end
nAll = (n1 - 1) * (n2 - 1);

% dif = nDif / nAll;
dif = nDif / ((n1 + n2) / 2);
