function [PL, PR, PLs, PRs] = dtwBandSC(ns, win)
% Extract boundary for Sakoe-Chiba band.
%
% Input
%   ns      -  #frames, 1 x 2
%   win     -  width
%
% Output
%   PL      -  left path, lL x 2
%   PR      -  right path, lR x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

n1 = ns(1);
n2 = ns(2);

% width
if win < 1
    win = round(win * (n1 + n2) * .5);
end
win = max(win, abs(n1 - n2));

% left boundary
is = 1 : n1;
j1s = is - win;
j1s(j1s < 1) = 1;
j1s(j1s > n2) = n2;
j2s = is + win;
j2s(j2s < 1) = 1;
j2s(j2s > n2) = n2;

% right boundary
js = 1 : n2;
i1s = js - win;
i1s(i1s < 1) = 1;
i1s(i1s > n1) = n1;
i2s = js + win;
i2s(i2s < 1) = 1;
i2s(i2s > n1) = n1;

% merg
PL1 = [is; j1s]';
PL2 = [i2s; js]';
PLs = {PL1, PL2};
PL = dtwBdMerg(PLs, ns, 1);

PR1 = [is; j2s]';
PR2 = [i1s; js]';
PRs = {PR1, PR2};
PR = dtwBdMerg(PRs, ns, 2);
