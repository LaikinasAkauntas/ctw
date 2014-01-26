function tran = tranInv(tran0)
% Obtain the inverse of the given transform.
%
% Input
%   tran0   -  original transformation
%
% Output
%   tran    -  new transformation
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-19-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-21-2012

% transformation name
algT = tran0.algT;

% similarity transform
if strcmp(algT, 'sim')
    s0 = tran0.s;
    R0 = tran0.R;
    t0 = tran0.t;
    
    s = 1 / s0;
    R = R0';
    t = -s * R * t0;
    
    tran = st('algT', algT, 's', s, 'R', R, 't', t);

% affine transform
elseif strcmp(algT, 'aff')
    V0 = tran0.V;
    t0 = tran0.t;
    
    V = inv(V0);
    t = -V * t0;
    
    tran = st('algT', algT, 'V', V, 't', t);
    
% non-rigid transform
elseif strcmp(algT, 'non')
    tran = tran0;
else
    error('unknown transformation name: %s', algT);
end
