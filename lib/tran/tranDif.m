function flag = tranDif(tran1, tran2, par)
% Check whether two transformations are the same or not
%
% Input
%   tran1   -  1st transformation
%   tran2   -  2nd transformation
%   par     -  parameter
%     th    -  threshold, {1e-6}
%
% Output
%   flag    -  flag
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-16-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-22-2012

% function option
th = ps(par, 'th', 1e-6);

% transformation name
algT = tran1.algT;

flag = false;

% similarity transformation
if strcmp(algT, 'sim')
    R1 = tran1.R;
    s1 = tran1.s;    
    
    R2 = tran2.R;
    s2 = tran2.s;

    if max(abs(R1(:) - R2(:))) < th && abs(s1 - s2) < th
        flag = true;
    end

% affine transformation
elseif strcmp(algT, 'aff')
    V1 = tran1.V;
    V2 = tran2.V;

    if max(abs(V1(:) - V2(:))) < th
        flag = true;
    end

% non-rigid transform
elseif strcmp(algT, 'non')
    W1 = tran1.W;
    W2 = tran2.W;
    
    if max(abs(W1(:) - W2(:))) < th
        flag = true;
    end
    
else
    error('unknown transformation name: %s', algT);
end
