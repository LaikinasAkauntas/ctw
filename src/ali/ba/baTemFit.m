function a = baTemFit(p, ba, qp)
% Fit a monotonic function with temporal basis.
%
% Input
%   p       -  monotonic function, l x 1
%   ba      -  basis
%   qp      -  algorithm for quadartic programming, See function qprog for more details
%
% Output
%   a       -  weight, k x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-26-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-16-2012

p = p(:);

% constraint
[L, b] = ftwCont(ba);

% objective
H = ba.P' * ba.P;
f = -p' * ba.P;

% check
if rank(H) < size(H, 1)
    warning('MATLAB:LoadErr', 'rank-deficient');
end

% optimization
a = optQuad(qp, H, f, L, [], b, [], [], []);
