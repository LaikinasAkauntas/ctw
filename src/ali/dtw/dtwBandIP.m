function [PL, PR, PLs, PRs] = dtwBandIP(ns, sca)
% Extract boundary for Itakura Parallelogram band.
%
% Input
%   ns      -  #frames, 1 x 2
%   win     -  width
%
% Output
%   PBds    -  path boundary, 1 x 2 (cell), li x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

n1 = ns(1);
n2 = ns(2);

% left boundary
is = 1 : n1;
j1s = is * sca;
j1s(j1s < 1) = 1;
j1s(j1s > n2) = n2;

j2s = n2 - 1 - sca * (n1 - is);
j2s(j2s < 1) = 1;
j2s(j2s > n2) = n2;

% right boundary
js = 1 : n2;
i1s = js * sca;
i1s(i1s < 1) = 1;
i1s(i1s > n1) = n1;

i2s = n1 - 1 - sca * (n2 - js);
i2s(i2s < 1) = 1;
i2s(i2s > n1) = n1;

% merg
PL1 = [is; j2s]'; PL1 = dtwBdInt(PL1, n1, n2, 1);
PL2 = [i1s; js]'; PL2 = dtwBdInt(PL2, n1, n2, 1);
PLs = {PL1, PL2};
PL = dtwBdMerg(PLs, [n1, n2], 1);

PR1 = [is; j1s]'; PR1 = dtwBdInt(PR1, n1, n2, 2);
PR2 = [i2s; js]'; PR2 = dtwBdInt(PR2, n1, n2, 2);
PRs = {PR1, PR2};
PR = dtwBdMerg(PRs, [n1, n2], 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P = dtwBdInt(P0, n1, n2, dire)
% Interpolation of boundary.
%
% Input
%   S       -  step matrix, n1 x n2
%
% Output
%   PBds    -  path boundary, 1 x 2 (cell), l x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% add point
if P0(1, 1) ~= 1 && P0(1, 2) ~= 1
    P0 = [1, 1; P0];
end

if P0(end, 1) ~= n1 && P0(end, 2) ~= n2
    P0 = [P0; n1, n2];
end

% dimension
l0 = size(P0, 1);
P = zeros(l0 * 5, 2);

l = 1;
P(l, :) = P0(1, :);
for t0 = 2 : l0
    dif = P0(t0, :) - P0(t0 - 1, :);

    if dire == 1
        if dif(1) > 1 && (dif(2) == 0 || dif(2) == 1)
            P(l + 1 : l + dif(1) - 1, 1) = P0(t0 - 1, 1) + 1 : P0(t0, 1) - 1;
            P(l + 1 : l + dif(1) - 1, 2) = P0(t0, 2);
            l = l + dif(1) - 1;
        elseif dif(2) > 1
            P(l + 1 : l + dif(2) - 1, 1) = P0(t0 - 1, 1);
            P(l + 1 : l + dif(2) - 1, 2) = P0(t0 - 1, 2) + 1 : P0(t0, 2) - 1;
            l = l + dif(2) - 1;
        end
        
    elseif dire == 2
        if dif(1) > 1 && (dif(2) == 0 || dif(2) == 1)
            P(l + 1 : l + dif(1) - 1, 1) = P0(t0 - 1, 1) + 1 : P0(t0, 1) - 1;
            P(l + 1 : l + dif(1) - 1, 2) = P0(t0 - 1, 2);
            l = l + dif(1) - 1;
        elseif dif(2) > 1
            P(l + 1 : l + dif(2) - 1, 1) = P0(t0, 1);
            P(l + 1 : l + dif(2) - 1, 2) = P0(t0 - 1, 2) + 1 : P0(t0, 2) - 1;
            l = l + dif(2) - 1;
        end

    else
        error('unknown direction: %d', dire);
    end

    l = l + 1;
    P(l, :) = P0(t0, :);
end
P(l + 1 : end, :) = [];
