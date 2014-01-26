function flag = tranEmp(tran)
% Decide whether a transformation is empty or not.
%
% Input
%   tran    -  transformation
%
% Output
%   flag    -  true | false
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-16-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-22-2012

flag = false;

% transformation name
algT = ps(tran, 'algT', []);

if isempty(algT)
    flag = true;
    return;
end

% similarity transform
if strcmp(algT, 'sim')
    R = ps(tran, 'R', []);
    s = ps(tran, 's', []);
    t = ps(tran, 't', []);
    if isempty(R) || isempty(s) || isempty(t)
        flag = true;
        return;
    end

% affine transform
elseif strcmp(algT, 'aff')
    V = ps(tran, 'V', []);
    t = ps(tran, 't', []);
    if isempty(V) || isempty(t)
        flag = true;
        return;
    end

% non-rigid transform
elseif strcmp(algT, 'non')
    W = ps(tran, 'W', []);
    P = ps(tran, 'P', []);
    sigW = ps(tran, 'sigW', []);
    lamW = ps(tran, 'lamW', []);
    if isempty(W) || isempty(P) || isempty(sigW) || isempty(lamW)
        flag = true;
        return;
    end
    
else
    error('unknown transformation name: %s', algT);
end
