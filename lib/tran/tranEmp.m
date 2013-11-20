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
%   modify  -  Feng Zhou (zhfe99@gmail.com), 03-19-2012

flag = false;

% transformation name
algT = ps(tran, 'algT', []);

if isempty(algT)
    flag = true;
    return;
end

% similarity transform
if strcmp(algT, 'sim')
    s = ps(tran, 's', []);
    if isempty(s)
        flag = true;
        return;
    end

% affine transform
elseif strcmp(algT, 'aff')
    V = ps(tran, 'V', []);
    if isempty(V)
        flag = true;
        return;
    end

% non-rigid transform
elseif strcmp(algT, 'non')
    W = ps(tran, 'W', []);
    if isempty(W)
        flag = true;
        return;
    end
    
else
    error('unknown transformation name: %s', algT);
end
